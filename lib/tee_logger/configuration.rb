# namespace
module TeeLogger
  # configuration
  module Configration
    Configration = Struct.new(:logdev)

    # Yields the global configuration to a block.
    # @yield [Configuration] global configuration
    def configure
      yield configuration if block_given?
    end

    # reset configuration
    def configuration_reset
      @configuration = nil
    end

    # set TeeLogger::Configuration::Configration's member :logdev.
    # extend or include TeeLogger then, :logdev is default argument
    # for Logger.new(logdev).
    # @param logdev [String, File]
    def logdev=(logdev)
      configuration.logdev = logdev
    end

    extend Gem::Deprecate
    deprecate :logdev=, 'TeeLogger.configure', 2016, 1

    # @return [String, File] `configuration.logdev` or `DEFAULT_FILE`.
    def logdev
      configuration.logdev || DEFAULT_FILE
    end

    private

    def configuration
      @configuration ||= Configration.new
    end
  end
end
