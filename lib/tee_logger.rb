require 'tee_logger/version'
require 'tee_logger/base'

# main
module TeeLogger

  LOGGING_METHODS.each do |method_name|
    define_singleton_method(method_name) do |progname = nil, &block|
      logger.send(method_name, progname, &block)
    end

    define_singleton_method("#{method_name}?") do
      logger.send("#{method_name}?")
    end
  end

  class << self
    def logfile
      logger.instance_variable_get("@#{__method__}".to_sym)
    end

    def console
      logger.instance_variable_get("@#{__method__}".to_sym)
    end

    private

    def logger(logdev = DEFAULT_FILE)
      @logger ||= Base.new(logdev)
    end
  end
end
