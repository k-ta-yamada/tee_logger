require 'spec_helper'

describe TeeLogger do
  it 'has a version number' do
    expect(described_class.const_get(:VERSION)).not_to be nil
  end

  subject(:tl) do
    filename = "#{File.basename(__FILE__, '.rb')}.log"
    described_class.new(File.open(filename, 'w'))
  end

  let(:filename) { "#{File.basename(__FILE__, '.rb')}.log" }
  let(:progname) { 'Foo' }
  let(:message)  { 'bar' }
  let(:block)    { proc { 'baz' } }

  describe 'logging level methods' do
    logging_methods.map { |v| "#{v}?" }.each do |method|
      context "#{method}" do
        subject { tl.send(method) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'logging methods' do
    logging_methods.each do |method|
      context "##{method}" do
        it 'only progname' do
          expected = regexp(method, nil, message)
          result   = capture_stdout { tl.send(method, message) }
          expect(result.chomp).to match(expected)
        end
        it 'only block' do
          expected = regexp(method, nil, block.call)
          result   = capture_stdout { tl.send(method, &block) }
          expect(result.chomp).to match(expected)
        end
        it 'progname and block' do
          expected = regexp(method, progname, block.call)
          result   = capture_stdout { tl.send(method, progname, &block) }
          expect(result.chomp).to match(expected)
        end
      end
    end
  end

  xdescribe 'disable' do
    it {}
  end

  xdescribe 'enable' do
    it {}
  end

  describe 'only console' do
    describe 'logging methods' do
      logging_methods.each do |method|
        context "##{method}" do
          it 'only progname' do
            expected = regexp(method, nil, message)
            result   = capture_stdout { tl.console.send(method, message) }
            expect(result.chomp).to match(expected)
          end
          it 'only block' do
            expected = regexp(method, nil, block.call)
            result   = capture_stdout { tl.console.send(method, &block) }
            expect(result.chomp).to match(expected)
          end
          it 'progname and block' do
            expected = regexp(method, progname, block.call)
            result   =
              capture_stdout { tl.console.send(method, progname, &block) }
            expect(result.chomp).to match(expected)
          end
        end
      end
    end
  end

  describe 'only logger' do
    describe 'logging methods' do
      logging_methods.each do |method|
        context "##{method}" do
          it 'only progname' do
            tl.logger.send(method, message)
            expected = regexp(method, nil, message)
            result   = tail(filename, 1).last
            expect(result.chomp).to match(expected)
          end
          it 'only block' do
            tl.logger.send(method, &block)
            expected = regexp(method, nil, block.call)
            result   = tail(filename, 1).last
            expect(result.chomp).to match(expected)
          end
          it 'progname and block' do
            tl.logger.send(method, progname, &block)
            expected = regexp(method, progname, block.call)
            result   = tail(filename, 1).last
            expect(result.chomp).to match(expected)
          end
        end
      end
    end
  end
end
