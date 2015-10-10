# namespace
module TeeLogger
  # util
  module Utils
    module_function

    def extract_options(options)
      options.each_with_object(ParsedOption.new(nil, 0)) do |val, obj|
        case val
        when Symbol then obj.logdev_name = name_reverse(val)
        when Fixnum then obj.indent_level = val
        else incorrect_option_error(val)
        end
      end
    end

    def indentation(progname, block, indent_level)
      if block.nil?
        progname = "#{' ' * indent_level}#{formatting(progname)}"
      else
        result = block.call
        block  = proc { "#{' ' * indent_level}#{formatting(result)}" }
      end
      [progname, block]
    end

    def formatting(val)
      case val
      when Symbol then ":#{val}"
      when nil    then 'nil'
      else val
      end
    end

    def name_reverse(val)
      correct_name?(val)
      LOGDEV_REVERSE[val]
    end

    def correct_name?(name)
      LOGDEV_NAMES.include?(name) ? true : incorrect_name_error(name)
    end

    def incorrect_name_error(name)
      fail IncorrectNameError,
           "logdev_name is :console or :logfile. logdev_name=[:#{name}]"
    end

    def incorrect_option_error(val)
      fail IncorrectOptionError,
           "option params is Symbol or Fixnum. class=[#{val.class}]"
    end

    def logdev_instance(logdev_name)
      instance_variable_get("@#{logdev_name}")
    end
  end
end
