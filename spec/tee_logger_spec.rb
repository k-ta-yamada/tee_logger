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

  describe 'setting is reflected' do
    before do
      # TeeLogger.configuration_reset
      TeeLogger.configure do |config|
        config.logdev   = default_file
        config.level    = Logger::Severity::INFO
        config.progname = progname
      end
    end

    context 'with datetime_format' do
      before do
        TeeLogger.configure { |c| c.datetime_format = datetime_format }
      end

      xit '' do
        console_result = tail_console do
          klass.logger.debug message
          klass.logger.info message
        end
        logfile_result = tail_logfile(10, default_file)

        expect(console_result.size).to eq(1)
        expect(logfile_result.size).to eq(1)

        expected = regexp(:info, progname, message, datetime_format_reg_exp)
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end

    context 'with formatter' do
      before do
        TeeLogger.configure { |c| c.formatter = formatter }
      end

      xit '' do
        console_result = tail_console do
          klass.logger.debug message
          klass.logger.info message
        end
        logfile_result = tail_logfile(10, default_file.path)

        expect(console_result.size).to eq(1)
        expect(logfile_result.size).to eq(1)

        expected = Regexp.new("#{:info.upcase}:#{message}")
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end
  end
end
