require 'tee_logger/version'
require 'tee_logger/constants'
require 'tee_logger/utils'
require 'tee_logger/tee_logger_base'
require 'logger'

# namespace
module TeeLogger
  class << self
    # shortcut for TeeLogger::TeeLoggerBase.new
    # @param logdev [String]
    # @param shift_age [Integer]
    # @param shift_size [Integer]
    # @return [TeeLogger::TeeLoggerBase]
    # @see TeeLoggerBase
    def new(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      TeeLoggerBase.new(logdev, shift_age, shift_size)
    end

    # define singleton method .logger for your module.
    # and TeeLogger.progname is your module name.
    def extended(mod)
      mod.class_eval do
        define_singleton_method(:logger) do |logdev = DEFAULT_FILE|
          return @logger if @logger
          @logger = TeeLoggerBase.new(logdev)
          @logger.progname = self
          @logger
        end
      end
    end

    # define instance method #logger for your class.
    # and TeeLogger.progname is your class name.
    def included(klass)
      klass.class_eval do
        define_method(:logger) do |logdev = DEFAULT_FILE|
          return @logger if @logger
          @logger = TeeLoggerBase.new(logdev)
          @logger.progname = self.class.name
          @logger
        end
      end
    end
  end
end
