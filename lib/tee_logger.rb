require 'tee_logger/version'
require 'logger'

# namespace
module TeeLogger
  # no param of filename, set this filename
  DEFAULT_FILE = './tee_logger.log'
  # Implements targets
  LOGGING_METHODS = [:debug, :info, :warn, :error, :fatal].freeze

  # shortcut for TeeLogger::TeeLogger.new
  # @see TeeLogger
  def self.new(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
    TeeLogger.new(logdev, shift_age, shift_size)
  end

  # main
  # @see http://www.rubydoc.info/stdlib/logger/Logger Logger
  class TeeLogger
    class << self
      # @!macro [attach] loglevel_check_methods
      #   @!method $1(name)
      #   @return [Boolean]
      def define_loglevel_check_methods(name)
        define_method(name) do
          @logfile.send(name)
          @console.send(name)
        end
      end
      private :define_loglevel_check_methods

      # @!macro [attach] logging_methods
      #   @!method $1(progname = nil, &block)
      #   logging $1 level message.
      #   @return true
      def define_logging_methods(name)
        define_method(name) do |progname = nil, &block|
          @logfile.send(name, progname, &block)
          @console.send(name, progname, &block)
        end
      end
      private :define_logging_methods
    end

    attr_reader :level, :progname, :formatter

    # @param logdev [String]
    # @param shift_age [Integer]
    # @param shift_size [Integer]
    # @see Logger#initialize
    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @logfile = Logger.new(logdev, shift_age, shift_size)
      @console = Logger.new($stdout)
    end

    define_logging_methods :debug
    define_logging_methods :info
    define_logging_methods :warn
    define_logging_methods :error
    define_logging_methods :fatal

    define_loglevel_check_methods :debug?
    define_loglevel_check_methods :info?
    define_loglevel_check_methods :warn?
    define_loglevel_check_methods :error?
    define_loglevel_check_methods :fatal?

    # @param level [Integer]
    def level=(level)
      @logfile.level = level
      @console.level = level
      @level = level
    end
    alias_method :sev_threshold, :level
    alias_method :sev_threshold=, :level=

    # @param name [String, Symbol]
    def progname=(name = nil)
      @logfile.progname = name
      @console.progname = name
      @progname = name
    end

    # @param formatter
    def formatter=(formatter)
      @logfile.formatter = formatter
      @console.formatter = formatter
      @formatter = formatter
    end

    # @param target [String, Symbol]
    # @yield before target disable, after target enable.
    def disable(target)
      if block_given?
        disable(target)
        yield
        enable(target)
      else
        target_instance(target).formatter = proc { |_, _, _, _| '' }
      end
    end

    # @param target [String, Symbol]
    def enable(target)
      target_instance(target).formatter = @formatter
    end

    private

    def target_instance(target)
      instance_variable_get("@#{target}")
    end
  end
end
