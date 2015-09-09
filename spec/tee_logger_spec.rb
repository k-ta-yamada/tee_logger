require 'spec_helper'

describe TeeLogger do
  logging_methods = described_class.const_get(:LOGGING_METHODS)

  it 'has a version number' do
    expect(TeeLogger::VERSION).not_to be nil
  end

  describe 'logging methods' do
    subject(:tl)   { described_class.new }
    let(:progname) { 'Foo' }
    let(:message)  { 'bar' }
    let(:block)    { proc { 'baz' } }

    def regexp(severity, prog, mes)
      lab      = severity.upcase[0]
      datetime = '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}'
      pid      = '\d{1,5}'
      sev      = severity.upcase
      Regexp.new(
        "#{lab},\s\\[#{datetime}\s##{pid}\\]\s\s?#{sev}\s--\s#{prog}:\s#{mes}")
    end

    # before do
    #   tl.formatter = proc do |severity, _time, progname, message|
    #     "#{severity}:#{progname}:#{message}"
    #   end
    # end

    logging_methods.each do |method|
      context "##{method}" do
        it 'only progname' do
          expected = regexp(method, nil, message)
          result = capture_stdout { tl.send(method, message) }

          puts "expected=[#{expected}]"
          puts "result=[#{result.chomp}]"
          puts "match#{expected.match(result).to_a}"

          expect(result.chomp).to match(expected)
        end
        it 'only block' do
          expected = regexp(method, nil, block.call)
          result = capture_stdout { tl.send(method, &block) }

          puts "expected=[#{expected}]"
          puts "result=[#{result.chomp}]"
          puts "match#{expected.match(result).to_a}"

          # expect(tl.send(method, &block)).to be_truthy
          expect(result.chomp).to match(expected)
        end
        xit 'progname and block' do
          expect(tl.send(method, method, &block)).to be_truthy
        end
      end
    end
  end

  describe 'logging level methods' do
    subject(:tl) { described_class.new }

    logging_methods.each do |method|
      context "##{method}?" do
        subject { tl.send(method) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'progname' do
    subject(:tl) { described_class.new }
    let(:progname) { 'ProgName' }

    context '#progname, #progname=' do
      it '' do
        tl.progname = progname
        expect(tl.progname).to eq(progname)
        expect(tl.debug('hello')).to be_truthy
      end
    end
  end

  xdescribe 'disable' do
    subject(:tl) { described_class.new }
    it {}
  end

  xdescribe 'enable' do
    subject(:tl) { described_class.new }
    it {}
  end

  describe 'only console' do
    subject(:tl) { described_class.new }
    subject(:tl_console) { described_class.new.console }
    let(:progname) { 'App' }
    let(:block) { proc { 'hello' } }

    describe 'logging methods' do
      logging_methods.each do |method|
        context "##{method}" do
          it 'only progname' do
            # binding.pry
            expected = /-- : #{method}/
            result = capture_stdout { tl.send(method, method.to_s) }
            puts "result=[#{result.chomp}]"
            # expect(tl_console.send(method, method)).to be_truthy
            expect(result).to match(expected)
          end
          it 'only block' do
            expect(tl_console.send(method, &block)).to be_truthy
          end
          it 'progname and block' do
            expect(tl_console.send(method, method, &block)).to be_truthy
          end
        end
      end
    end
  end

  describe 'only logger' do
    subject(:tl_logger) { described_class.new.logger }
    let(:block) { proc { 'hello' } }

    describe 'logging methods' do
      logging_methods.each do |method|
        context "##{method}" do
          it 'only progname' do
            expect(tl_logger.send(method, method)).to be_truthy
          end
          it 'only block' do
            expect(tl_logger.send(method, &block)).to be_truthy
          end
          it 'progname and block' do
            expect(tl_logger.send(method, method, &block)).to be_truthy
          end
        end
      end
    end
  end
end
