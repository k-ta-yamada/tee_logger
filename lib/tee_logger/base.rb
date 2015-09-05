require 'logger'
require 'forwardable'
require 'active_support/logger'
require 'active_support/inflector'

module TeeLogger
  class Base
    extend Forwardable
    def_delegators(:@logger, *Logger.instance_methods(false))
    # def_delegators(:@logger, *TeeLogger.singleton_methods)

    # attr_reader :logger, :console

    def initialize(logdev = DEFAULT_FILE)
      @logger = Logger.new(logdev)

      # console_log_class = ActiveSupport::Logger
      console_log_class = Logger
      @console = console_log_class.new(STDOUT)

      @logger.extend(ActiveSupport::Logger.broadcast(@console))
    end
  end
end
