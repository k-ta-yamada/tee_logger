require 'spec_helper'
require 'shared_examples_for_tee_logger'

describe TeeLogger do
  subject(:tl)    { described_class.new(fake_file) }
  let(:progname)  { 'MyApp' }
  let(:message)   { 'hello, world!' }
  let(:block)     { proc { 'this is blocked message' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }

  describe 'logging_methods' do
    context 'only_message' do
      it_behaves_like 'logging', 'hello, world!', nil, nil
    end
    context 'only_block' do
      it_behaves_like 'logging', nil, nil, proc { 'this is blocked message' }
    end
    context 'progname_and_block' do
      it_behaves_like 'logging', nil, 'App', proc { 'this is blocked message' }
    end
    it_behaves_like 'with_enabling_target', :console, 2, 0
    it_behaves_like 'with_enabling_target', :logfile, 0, 2
    it_behaves_like 'with_indent', 2, 2, 2
    it_behaves_like 'with_indent', 2, 2, 2
  end

  describe 'nil_or_symbol_message' do
    it_behaves_like 'nil_or_symbol_message', nil, nil
    it_behaves_like 'nil_or_symbol_message', :hello, ':hello'
  end

  describe 'raise_error' do
    it_behaves_like 'raises', TeeLogger::IncorrectNameError, :incorrect_name
    it_behaves_like 'raises', TeeLogger::IncorrectOptionError, nil
  end

  describe 'logging_level_methods' do
    logging_methods.map { |v| "#{v}?" }.each do |name|
      context "##{name}" do
        subject { tl.send(name) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'setting_level' do
    Logger::Severity.constants.each do |const|
      context "Severity:#{const}"do
        logging_methods.each do |name|
          it "##{name}" do
            console_result = tail_console do
              tl.level = Logger.const_get(const)
              tl.send(name, message)
            end
            logfile_result = tail_logfile

            size = Logger.const_get(name.upcase) >= tl.level ? 1 : 0
            expect(console_result.size).to eq(size)
            expect(logfile_result.size).to eq(size)

            expected = regexp(name, nil, message)
            expect(console_result).to all(match(expected).or be_nil)
            expect(logfile_result).to all(match(expected).or be_nil)
          end
        end
      end
    end
  end

  describe 'setting_progname' do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.progname = progname
          tl.send(name, message)
        end
        logfile_result = tail_logfile

        expected = regexp(name, progname, message)
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
        expect(tl.progname).to eq(progname)
      end
    end
  end

  describe 'formatter' do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.formatter = formatter
          tl.send(name, message)
        end
        logfile_result = tail_logfile

        expected = Regexp.new("#{name.upcase}:#{message}")
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
        expect(tl.formatter).to eq(formatter)
      end
    end
  end

  describe 'datetime_format' do
    let(:datetime_format)         { '%Y%m%d %H%M%S ' }
    let(:datetime_format_reg_exp) { '\d{8}\s\d{6}' }

    it { expect(tl.datetime_format).to be_nil }
    context 'setting_datetime_format' do
      logging_methods.each do |name|
        it "##{name}" do
          console_result = tail_console do
            tl.datetime_format = datetime_format
            tl.send(name, message)
          end
          logfile_result = tail_logfile

          expected = regexp(name, nil, message, datetime_format_reg_exp)
          expect(console_result).to all(match(expected))
          expect(logfile_result).to all(match(expected))
          expect(tl.datetime_format).to eq(datetime_format)
        end
      end
    end
  end

  describe 'disabling_and_enabling' do
    context 'basic_usage' do
      it_behaves_like 'mode_change', :console, 2, 3
      it_behaves_like 'mode_change', :logfile, 3, 2
    end

    context 'format_change_before_disable' do
      it_behaves_like 'before_disable', :console
      it_behaves_like 'before_disable', :logfile
    end

    context 'disabling_block_given?' do
      it_behaves_like 'block_given', :console, 2, 3
      it_behaves_like 'block_given', :logfile, 3, 2
    end
  end
end
