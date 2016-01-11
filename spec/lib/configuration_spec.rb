require 'spec_helper'

describe TeeLogger::Configration do
  include_context 'shared_context'
  include described_class

  describe '.configure' do
    subject { proc { |b| configure(&b) } }
    it { is_expected.to yield_with_args(described_class::Configration) }
  end

  describe '.configuration_reset' do
    subject { instance_variable_get(:@configuration) }
    before { send :configuration_reset }
    it { is_expected.to be_nil }
  end
end
