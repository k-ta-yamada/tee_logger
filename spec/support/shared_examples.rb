# describe 'logging_methods'
shared_examples 'logging' do |message, progname, block|
  logging_methods.each do |name|
    it "##{name}" do
      console_result = tail_console do
        message ? tl.send(name, message) : tl.send(name, progname, &block)
      end
      logfile_result = tail_logfile

      expected = regexp(name, progname, message || block.call)
      expect(console_result).to all(match(expected))
      expect(logfile_result).to all(match(expected))
    end
  end
end

# describe 'logging_methods'
shared_examples 'with_enabling_target'do |logdev_name, c_size, l_size|
  context "logdev_name=[:#{logdev_name}]" do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.send(name, progname, logdev_name, &block)
          tl.send(name, message, logdev_name)
        end
        logfile_result = tail_logfile

        expect(console_result.size).to eq(c_size)
        expect(logfile_result.size).to eq(l_size)

        expected1 = regexp(name, progname, block.call)
        expected2 = regexp(name, nil, message)
        expect(console_result).to all(match(expected1).or(match(expected2)))
        expect(logfile_result).to all(match(expected1).or(match(expected2)))
      end
    end
  end
end

# describe 'logging_methods'
shared_examples 'with_indent' do |indent_level, c_size, l_size|
  context "indent_level=[:#{indent_level}]" do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.send(name, progname, indent_level, &block)
          tl.send(name, message, indent_level)
        end
        logfile_result = tail_logfile

        expect(console_result.size).to eq(c_size)
        expect(logfile_result.size).to eq(l_size)

        block_call = block.call
        expected1 =
          regexp(name, progname, "#{' ' * indent_level}#{block_call}")
        expected2 = regexp(name, nil, "#{' ' * indent_level}#{message}")
        expect(console_result).to all(match(expected1).or(match(expected2)))
        expect(logfile_result).to all(match(expected1).or(match(expected2)))
      end
    end
  end
end

# describe 'nil_or_symbol_message'
shared_examples 'nil_or_symbol_message' do |message, msg_for_reg|
  it "display string [#{msg_for_reg || 'nil'}]" do
    console_result = tail_console { tl.info message }
    logfile_result = tail_logfile

    expected = regexp(:info, nil, msg_for_reg)
    expect(console_result).to all(match(expected))
    expect(logfile_result).to all(match(expected))
  end
end

# describe 'raise_error'
shared_examples 'raises' do |err_class, invalid_opt|
  it { expect { tl.info('hello', invalid_opt) }.to raise_error(err_class) }
end

# describe 'disabling_and_enabling'
shared_examples 'mode_change' do |logdev_name, console_size, logfile_size|
  context "disabling_logdev_name=[:#{logdev_name}]" do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.send(name, message)

          tl.disable(logdev_name)
          tl.send(name, message)

          tl.enable(logdev_name)
          tl.send(name, message)
        end
        logfile_result = tail_logfile

        expect(console_result.size).to eq(console_size)
        expect(logfile_result.size).to eq(logfile_size)

        expected = regexp(name, nil, message)
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end
  end
end

# describe 'disabling_and_enabling'
shared_examples 'before_disable' do |logdev_name|
  context "disabling_logdev_name=[:#{logdev_name}]" do
    it 'same_format_before_disabling' do
      console_result = tail_console do
        tl.formatter = proc { |_, _, _, message| "#{message}\n" }
        tl.disable(logdev_name) { tl.debug(message) }
        tl.debug(message)
      end
      logfile_result = tail_logfile

      expect(console_result).to all(eq(message))
      expect(logfile_result).to all(eq(message))
    end
  end
end

# describe 'disabling_and_enabling'
shared_examples 'block_given' do |logdev_name, console_size, logfile_size|
  context "disabling_logdev_name=[:#{logdev_name}]" do
    logging_methods.each do |name|
      it "##{name}" do
        console_result = tail_console do
          tl.send(name, message)
          tl.disable(logdev_name) { tl.send(name, message) }
          tl.send(name, message)
        end
        logfile_result = tail_logfile

        expect(console_result.size).to eq(console_size)
        expect(logfile_result.size).to eq(logfile_size)

        expected = regexp(name, nil, message)
        expect(console_result).to all(match(expected))
        expect(logfile_result).to all(match(expected))
      end
    end
  end
end
