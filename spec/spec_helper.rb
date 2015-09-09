$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tee_logger'
require 'pry'
require 'capture_stdout'
require 'fakefs/spec_helpers'

RSpec.configure do |conf|
  conf.include FakeFS::SpecHelpers
end

def logging_methods
  described_class.const_get(:LOGGING_METHODS)
end

def regexp(severity, prog, message)
  label    = severity.to_s.upcase.chr
  datetime = '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}'
  pid      = '\d{1,5}'
  string   = "#{label},\s\\[#{datetime}\s##{pid}\\]" \
             "\s\s?#{severity.upcase}\s--\s#{prog}:\s#{message}"
  Regexp.new(string)
end

# TODO: Too miscellaneous
def tail(file, n = 1)
  result = []
  File.open(file) do |f|
    result = f.readlines.last(n)
  end
  result
end
