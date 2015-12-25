require 'codeclimate-test-reporter'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  CodeClimate::TestReporter::Formatter,
  SimpleCov::Formatter::Console,
  SimpleCov::Formatter::HTMLFormatter,]
SimpleCov.start

require 'pry'
require 'capture_stdout'
require 'fakefs/spec_helpers'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tee_logger'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  config.order = :random

  # @ref http://qiita.com/jnchito/items/3a590480ee291a70027c
  #      3. 失敗したテストだけを再実行できる（--only-failures オプション）
  config.example_status_persistence_file_path = './spec/reports/examples.txt'

  # @ref http://qiita.com/jnchito/items/3a590480ee291a70027c
  #      応用：aggregate_failures すべてのテストに適用する
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end

# ######################################################################
# helper methods and constants
# ######################################################################

# wrap TeeLogger::LOGGING_METHODS
def logging_methods
  TeeLogger::LOGGING_METHODS
end

# like log format
def regexp(severity = :debug, progname = nil, message = 'nil', datetime = nil)
  label    = severity.to_s.upcase.chr
  datetime ||= '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}'
  pid      = '\d{1,5}'
  string   = "#{label},\s\\[#{datetime}\s\##{pid}\\]" \
             "\s\s?#{severity.upcase}\s--\s#{progname}:\s#{message}"
  Regexp.new(string)
end

# filename for fakefs
FAKE_FILE_NAME = 'tee_logger_spec_fakefs.log'

# return fakefs file
def fake_file
  @fake_file ||= File.open(FAKE_FILE_NAME, 'w')
end

# simplicity tail for logfile
# @result (Array) chomped element
def tail_logfile(n = 10, file = FAKE_FILE_NAME)
  result = File.read(file)
  result.split("\n").last(n).map(&:chomp)
end

# simplicity tail for console by capture_stdout
# @result (Array) chomped element
def tail_console(n = 10)
  result = capture_stdout { yield }
  result.split("\n").last(n).map(&:chomp)
end
