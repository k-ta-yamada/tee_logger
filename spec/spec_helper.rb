require 'codeclimate-test-reporter'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  CodeClimate::TestReporter::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console]
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tee_logger'

require 'pry'
require 'capture_stdout'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  config.order = :random

  # @ref http://qiita.com/jnchito/items/3a590480ee291a70027c#3-%E5%A4%B1%E6%95%97%E3%81%97%E3%81%9F%E3%83%86%E3%82%B9%E3%83%88%E3%81%A0%E3%81%91%E3%82%92%E5%86%8D%E5%AE%9F%E8%A1%8C%E3%81%A7%E3%81%8D%E3%82%8B--only-failures-%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3
  config.example_status_persistence_file_path = './spec/reports/examples.txt'

  # @ref http://qiita.com/jnchito/items/3a590480ee291a70027c#%E5%BF%9C%E7%94%A8aggregate_failures-%E3%81%99%E3%81%B9%E3%81%A6%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E3%81%AB%E9%81%A9%E7%94%A8%E3%81%99%E3%82%8B
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end

# ######################################################################
# helper methdos
# ######################################################################

# wrap TeeLogger::LOGGING_METHODS
def logging_methods
  described_class.const_get(:LOGGING_METHODS)
end

# like log format
def regexp(severity = :debug, prog = nil, message = 'nil')
  label    = severity.to_s.upcase.chr
  datetime = '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}'
  pid      = '\d{1,5}'
  string   = "#{label},\s\\[#{datetime}\s##{pid}\\]" \
             "\s\s?#{severity.upcase}\s--\s#{prog}:\s#{message}"
  Regexp.new(string)
end

# TODO: Too miscellaneous
# simplicity tail
def tail(file, n = 10)
  result = []
  File.open(file) do |f|
    result = f.readlines.last(n)
  end
  result
end
