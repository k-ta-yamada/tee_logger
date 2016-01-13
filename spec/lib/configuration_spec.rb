require 'spec_helper'

describe TeeLogger::Configration do
  # NOTE: include shared_context then,
  #       defined name is a conflict between `let` and `described_class`
  # include_context 'shared_context'
  include described_class

  describe '.configure' do
    subject { proc { |c| configure(&c) } }
    it { is_expected.to yield_with_args(described_class::Configration) }
  end

  describe '.configuration_reset' do
    # NOTE: not `.configuration`, direct access instance var `@configuration`.
    #       cause `.configuration` return Struct.
    subject { instance_variable_get(:@configuration) }
    before { send :configuration_reset }
    it { is_expected.to be_nil }
  end

  describe '.logdev=' do
    subject { self.logdev = 1 }
    it { is_expected.to eq(1) }
  end

  describe '.logdev' do
    subject { logdev }
    before  { configure { |c| c.logdev = 'dummy_logdev_val' } }
    it { is_expected.to eq('dummy_logdev_val') }
  end

  describe 'configured_vals' do
    shared_examples 'configured_val' do |method_name|
      subject { send(method_name) }
      let(:configured_val) { 'this is configured_val' }

      context 'default' do
        it { is_expected.to be_nil }
      end

      context 'configured' do
        before { configure { |c| c.send("#{method_name}=", configured_val) } }
        it { is_expected.to eq(configured_val) }
      end
    end

    # NOTE: exclude `.logdev`, because used by shared_context's `before hook`.
    %i(level progname formatter datetime_format).each do |method_name|
      describe ".#{method_name}" do
        it_behaves_like 'configured_val', method_name
      end
    end
  end
end
