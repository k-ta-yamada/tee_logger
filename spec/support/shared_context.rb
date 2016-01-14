shared_context 'shared_context' do
  let(:progname)  { 'MyApp' }
  let(:message)   { 'hello, world!' }
  let(:block)     { proc { 'this is blocked message' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }
  let(:datetime_format)         { '%Y%m%d %H%M%S ' }
  let(:datetime_format_reg_exp) { '\d{8}\s\d{6}' }

  let(:klass) do
    # テストのとき、定数を再代入した時のwarningを止めたい - 福島餃子Ruby親方
    # @ref http://xibbar.hatenablog.com/entry/20091126/1259216726
    # How to redefine a Ruby constant without warning? - Stack Overflow
    # @ref http://stackoverflow.com/questions/3375360/how-to-redefine-a-ruby-constant-without-warning
    Object.send(:remove_const, 'Klass') if defined?(Klass)
    Klass = Class.new do
      extend TeeLogger
      include TeeLogger
    end
  end

  before { TeeLogger.configure { |c| c.logdev = fake_file } }
  after  { TeeLogger.configuration_reset }

  # for tee_logger_spec.rb
  # TeeLogger configuration is reflected
  let(:expected) do
    { level:           regexp(:debug, klass, message),
      progname:        regexp(:debug, progname, message),
      datetime_format: regexp(:debug, klass, message, datetime_format_reg_exp),
      formatter:       Regexp.new("#{:debug.upcase}:#{message}") }
  end
end
