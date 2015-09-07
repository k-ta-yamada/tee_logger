require 'tee_logger/version'
require 'tee_logger/base'

# main
module TeeLogger
  DEFAULT_FILE = './tee_logger.log'

  LOGGING_METHODS = %i(debug info warn error fatal)

  LOGGING_METHODS.each do |method_name|
    define_singleton_method(method_name) do |progname = nil, &block|
      logger.send(method_name, progname, &block)
    end
    define_singleton_method("#{method_name}?") do
      logger.send("#{method_name}?")
    end
  end

  class << self
    private

    def logger(logdev = DEFAULT_FILE)
      @logger ||= Base.new(logdev)
    end
  end
end
