require 'spec_helper'

describe TeeLogger do
  subject(:tl)    { described_class.new(fake_file) }
  let(:progname)  { 'MyApp' }
  let(:message)   { 'hello, world!' }
  let(:block)     { proc { 'this is blocked message' } }
  let(:formatter) { proc { |s, _, _, m| "#{s}:#{m}\n" } }

  describe 'extend_and_include' do
    context 'extend Module' do
      it 'can call #logger method' do
        Mod = Module.new do
          extend TeeLogger
          def self.test
            logger(fake_file).info 'hello'
          end
        end
        console_result = tail_console { Mod.test }
        logfile_result = tail_logfile

        expected = regexp('info', Mod, 'hello')
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end

    context 'include Module' do
      it 'can call #logger method' do
        Klass = Class.new do
          include TeeLogger
          def test
            logger(fake_file).info 'hello'
          end
        end
        console_result = tail_console { Klass.new.test }
        logfile_result = tail_logfile

        expected = regexp('info', Klass.name, 'hello')
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end
  end
end
