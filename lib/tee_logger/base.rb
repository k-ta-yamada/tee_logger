require 'logger'

# namespace
module TeeLogger
  # base class
  class Base
    attr_reader :logger, :console

    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @logger  = Logger.new(logdev, shift_age, shift_size)
      @console = Logger.new(STDOUT)
    end

    # logging methods.
    LOGGING_METHODS.each do |method_name|
      define_method(name) do |progname = nil, &block|
        @logger.send(name, progname, &block)
        @console.send(name, progname, &block)
      end
    end

    # check logging level methods.
    LOGGING_METHODS.map { |v| "#{v}?" }.each do |name|
      define_method(name) do
        @logger.send(name)
        @console.send(name)
      end
    end

    # TODO: Implement
    def disable(target)
      # undef_method, remove_method ....
    end

    # TODO: Implement
    def enable(target)
      # undef_method, remove_method ....
    end

    def progname
      # TODO: which?
      # @logger.progname
      @console.progname
    end

    def progname=(name = nil)
      @logger.progname  = name
      @console.progname = name
    end

    def close
      @logger.close
      # @console.close
    end
  end
end
