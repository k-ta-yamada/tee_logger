require 'spec_helper'

describe TeeLogger do
  include_context 'shared_context'

  describe '.new' do
    it '' do
      expect(described_class.new(fake_file)).to be_a(TeeLogger::TeeLoggerBase)
    end
  end

  shared_examples 'extend_or_include' do |type, msg, sev|
    it "can call .#logger method : #{msg}" do
      target = { extended: klass,
                 included: klass.new }[type]

      console_result = tail_console { target.logger.send(sev, msg) }
      logfile_result = tail_logfile

      expected = regexp(sev, klass, msg)
      expect(console_result).to all(match(expected))
      expect(logfile_result).to all(match(expected))
    end
  end

  it_behaves_like 'extend_or_include', :extended, 'case extended', :info
  it_behaves_like 'extend_or_include', :included, 'case included', :debug
end
