# namespace
module TeeLogger
  # no param of filename, set this filename
  DEFAULT_FILE = './tee_logger.log'
  # Implements targets
  LOGGING_METHODS = [:debug, :info, :warn, :error, :fatal]
  # defined logdev names
  LOGDEV_NAMES = [:console, :logfile]
  # defined paired of logdev name
  LOGDEV_REVERSE = { console: :logfile, logfile: :console }

  FORMATTER_FOR_DISABLING = proc { |_severity, _time, _progname, _msg| '' }

  # using private method #parse_to_hash
  ParsedOption = Struct.new(:logdev_name, :indent_level)
  # LOGDEV_NAMES not included error
  class IncorrectNameError < StandardError; end
  # option's class is not allow
  class IncorrectOptionError < StandardError; end
end
