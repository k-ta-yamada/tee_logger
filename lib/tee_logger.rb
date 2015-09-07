require 'tee_logger/version'
require 'tee_logger/base'

# main
module TeeLogger
  @logdev     = DEFAULT_FILE
  @shift_age  = 0
  @shift_size = 1_048_576

  # @ref https://github.com/railsconfig/config/blob/master/lib/config.rb#L18
  @_run_once = false
  def self.setup
    return base_logger if @_run_once
    define_singleton_methods_for_setup

    yield(self) if block_given?
    @_run_once = true

    define_singleton_methods_for_logging
    define_singleton_methods_for_logging_with_prefix
    base_logger
  end

  class << self
    private

    def define_singleton_methods_for_setup
      %i(logdev shift_age shift_size).each do |name|
        define_singleton_method(name) do
          instance_variable_get("@#{name}".to_sym)
        end
        # private_class_method name

        define_singleton_method("#{name}=") do |arg|
          instance_variable_set("@#{name}".to_sym, arg)
        end
        # private_class_method "#{name}=".to_sym
      end
    end

    def base_logger
      @base_logger ||= Base.new(logdev, shift_age, shift_size)
    end

    def define_singleton_methods_for_logging
      LOGGING_METHODS.each do |name|
        define_singleton_method(name) do |progname = nil, &block|
          base_logger.send(name, progname, &block)
        end

        define_singleton_method("#{name}?") do
          base_logger.send("#{name}?")
        end
      end
    end

    def define_singleton_methods_for_logging_with_prefix
      %i(logger console).each do |pre|
        LOGGING_METHODS.each do |name|
          define_singleton_method("#{pre}_#{name}") do |progname = nil, &block|
            base_logger.send(pre).send(name, progname, &block)
          end

          define_singleton_method("#{pre}_#{name}?") do
            base_logger.send(pre).send("#{name}?")
          end
        end
      end
    end
  end
end
