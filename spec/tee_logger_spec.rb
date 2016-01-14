require 'spec_helper'

describe TeeLogger do
  include_context 'shared_context'

  describe '.new' do
    subject { described_class.new }
    it { is_expected.to be_a(TeeLogger::TeeLoggerBase) }
  end

  describe 'extend_or_include' do
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

  describe 'configuration is reflected' do
    shared_examples 'configurations' do |type|
      it "with #{type}" do
        console_result = tail_console { klass.logger.debug message }
        logfile_result = tail_logfile

        # p console_result
        # p logfile_result

        expected_size = (type == :level) ? 0 : 1
        expect(console_result.size).to eq(expected_size)
        expect(logfile_result.size).to eq(expected_size)

        expect(console_result).to all(match(expected[type]))
        expect(logfile_result).to all(match(expected[type]))
      end
    end

    context 'with level' do
      before { TeeLogger.configure { |c| c.level = Logger::Severity::INFO } }
      it_behaves_like 'configurations', :level
    end

    context 'with progname' do
      before { TeeLogger.configure { |c| c.progname = progname } }
      it_behaves_like 'configurations', :progname
    end

    context 'with datetime_format' do
      before { TeeLogger.configure { |c| c.datetime_format = datetime_format } }
      it_behaves_like 'configurations', :datetime_format
    end

    context 'with formatter' do
      before { TeeLogger.configure { |c| c.formatter = formatter } }
      it_behaves_like 'configurations', :formatter
    end
  end
end
