require 'tee_logger/version'
require 'tee_logger/constants'

require 'logger'

# namespace
module TeeLogger
  # shortcut for TeeLogger::TeeLogger.new
  def self.new(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
    TeeLogger.new(logdev, shift_age, shift_size)
  end

  # main
  class TeeLogger
    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @logfile = Logger.new(logdev, shift_age, shift_size)
      @console = Logger.new($stdout)
    end

    class << self
      # @macro [attach] container.increment
      #   @method $1()
      #   Increment the $1 container.
      def define(name, &block)
        define_method(name, &block)
      end
      private :define
    end

    # define :aaa do
    #   puts 1
    # end
    # define :bbbb do |v = 1|
    #   puts v
    # end

    LOGGING_METHODS.map { |v| "#{v}?".to_sym }.each do |name|
      define(name) do
        @console.send(name)
      end
    end

    # logging methods.
    LOGGING_METHODS.each do |name|
      define_method(name) do |progname = nil, &block|
        @logfile.send(name, progname, &block)
        @console.send(name, progname, &block)
      end
    end

    # TODO: which?
    def level
      @logfile.level
      @console.level
    end

    def level=(level)
      @logfile.level = level
      @console.level = level
    end
    alias_method :sev_threshold,  :level
    alias_method :sev_threshold=, :level=

    # TODO: which?
    def progname
      # @logfile.progname
      @console.progname
    end

    def progname=(name = nil)
      @logfile.progname = name
      @console.progname = name
    end

    # TODO: which?
    def formatter
      # @logfile.formatter
      @console.formatter
    end

    def formatter=(formatter)
      @logfile.formatter = formatter
      @console.formatter = formatter
    end

    # TODO: Too miscellaneous
    def disable(target)
      instance_variable_get("@#{target}").formatter = proc { |_, _, _, _| }
    end

    # TODO: Too miscellaneous
    def enable(target)
      instance_variable_get("@#{target}").formatter = Logger::Formatter.new
    end
  end
end
