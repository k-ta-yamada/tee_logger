# TeeLogger

logging to logfile and standard output

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tee_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tee_logger

## Usage

```ruby
require 'tee_logger'
TeeLogger.setup

TeeLogger.debug 'hello' # => output console and logfile
TeeLogger.info 'hello' # => output console and logfile
TeeLogger.warn 'hello' # => output console and logfile
TeeLogger.error 'hello' # => output console and logfile
TeeLogger.fatal 'hello' # => output console and logfile

TeeLogger.console_debug 'hello' # => output console only
TeeLogger.console_info 'hello' # => output console only
TeeLogger.console_warn 'hello' # => output console only
TeeLogger.console_error 'hello' # => output console only
TeeLogger.console_fatal 'hello' # => output console only

TeeLogger.logger_debug 'hello' # => output logfile only
TeeLogger.logger_info 'hello' # => output logfile only
TeeLogger.logger_warn 'hello' # => output logfile only
TeeLogger.logger_error 'hello' # => output logfile only
TeeLogger.logger_fatal 'hello' # => output logfile only
```

and more
- debug? # => Boolean
- info? # => Boolean
- warn? # => Boolean
- error? # => Boolean
- fatal? # => Boolean
- console_debug? # => Boolean
- console_info? # => Boolean
- console_warn? # => Boolean
- console_error? # => Boolean
- console_fatal? # => Boolean
- logger_debug? # => Boolean
- logger_info? # => Boolean
- logger_warn? # => Boolean
- logger_error? # => Boolean
- logger_fatal? # => Boolean

## define logfile name

default logfile is `./tee_logger.log`.

you can change logfile.

```ruby
require 'tee_logger'
TeeLogger.setup do |tee_logger|
  tee_logger.logdev = './hello_world.log'
  tee_logger.shift_age = 5
  tee_logger.shift_size = 1_024
end

TeeLogger.info 'hello' # => output console and logfile('./hello_world.log')
TeeLogger.console_info 'hello' # => output console only
TeeLogger.logger_info 'hello' # => output logfile only('./hello_world.log')
```

setup item is Logger.new arguments.
- logdev
- shift_age
- shift_size


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tee_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

