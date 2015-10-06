# namespace
module TeeLogger
  # util
  module Utils
    class IncorrectNameError < StandardError; end

    # defined log devices names
    LOGDEVS = %i(console logfile)

    private

    def parse_to_hash_from(options)
      result = { enabling_target: nil, indent_level: 0 }
      options.each_with_object(result) do |val, obj|
        if val.is_a?(Symbol)
          correct_name?(val)
          obj[:enabling_target] = LOGDEVS.include?(val) ? val : nil
        elsif val.is_a?(Fixnum)
          obj[:indent_level] = val
        end
      end
    end

    def reverse_target(logdev_name)
      case logdev_name
      when :console then :logfile
      when :logfile then :console
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
      if val.is_a?(Symbol)
        ":#{val}"
      elsif val.nil?
        'nil'
      else
        val
      end
    end

    def correct_name?(logdev_name)
      if LOGDEVS.include?(logdev_name)
        true
      else
        fail IncorrectNameError,
             "logdev_name=[:#{logdev_name}]:logdev_name is :console or :logfile"
      end
    end

    def logdev_instance(logdev_name)
      instance_variable_get("@#{logdev_name}")
    end
  end
end
