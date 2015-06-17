require_relative 'status_matcher'

module UseCase

  class Context

    class Status
      attr_reader :current

      def initialize
        @current = 'ok'
      end

      def method_missing(method, *args, &block)
        matcher = ::UseCase::StatusMatcher.new(method)

        if matcher.match_as_setter?
          @current = matcher.status
        elsif matcher.match_as_question?
          @current == matcher.status
        else
          super
        end
      end

      def respond_to?(method, _include_all = false)
        matcher = ::UseCase::StatusMatcher.new(method)

        matcher.match? || super
      end
    end

    attr_accessor :executed, :skipped_node_ids, :result

    def initialize(param = {})
      unless (param.is_a? ::Hash) || (param.is_a? Context)
        raise ArgumentError.new('Must be a Hash or other Context')
      end

      @values = symbolyze_keys(param.to_hash)
      @errors = Errors.new
      @executed         = []
      @skipped_node_ids = []
      @status = ::UseCase::Context::Status.new
    end

    def respond_to?(method, _include_all = false)
      @values.keys.include?(method.to_sym)
    end

    def status
      @status
    end

    def status=(val)
      raise 'status is a reserved keyword which cannot be set, please use another word'
    end

    def to_s
      @values.to_s
    end

  end

end
