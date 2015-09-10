require 'logger'

# namespace
module TeeLogger
  # no param of filename, set this filename
  DEFAULT_FILE = './tee_logger.log'

  # Implements targets
  LOGGING_METHODS = [:debug, :info, :warn, :error, :fatal].freeze
end
