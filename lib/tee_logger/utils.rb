# namespace
module TeeLogger
  # util
  module Utils
    module_function

    # @param options [Array]
    # @return [ParsedOption]
    def extract_options(options)
      options.each_with_object(ParsedOption.new(nil, 0)) do |val, obj|
        case val
        when Symbol then obj.logdev_name = name_reverse(val)
        when Fixnum then obj.indent_level = val
        else incorrect_option_error(val)
        end
      end
    end

    # @param progname
    # @param block
    # @param indent_level [Fixnum]
    # @return [Array]
    def indentation(progname, block, indent_level)
      if block.nil?
        progname = "#{' ' * indent_level}#{formatting(progname)}"
      else
        result = block.call
        block  = proc { "#{' ' * indent_level}#{formatting(result)}" }
      end
      [progname, block]
    end

    # @param val
    # @return [String]
    def formatting(val)
      case val
      when Symbol then ":#{val}"
      when nil    then 'nil'
      else val
      end
    end

    # @param val [Symbol]
    # @return [Symbol]
    def name_reverse(val)
      correct_name?(val)
      LOGDEV_REVERSE[val]
    end

    # @param name [Symbol]
    # @return [true]
    def correct_name?(name)
      LOGDEV_NAMES.include?(name) ? true : incorrect_name_error(name)
    end

    # @param name [Symbol]
    def incorrect_name_error(name)
      fail IncorrectNameError,
           "logdev_name is :console or :logfile. logdev_name=[:#{name}]"
    end

    # @param name [Symbol]
    def incorrect_option_error(val)
      fail IncorrectOptionError,
           "option params is Symbol or Fixnum. class=[#{val.class}]"
    end

    # @param logdev_name [Symbol]
    # @return [Logger]
    def logdev_instance(logdev_name)
      instance_variable_get("@#{logdev_name}")
    end
  end
end
