require 'logger'
require 'forwardable'
require 'active_support/logger'
require 'active_support/inflector'

# main
module TeeLogger
  # base class
  class Base
    extend Forwardable
    def_delegators(:@logger, *Logger.instance_methods(false))

    def initialize(logdev = DEFAULT_FILE)
      @logger = Logger.new(logdev)

      # console_log_class = ActiveSupport::Logger
      console_log_class = Logger
      @console = console_log_class.new(STDOUT)

      @logger.extend(ActiveSupport::Logger.broadcast(@console))
    end
  end
end
