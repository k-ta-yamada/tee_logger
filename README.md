[![Gem Version](https://badge.fury.io/rb/tee_logger.svg)](http://badge.fury.io/rb/tee_logger)
[![Build Status](https://travis-ci.org/k-ta-yamada/tee_logger.svg)](https://travis-ci.org/k-ta-yamada/tee_logger)
[![Code Climate](https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/gpa.svg)](https://codeclimate.com/github/k-ta-yamada/tee_logger)
[![Test Coverage](https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/coverage.svg)](https://codeclimate.com/github/k-ta-yamada/tee_logger/coverage)

> Sorry, I changed Usage from version 2.0.0

- [Rubygems.org](https://rubygems.org/gems/tee_logger)
- [GitHub](https://github.com/k-ta-yamada/tee_logger)
- [RubyDoc.info](http://www.rubydoc.info/gems/tee_logger)

# TeeLogger

logging to file and standard output.
require standard library only.


## Characteristic

- simple: use standard lib only.
- like Logger: see usage.
- enabled or disabled by switching the output of the console and the logfile.


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

# Logger.new like options(logdev, shift_age, shift_size)
# options default value is
#   logdev     = './tee_logger.log'
#   shift_age  = 0
#   shift_size = 1_048_576
tl = TeeLogger.new

# let's logging
tl.debug 'hello'
tl.debug(:progname) { 'hello world' }
tl.progname = 'App'
tl.debug 'hello tee_logger'

# disable only when specified
tl.info 'this message is logfile only', :console
tl.info 'this message is console only', :logfile

# disable console output
tl.disable(:console)
tl.info 'this message is logfile only'

# enable console output
tl.enable(:console)
tl.info 'this message is logfile and console'

# disable logfile output
tl.disable(:logfile)
tl.info 'this message is consle only'

# enable logfile output
tl.enable(:logfile)
tl.info 'this message is logfile and console'

# disabe in block
tl.disable(:console) do
  tl.info 'this message is logfile only'
end
tl.info 'this message is logfile and console'

# and others like Logger's
tl.debug? # => true
tl.info?
tl.warn?
tl.error?
tl.fatal?

tl.level # => 0
tl.level = Logger::INFO
tl.debug 'this message is not logging'

tl.formatter # => nil or Proc
tl.formatter = proc {|severity, datetime, progname, message| "#{severity}:#{message}" }
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/k-ta-yamada/tee_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
