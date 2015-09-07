require 'logger'

# main
module TeeLogger
  # TODO: defined by setup method, etc ...
  DEFAULT_FILE = './tee_logger.log'
  LOGGING_METHODS = %i(debug info warn error fatal).freeze

  # base class
  class Base
    attr_reader :logger, :console

    def initialize(logdev = DEFAULT_FILE, shift_age = 0, shift_size = 1_048_576)
      @logger  = Logger.new(logdev, shift_age, shift_size)
      @console = Logger.new(STDOUT)
    end

    LOGGING_METHODS.each do |method_name|
      define_method(method_name) do |progname = nil, &block|
        @logger.send(method_name, progname, &block)
        @console.send(method_name, progname, &block)
      end

      define_method("#{method_name}?") do
        @logger.send("#{method_name}?")
        @console.send("#{method_name}?")
      end
    end

    def close
      @logger.close
      # @console.close
    end
  end
end
