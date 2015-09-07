require 'tee_logger/version'
require 'tee_logger/base'

# main
module TeeLogger
  DEFAULT_FILE = './tee_logger.log'

  %i(debug info warn error fatal).each do |method_name|
    define_singleton_method method_name do |msg = nil|
      logger.send(method_name, msg)
    end
  end

  class << self
    private

    def logger(logdev = DEFAULT_FILE)
      @logger ||= Base.new(logdev)
    end
  end
end
