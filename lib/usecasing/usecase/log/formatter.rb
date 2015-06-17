require 'logger'

module UseCase
  module Log
    class Formatter < Logger::Formatter
      def call(severity, time, program_name, message)
        "#{time.utc.iso8601(3)} #{::Process.pid} TID-#{Thread.current.object_id.to_s(36)}#{current_execution} #{severity}: #{message}\n"
      end

      def current_execution
        current_context = Thread.current[:execution_context]

        unless current_context.nil?
          " #{current_context[:use_case_class]}##{current_context[:method_name]}"
        end
      end
    end
  end
end