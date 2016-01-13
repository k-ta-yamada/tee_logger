# namespace
module TeeLogger
  # no param of filename, set this filename
  DEFAULT_FILE = './tee_logger.log'

  # configured attributes
  CONFIGURED_ATTRIBUTES = [:level, :progname, :formatter, :datetime_format]

  # implements targets
  LOGGING_METHODS = [:debug, :info, :warn, :error, :fatal]

  # defined logdev names
  LOGDEV_NAMES = [:console, :logfile]

  # defined paired of logdev name
  LOGDEV_REVERSE = { console: :logfile, logfile: :console }

  # empty format
  FORMATTER_FOR_DISABLING = proc { |_severity, _time, _progname, _msg| '' }

  # using TeeLogger::Utils.extract_options
  # @attr logdev_name [Symbol]
  # @attr indent_level [Fixnum]
  ParsedOption = Struct.new(:logdev_name, :indent_level)

  # LOGDEV_NAMES not included error
  class IncorrectNameError < StandardError; end

  # option's class is not allow
  class IncorrectOptionError < StandardError; end
end
