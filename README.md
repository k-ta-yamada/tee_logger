[![Gem Version][gem_version-svg]][gem_version]
[![Build Status][travis-svg]][travis]
[![Code Climate][codeclimate-svg]][codeclimate]
[![Test Coverage][codeclimate_cov-svg]][codeclimate_cov]
[![Inline docs][inch-ci-svg]][inch-ci]

> Sorry. In from version 2 to version 3, changed usage.
> see also [CHANGELOG.md][tee_logger-changelog].

- [Rubygems.org](https://rubygems.org/gems/tee_logger)
- [GitHub](https://github.com/k-ta-yamada/tee_logger)
- [RubyDoc.info](http://www.rubydoc.info/gems/tee_logger)

# TeeLogger

logging to file and standard output.
require standard library only.


## Characteristic

- use standard lib only.
- like Logger: see usage.
- enabled or disabled by switching the output of the console and the logfile.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tee_logger'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install tee_logger
```


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

  # enable only when specified
  tl.info 'this message is console and logfile'
  tl.info 'this message is console only', :console
  tl.info 'this message is logfile only', :logfile

  # log meassage indent
  tl.info 'hello'    # => 'hello'
  tl.info 'hello', 0 # => 'hello'
  tl.info 'hello', 2 # => '  hello'

  # enabling and indent
  tl.info 'this message is console only', 2, :console
  tl.info 'this message is console only', :console, 2

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
  tl.info?  # => true
  tl.warn?  # => true
  tl.error? # => true
  tl.fatal? # => true

  tl.level # => 0
  tl.level = Logger::INFO
  tl.debug 'this message is not logging'

  tl.formatter # => nil or Proc
  tl.formatter =
    proc { |severity, datetime, progname, message| "#{severity}:#{message}" }

  tl.datetime_format # => nil or Proc
  tl.datetime_format = '%Y%m%d %H%M%S '
```


## include or extend TeeLogger for casual use

> TODO: the log file will be in default of `./tee_logger.log`

```ruby
  require 'tee_logger'

  class YourAwesomeClass
    include TeeLogger

    def awesome_method
      # do somthing
      logger.info 'this is message is logging and disp console'
    end
  end

  module YourAwesomeModule
    extend TeeLogger

    def self.awesome_method
      # do somthing
      logger.info 'this is message is logging and disp console'
    end
  end
```


## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `rake rspec` to run the tests.
You can also run `budle exec pry -r ./lib/tee_logger` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/k-ta-yamada/tee_logger.
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).


[gem_version]: http://badge.fury.io/rb/tee_logger
[gem_version-svg]: https://badge.fury.io/rb/tee_logger.svg

[travis]: https://travis-ci.org/k-ta-yamada/tee_logger
[travis-svg]: https://travis-ci.org/k-ta-yamada/tee_logger.svg

[codeclimate]: https://codeclimate.com/github/k-ta-yamada/tee_logger
[codeclimate-svg]: https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/gpa.svg

[codeclimate_cov]: https://codeclimate.com/github/k-ta-yamada/tee_logger/coverage
[codeclimate_cov-svg]: https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/coverage.svg

[inch-ci]: http://inch-ci.org/github/k-ta-yamada/tee_logger
[inch-ci-svg]: http://inch-ci.org/github/k-ta-yamada/tee_logger.svg?branch=master

[tee_logger-changelog]: https://github.com/k-ta-yamada/tee_logger/blob/master/CHANGELOG.md
