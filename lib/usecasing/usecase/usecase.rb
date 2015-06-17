# changes:
# - method before is now called before UseCases set with depends, meaning that
#   the execution order is:
#
#   - before -> dependencies -> perform
#
# - it's now possible to set accessors to attributes in context, for example
#   instead of doing context.parameter we can just write parameter, this can be
#   with class methods:
#
#   - context_reader
#   - context_writer
#   - context_accessor
#
# - you can skip the execution flow by invoking skip!, this will interrupt the
#   current UseCase and it's dependencies like stop!, but it will continue with
#   the following UseCases
#
# - discussion:
#   - what should happen when UseCase is skipped during perform? should we
#     rollback? (currently we don't, I think, it's not really tested :P)
#
# TODO:
#   - rollback only works when a perform is defined, this is because:
#     - we only rollback an execution node if said execution node is for method
#       "perform"
#     - for optimization we only create execution nodes when methods "before"
#       and "perform" are redefined

require_relative 'context'
require_relative 'log'

module UseCase
  class Base
    class << self
      if respond_to?(:delegate)
        def context_accessor(*args)
          args = args.reduce([]) { |array, arg| array.concat([arg, "#{arg}="]); array }

          delegate *args, to: :context
        end

        def context_writer(*args)
          args = args.reduce([]) { |array, val| array << "#{val}="; array }

          delegate *args, to: :context
        end

        def context_reader(*args)
          delegate *args, to: :context
        end
      else
        include Forwardable

        def context_accessor(*args)
          args = args.reduce([]) { |array, arg| array.concat([arg, "#{arg}="]); array }

          def_delegators :context, *args
        end

        def context_writer(*args)
          args = args.reduce([]) { |array, val| array << "#{val}="; array }

          def_delegators :context, *args
        end

        def context_reader(*args)
          def_delegators :context, *args
        end
      end
    end

    def skip!
      @skip_use_case = true
    end

    def invoke!(*use_cases)
      use_cases.each { |use_case| use_case.perform(context) }
    end

    def failure!(status, message = nil)
      context.status.send("#{status}!")

      failure(status, message)
    end

    def status
      context.status
    end
  end

  module BaseClassMethod
    module ClassMethods
      def perform(ctx = {})
        (ctx.is_a?(Context) ? ctx : Context.new(ctx)).tap do |context|
          execution_nodes = ExecutionOrder.run(self)

          execution_nodes.each do |execution_node|
            next unless execute_node?(execution_node, context.skipped_node_ids)

            Log.log_execution execution_node, context do
              execution_node.execute(context)

              if execution_node.skipped?
                context.skipped_node_ids << execution_node.node_id
              elsif execution_node.for_rollback?
                context.executed.push(execution_node.use_case_class)
              end
            end

            break if !context.success? || context.stopped?
          end

          rollback(context.executed, context) unless context.success?
        end
      end

      def execute_node?(execution_node, skipped_node_ids)
        (execution_node.dependent_node_ids & skipped_node_ids).empty?
      end
    end
  end

  class ExecutionOrder
    class ExecutionNode
      attr_reader :dependent_node_ids, :use_case_class, :method_name

      def initialize(dependent_node_ids, use_case_class, method_name)
        @dependent_node_ids = dependent_node_ids
        @use_case_class     = use_case_class
        @method_name        = method_name
      end

      def node_id
        use_case_class.__id__
      end

      # only nodes for method perform are to be rolled back
      def for_rollback?
        @method_name == :perform
      end

      def execute(context)
        @instance = use_case_class.new(context)
        @instance.send(@method_name)
      end

      def skipped?
        !!@instance.instance_variable_get('@skip_use_case')
      end
    end

    class << self
      def post_order(use_case_class, result, dependent_node_ids = [])
        # push node id to group ids
        dependent_node_ids.push(use_case_class.__id__)

        if use_case_class.instance_method(:before).owner != Base
          # only set before method in execution path if it's overridden
          result.push \
            ExecutionNode.new(dependent_node_ids, use_case_class, :before)
        end

        # parse dependencies use_cases
        use_case_class.dependencies.each do |dependency_use_case|
          post_order(dependency_use_case, result, dependent_node_ids.dup)
        end

        # push perform method
        result.push \
          ExecutionNode.new(dependent_node_ids, use_case_class, :perform)
      end
    end
  end
end
