shared_context 'shared_context' do
  let(:progname)  { 'MyApp' }
  let(:message)   { 'hello, world!' }
  let(:block)     { proc { 'this is blocked message' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }

  let(:klass) do
    Klass ||= Class.new do # rubocop:disable Style/ConstantName
      extend TeeLogger
      include TeeLogger
    end
  end

  before { TeeLogger.configure { |c| c.logdev = fake_file } }
  after  { TeeLogger.configuration_reset }
end
