require 'logger'
require 'tee_logger/version'
require 'tee_logger/constants'
require 'tee_logger/configuration'
require 'tee_logger/utils'
require 'tee_logger/tee_logger_base'

# namespace
module TeeLogger
  extend Configration

  # shortcut for TeeLogger::TeeLoggerBase.new
  # @param logdev [String]
  # @param shift_age [Integer]
  # @param shift_size [Integer]
  # @return [TeeLogger::TeeLoggerBase]
  # @see TeeLoggerBase
  def self.new(logdev = nil, shift_age = 0, shift_size = 1_048_576)
    TeeLoggerBase.new(logdev, shift_age, shift_size)
  end

  # define singleton method .logger for your module.
  # and TeeLogger.progname is your module name.
  def self.extended(mod)
    mod.define_singleton_method(:logger) do
      return @logger if @logger
      @logger = TeeLogger.new
      @logger.progname = TeeLogger.progname || mod
      @logger
    end
  end

  # define instance method #logger for your class.
  # and TeeLogger.progname is your class name.
  def self.included(klass)
    klass.class_eval do
      define_method(:logger) do
        return @logger if @logger
        @logger = TeeLogger.new
        @logger.progname = TeeLogger.progname || klass.name
        @logger
      end
    end
  end
end
