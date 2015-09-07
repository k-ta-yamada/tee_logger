require 'logger'

# main
module TeeLogger
  # TODO: defined by setup method, etc ...
  DEFAULT_FILE = './tee_logger.log'
  LOGGING_METHODS = %i(debug info warn error fatal).freeze

  # base class
  class Base
    def initialize(logdev = DEFAULT_FILE)
      @logfile = Logger.new(logdev)

      console_log_class = Logger
      @console = console_log_class.new(STDOUT)
    end

    LOGGING_METHODS.each do |method_name|
      define_method(method_name) do |progname = nil, &block|
        @logfile.send(method_name, progname, &block)
        @console.send(method_name, progname, &block)
      end

      define_method("#{method_name}?") do
        @logfile.send(method_name)
        @console.send(method_name)
      end
    end
  end
end
