require 'logger'

# namespace
module TeeLogger
  DEFAULT_FILE = './tee_logger.log'
  LOGGING_METHODS = %i(debug info warn error fatal).freeze
end
