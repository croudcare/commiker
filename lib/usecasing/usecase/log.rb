require 'logger'
require_relative 'log/formatter'
require_relative 'configuration'

module UseCase
  module Log
    class << self
      def logger=(logger, close_previous = true)
        @logger.close if close_previous && !@logger.nil?
        @logger = logger
      end

      def logger
        @logger ||= build_logger
      end

      def reset_logger
        self.logger = build_logger
      end

      def build_logger
        config = UseCase.configuration

        logger_params = [
          config.log_target || '/dev/null',
          config.log_age,
          config.log_size
        ].flatten.compact

        ::Logger.new(*logger_params).tap do |l|
          l.formatter = config.log_formatter
          l.level     = config.log_level
        end
      end

      def log_execution(execution_node, context)
        return unless block_given?

        set_execution_context(execution_node, context)

        start = Time.now

        logger.info { "start! context: #{context}" }

        yield logger

        logger.info { 'skipping node!' }    if execution_node.skipped?
        logger.info { 'stopping chain!' }   if context.stopped?
        logger.info { 'failure signaled!' } unless context.success?
        logger.info { "done (#{(Time.now - start).to_f.round(3)} sec)! context: #{context}" }
      rescue => e
        logger.error { "fail (#{(Time.now - start).to_f.round(3)} sec)! #{e.backtrace.insert(0, e.message).join("\r\n  ")}" }

        raise
      ensure
        clear_execution_context
      end

    protected

      def set_execution_context(execution_node, context)
        Thread.current[:execution_context] = {
          use_case_class: execution_node.use_case_class,
          method_name:    execution_node.method_name,
          context:        context
        }
      end

      def clear_execution_context
        Thread.current[:execution_context] = nil
      end
    end
  end
end
