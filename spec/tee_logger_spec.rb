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

    shared_examples 'with_disable' do |logdev_name, console_size, logfile_size|
      context "disabling logdev_name=[:#{logdev_name}]" do
        logging_methods.each do |name|
          it "##{name}" do
            console_result = tail_console do
              tl.send(name, progname, logdev_name, &block)
              tl.send(name, message, logdev_name)
            end
            logfile_result = tail_logfile

            expect(console_result.size).to eq(console_size)
            expect(logfile_result.size).to eq(logfile_size)

            expected1 = regexp(name, progname, block.call)
            expected2 = regexp(name, nil, message)
            expect(console_result).to all(match(expected1).or match(expected2))
            expect(logfile_result).to all(match(expected1).or match(expected2))
          end
        end
      end
    end
    it_behaves_like 'with_disable', :console, 0, 2
    it_behaves_like 'with_disable', :logfile, 2, 0
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

            expected = regexp(name, nil, message)
            expect(console_result).to all(match(expected).or be_nil)
            expect(logfile_result).to all(match(expected).or be_nil)
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

  describe 'datetime_format' do
    let(:datetime_format)         { '%Y%m%d %H%M%S ' }
    let(:datetime_format_reg_exp) { '\d{8}\s\d{6}' }

    it { expect(tl.datetime_format).to be_nil }

    context 'setting datetime_format' do
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

  describe 'parallel' do
    shared_examples 'in_xxx' do |method|
      it "#{method}" do
        console_result = tail_console do
          Parallel.each((0..9), method => 10) do |i|
            tl.info "#{Process.pid} #{Thread.current} #{i}"
          end
        end
        logfile_result = tail_logfile(20)

        expect(console_result.size).to eq(10)
        expect(logfile_result.size).to eq(10)
      end
    end
    it_behaves_like 'in_xxx', :in_threads
    pending 'No such file or directory - tee_logger_spec_fakefs.log' do
      it_behaves_like 'in_xxx', :in_processes
    end
  end
end
