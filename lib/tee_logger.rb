require 'tee_logger/version'
require 'tee_logger/constants'
require 'tee_logger/base'

require 'forwardable'

# namespace
module TeeLogger
  # shortcut for TeeLogger::TeeLogger.new
  def self.new(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
    TeeLogger.new(logdev, shift_age, shift_size)
  end

  class TeeLogger
    extend Forwardable

    attr_reader :logger, :console

    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @base_logger = Base.new(logdev, shift_age, shift_size)
      @logger  = @base_logger.logger
      @console = @base_logger.console
    end

    # logging methods.
    def_delegators :@base_logger, *LOGGING_METHODS

    # check logging level methods.
    def_delegators :@base_logger, *LOGGING_METHODS.map { |v| "#{v}?" }

    # others.
    def_delegators :@base_logger, :progname, :progname=

    # TODO: Implement
    # def_delegators :@base_logger, :datetime_format, :datetime_format=
    # def_delegators :@base_logger, :formatter, :formatter=

    # TODO: Implement
    # def_delegator :@base_logger, :close
    # def_delegators :@base_logger, :level, :sev_threshold
    # def_delegators :@base_logger, :add, :log
    # def_delegators :@base_logger, :unknown, :unknown?
  end
end
