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
      # @!macro [attach] logging_methods
      #   @!method $1(progname = nil, disabling_target = nil, &block)
      #   logging $1 level message.
      #   @param progname see also Logger
      #   @param disabling_target (Symbol) valid values => [:console, :logfile]
      #   @param &block see also Logger
      #   @return true
      #   @see Logger
      def define_logging_methods(name)
        define_method(name) do |progname = nil, disabling_target = nil, &block|
          if disabling_target
            disable(disabling_target) { logging(name, progname, &block) }
          else
            logging(name, progname, &block)
          end
        end
      end
      private :define_logging_methods

      # @!macro [attach] loglevel_check_methods
      #   @!method $1(name)
      #   @return [Boolean]
      def define_loglevel_check_methods(name)
        define_method(name) do
          @console.send(name)
          @logfile.send(name)
        end
      end
      private :define_loglevel_check_methods
    end

    attr_reader :level, :progname, :formatter, :datetime_format

    # @param logdev [String]
    # @param shift_age [Integer]
    # @param shift_size [Integer]
    # @see Logger#initialize
    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @console = Logger.new($stdout)
      @logfile = Logger.new(logdev, shift_age, shift_size)
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
      @console.level = @logfile.level = @level = level
    end
    alias_method :sev_threshold, :level
    alias_method :sev_threshold=, :level=

    # @param name [String, Symbol]
    def progname=(name = nil)
      @console.progname = @logfile.progname = @progname = name
    end

    # @param formatter
    def formatter=(formatter)
      @console.formatter = @logfile.formatter = @formatter = formatter
    end

    # @param formatter
    def datetime_format=(format)
      @console.datetime_format =
        @logfile.datetime_format =
          @datetime_format = format
    end

    # @param logdev_name [String, Symbol]
    # @yield before logdev_name disable, after logdev_name enable.
    def disable(logdev_name)
      if block_given?
        disable(logdev_name)
        yield
        enable(logdev_name)
      else
        logdev_instance(logdev_name).formatter = proc { |_, _, _, _| '' }
      end
    end

    # @param logdev_name [String, Symbol]
    def enable(logdev_name)
      logdev_instance(logdev_name).formatter = @formatter
    end

    private

    def logging(name, progname, &block)
      @console.send(name, progname, &block)
      @logfile.send(name, progname, &block)
    end

    def logdev_instance(logdev_name)
      instance_variable_get("@#{logdev_name}")
    end
  end
end
