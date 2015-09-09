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
    attr_reader :logger, :console

    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @logger  = Logger.new(logdev, shift_age, shift_size)
      @console = Logger.new($stdout)
    end

    # logging methods.
    LOGGING_METHODS.each do |name|
      define_method(name) do |progname = nil, &block|
        @logger.send(name, progname, &block)
        @console.send(name, progname, &block)
      end
    end

    # check logging level methods.
    LOGGING_METHODS.map { |v| "#{v}?" }.each do |name|
      define_method(name) do
        # TODO: which?
        # @logger.send(name)
        @console.send(name)
      end
    end

    # TODO: Implement!
    def disable(target)
      # binding.pry
      instance_variable_get("@#{target}").formatter = proc { |s, dt, p, m| }
      # undef_method, remove_method ....
    end

    # TODO: Implement!
    def enable(target)
      instance_variable_get("@#{target}").formatter = Logger::Formatter.new
      # undef_method, remove_method ....
    end

    def progname
      # TODO: which?
      # @logger.progname
      @console.progname
    end

    def progname=(name = nil)
      # TODO: which?
      # @logger.progname  = name
      @console.progname = name
    end

    def formatter
      # TODO: which?
      # @logger.formatter
      @console.formatter
    end

    def formatter=(formatter)
      @logger.formatter  = formatter
      @console.formatter = formatter
    end

    # def close
    #   @logger.close
    #   # @console.close
    # end
  end
end
