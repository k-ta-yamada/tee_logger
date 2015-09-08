require 'spec_helper'

describe TeeLogger do
  it 'has a version number' do
    expect(TeeLogger::VERSION).not_to be nil
  end

  describe '.new' do
    subject(:tl) { described_class.new() }
    logging_methods = described_class.const_get(:LOGGING_METHODS)

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
end
