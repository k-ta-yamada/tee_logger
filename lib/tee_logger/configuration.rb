# namespace
module TeeLogger
  # configuration
  module Configration
    extend Gem::Deprecate

    Configration = Struct.new(:logdev,
                              :level,
                              :progname,
                              :formatter,
                              :datetime_format)

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
    deprecate :logdev=, 'TeeLogger.configure', 2016, 1

    # @return [String, File] `configuration.logdev` or `DEFAULT_FILE`.
    def logdev
      configuration.logdev || DEFAULT_FILE
    end

    def level
      configuration.level
    end

    def progname
      configuration.progname
    end

    def formatter
      configuration.formatter
    end

    def datetime_format
      configuration.datetime_format
    end

    private

    def configuration
      @configuration ||= Configration.new
    end
  end
end
