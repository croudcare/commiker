require 'logger'
require_relative 'log/formatter'

module UseCase
  class Configuration
    attr_accessor :log_target, :log_level, :log_formatter, :log_age, :log_size

    def initialize
      @log_target    = nil
      @log_level     = ::Logger::INFO
      @log_formatter = Log::Formatter.new
      @log_age       = 'monthly'
      @log_size      = 4_096_000
    end
  end

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration
      @configuration = Configuration.new
    end
  end
end
