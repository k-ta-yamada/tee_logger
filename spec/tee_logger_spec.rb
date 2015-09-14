require 'spec_helper'

describe TeeLogger do
  subject(:tl)    { described_class.new(File.open(LOGFILE_NAME, 'w')) }
  let(:progname)  { 'MyApp' }
  let(:message)   { 'hello, world!' }
  let(:block)     { proc { 'this is blocked message' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }

  describe 'logging methods' do
    shared_examples 'logging' do |message, progname, block|
      logging_methods.each do |name|
        it "##{name}" do
          console_result = tail_console do
            message ? tl.send(name, message) : tl.send(name, progname, &block)
          end
          logfile_result = tail_logfile

          expected = regexp(name, progname, message)
          expect(console_result).to all(match(expected))
          expect(logfile_result).to all(match(expected))
        end
      end
    end

    context 'only message' do
      it_behaves_like 'logging', 'hello, world!', nil, nil
    end
    context 'only block' do
      it_behaves_like 'logging', nil, nil, proc { 'this is blocked message' }
    end
    context 'progname and block' do
      it_behaves_like 'logging', nil, 'App', proc { 'this is blocked message' }
    end
  end

  describe 'logging level methods' do
    logging_methods.map { |v| "#{v}?" }.each do |name|
      context "##{name}" do
        subject { tl.send(name) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'setting level' do
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

            expected = size > 0 ? match(regexp(name, nil, message)) : be_nil
            expect(console_result).to all(expected)
            expect(logfile_result).to all(expected)
          end
        end
      end
    end
  end

  describe 'setting progname' do
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

  describe 'disabling and enabling' do
    context 'basic usage' do
      shared_examples 'mode_change' do |logdev_name, console_size, logfile_size|
        context "disabling logdev_name=[:#{logdev_name}]" do
          logging_methods.each do |name|
            it "##{name}" do
              console_result = tail_console do
                tl.send(name, message)

                tl.disable(logdev_name)
                tl.send(name, message)

                tl.enable(logdev_name)
                tl.send(name, message)
              end
              logfile_result = tail_logfile

              expect(console_result.size).to eq(console_size)
              expect(logfile_result.size).to eq(logfile_size)

              expected = regexp(name, nil, message)
              expect(console_result).to all(match(expected))
              expect(logfile_result).to all(match(expected))
            end
          end
        end
      end
      it_behaves_like 'mode_change', :console, 2, 3
      it_behaves_like 'mode_change', :logfile, 3, 2
    end

    context 'format change before disable' do
      shared_examples 'before_disable' do |logdev_name|
        context "disabling logdev_name=[:#{logdev_name}]" do
          it 'same format before disabling' do
            console_result = tail_console do
              tl.formatter = proc { |_, _, _, message| "#{message}\n" }
              tl.disable(logdev_name) { tl.debug(message) }
              tl.debug(message)
            end
            logfile_result = tail_logfile

            expect(console_result).to all(eq(message))
            expect(logfile_result).to all(eq(message))
          end
        end
      end
      it_behaves_like 'before_disable', :console
      it_behaves_like 'before_disable', :logfile
    end

    context 'disabling block_given?' do
      shared_examples 'block_given' do |logdev_name, console_size, logfile_size|
        context "disabling logdev_name = [:#{logdev_name}]" do
          logging_methods.each do |name|
            it "##{name}" do
              console_result = tail_console do
                tl.send(name, message)
                tl.disable(logdev_name) { tl.send(name, message) }
                tl.send(name, message)
              end
              logfile_result = tail_logfile

              expect(console_result.size).to eq(console_size)
              expect(logfile_result.size).to eq(logfile_size)

              expected = regexp(name, nil, message)
              expect(console_result).to all(match(expected))
              expect(logfile_result).to all(match(expected))
            end
          end
        end
      end
      it_behaves_like 'block_given', :console, 2, 3
      it_behaves_like 'block_given', :logfile, 3, 2
    end
  end
end
