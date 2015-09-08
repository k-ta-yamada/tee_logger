[![Gem Version](https://badge.fury.io/rb/tee_logger.svg)](http://badge.fury.io/rb/tee_logger)

Sorry, I changed Usage.

- [rubygems](https://rubygems.org/gems/tee_logger)
- [github](https://github.com/k-ta-yamada/tee_logger)

# TeeLogger

logging to logfile and standard output.

Characteristic
- simple: use standard lib only.
- like Logger: see usage.

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

# Logger.new like options
tl = TeeLogger.new('./tee_logger.log', 5, 1_024)

tl.debug(:progname) { 'hello world' }
tl.progname = 'App'
tl.debug('hello tee_logger')

# console only
tl.console.info('console only')

# logfile only
tl.logger.info('logger only')
```

# TODO feature
```
# disable and enable console output
tl.disable(:console)
tl.info 'this message is logfile only'
tl.enable(:console)
tl.info 'this message is logfile and console'

# disable and enable logfile output
tl.disable(:logger)
tl.info 'this message is consle only'
tl.enable(:logger)
tl.info 'this message is logfile and console'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/k-ta-yamada/tee_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

