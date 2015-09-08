require 'spec_helper'

describe TeeLogger do
  logging_methods = described_class.const_get(:LOGGING_METHODS)

  it 'has a version number' do
    expect(TeeLogger::VERSION).not_to be nil
  end

  # TODO: execution test case created after delete this case
  describe 'TeeLogger\'s instance methods Implement check' do
    subject(:tl) { described_class.new() }

    it 'has 3 instance variables' do
      expect(tl.instance_variables).to eq(%i(@base_logger @logger @console))
    end

    context 'respond_to? logging methods' do
      logging_methods.each do |logging_method|
        it "respond_to? ##{logging_method} => true" do
          expect(tl.respond_to?(logging_method)).to be_truthy
        end
      end
    end

    context 'respond_to? check logging level methods' do
      logging_methods.map { |v| "#{v}?" }.each do |logging_method|
        it "respond_to? ##{logging_method} => true" do
          expect(tl.respond_to?(logging_method)).to be_truthy
        end
      end
    end

    context 'respond_to? instance variables' do
      %i(logger console).each do |getter|
        it "respond_to? ##{getter} => true" do
          expect(tl.respond_to?(getter)).to be_truthy
        end
      end
      %i(base_logger).each do |getter|
        it "respond_to? ##{getter} => false" do
          expect(tl.respond_to?(getter)).to be_falsy
        end
      end
    end
  end

  describe 'logging methods' do
    subject(:tl) { described_class.new() }
    let(:block)  { proc { 'hello' } }

    logging_methods.each do |logging_method|
      context "##{logging_method}" do
        it 'only progname' do
          expect(tl.send(logging_method, logging_method)).to be_truthy
        end
        it 'only block' do
          expect(tl.send(logging_method, &block)).to be_truthy
        end
        it 'progname and block' do
          expect(tl.send(logging_method, logging_method, &block)).to be_truthy
        end
      end
    end
  end

  describe 'logging level methods' do
    subject(:tl) { described_class.new() }

    logging_methods.each do |logging_method|
      context "##{logging_method}?" do
        subject { tl.send(logging_method) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'progname' do
    subject(:tl) { described_class.new }
    let(:progname) { 'ProgName' }

    context "#progname, #progname=" do
      it '' do
        tl.progname = progname
        expect(tl.progname).to eq(progname)
        expect(tl.debug('hello')).to be_truthy
      end
    end
  end

  xdescribe 'disable' do
    subject(:tl) { described_class.new }
    it { }
  end

  xdescribe 'enable' do
    subject(:tl) { described_class.new }
    it { }
  end

  describe 'only console' do
    subject(:tl_console) { described_class.new().console }
    let(:block)  { proc { 'hello' } }

    describe 'logging methods' do
      logging_methods.each do |logging_method|
        context "##{logging_method}" do
          it 'only progname' do
            expect(tl_console.send(logging_method, logging_method)).to be_truthy
          end
          it 'only block' do
            expect(tl_console.send(logging_method, &block)).to be_truthy
          end
          it 'progname and block' do
            expect(tl_console.send(logging_method, logging_method, &block)).to be_truthy
          end
        end
      end
    end
  end

  describe 'only logger' do
    subject(:tl_logger) { described_class.new().logger }
    let(:block)  { proc { 'hello' } }

    describe 'logging methods' do
      logging_methods.each do |logging_method|
        context "##{logging_method}" do
          it 'only progname' do
            expect(tl_logger.send(logging_method, logging_method)).to be_truthy
          end
          it 'only block' do
            expect(tl_logger.send(logging_method, &block)).to be_truthy
          end
          it 'progname and block' do
            expect(tl_logger.send(logging_method, logging_method, &block)).to be_truthy
          end
        end
      end
    end
  end
end
