require 'spec_helper'

describe TeeLogger do
  subject(:tl) do
    filename = "#{File.basename(__FILE__, '.rb')}.log"
    described_class.new(File.open(filename, 'w'))
  end
  let(:filename) { "#{File.basename(__FILE__, '.rb')}.log" }
  let(:progname) { 'Foo' }
  let(:message)  { 'bar' }
  let(:block)    { proc { 'baz' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }

  describe 'logging methods' do
    logging_methods.each do |method|
      context "##{method}" do
        it 'only progname' do
          expected = regexp(method, nil, message)
          console_result = capture_stdout { tl.send(method, message) }
          logfile_result = tail(filename).last
          expect(console_result).to match(expected)
          expect(logfile_result).to match(expected)
        end

        it 'only block' do
          expected = regexp(method, nil, block.call)
          console_result = capture_stdout { tl.send(method, &block) }
          logfile_result = tail(filename).last
          expect(console_result).to match(expected)
          expect(logfile_result).to match(expected)
        end

        it 'progname and block' do
          expected = regexp(method, progname, block.call)
          console_result = capture_stdout { tl.send(method, progname, &block) }
          logfile_result = tail(filename).last
          expect(console_result).to match(expected)
          expect(logfile_result).to match(expected)
        end
      end
    end
  end

  describe 'logging level methods' do
    logging_methods.map { |v| "#{v}?" }.each do |method|
      context "##{method}" do
        subject { tl.send(method) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'setting level' do
    Logger::Severity.constants.each do |const|
      context "Severity:#{const}"do
        logging_methods.each do |method|
          it "##{method}" do
            console_result = capture_stdout do
              tl.level = Logger.const_get(const)
              tl.send(method, message)
            end.split("\n")
            logfile_result = tail(filename)

            expected = Logger.const_get(method.upcase) >= tl.level ? 1 : 0
            expect(console_result.size).to eq(expected)
            expect(logfile_result.size).to eq(expected)
          end
        end
      end
    end
  end

  describe 'setting progname' do
    logging_methods.each do |method|
      it "##{method}" do
        expected = regexp(method, progname, message)

        console_result = capture_stdout do
          tl.progname = progname
          tl.send(method, message)
        end
        logfile_result = tail(filename).last

        expect(tl.progname).to match(progname)
        expect(console_result).to match(expected)
        expect(logfile_result).to match(expected)
      end
    end
  end

  describe 'formatter' do
    logging_methods.each do |method|
      it "##{method}" do
        expected = Regexp.new("#{method.upcase}:#{message}")

        console_result = capture_stdout do
          tl.formatter = formatter
          tl.send(method, message)
        end
        logfile_result = tail(filename).last

        expect(tl.formatter).to eq(formatter)
        expect(console_result).to match(expected)
        expect(logfile_result).to match(expected)
      end
    end
  end

  describe 'disabling and enabling' do
    context 'format change before disable' do
      it 'same format before disabling' do
        console_result = capture_stdout do
          tl.formatter = proc { |_, _, _, message| "#{message}\n" }
          tl.disable(:console) { tl.debug(message) }
          tl.debug(message)
        end.split("\n").last
        expect(console_result).to eq(message)
      end

      it 'same format before disabling' do
        capture_stdout do
          tl.formatter = proc { |_, _, _, message| "#{message}\n" }
          tl.disable(:logfile) { tl.debug(message) }
          tl.debug(message)
        end
        logfile_result = tail(filename).last
        expect(logfile_result).to eq(message)
      end
    end

    context 'disabling block_given?' do
      context 'disable console' do
        logging_methods.each do |method|
          it "##{method}" do
            console_result = capture_stdout do
              tl.send(method, message)
              tl.disable(:console) { tl.send(method, message) }
              tl.send(method, message)
            end.split("\n")
            logfile_result = tail(filename)

            expect(console_result.size).to eq(2)
            expect(logfile_result.size).to eq(3)
          end
        end
      end

      context 'disable logfile' do
        logging_methods.each do |method|
          it "##{method}" do
            console_result = capture_stdout do
              tl.send(method, message)
              tl.disable(:logfile) { tl.send(method, message) }
              tl.send(method, message)
            end.split("\n")
            logfile_result = tail(filename)

            expect(console_result.size).to eq(3)
            expect(logfile_result.size).to eq(2)
          end
        end
      end
    end

    context 'mode chenge target :console' do
      logging_methods.each do |method|
        it "##{method}" do
          console_result = capture_stdout do
            tl.send(method, message)
            tl.disable :console
            tl.send(method, message)
            tl.enable :console
            tl.send(method, message)
          end.split("\n")
          logfile_result = tail(filename)

          expect(console_result.size).to eq(2)
          expect(logfile_result.size).to eq(3)
        end
      end
    end

    context 'mode chang target :logfile' do
      logging_methods.each do |method|
        it "##{method}" do
          console_result = capture_stdout do
            tl.send(method, message)
            tl.disable :logfile
            tl.send(method, message)
            tl.enable :logfile
            tl.send(method, message)
          end.split("\n")
          logfile_result = tail(filename)

          expect(console_result.size).to eq(3)
          expect(logfile_result.size).to eq(2)
        end
      end
    end
  end
end
