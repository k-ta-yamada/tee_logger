# TeeLogger

[![Gem Version][gem_version-svg]][gem_version]
[![Build Status][travis-svg]][travis]
[![Downloads][downloads-svg]][gem_version]
[![Inline docs][inch-ci-svg]][inch-ci]
[![Code Climate][codeclimate-svg]][codeclimate]
[![Test Coverage][codeclimate_cov-svg]][codeclimate_cov]

> Sorry. In from version 2 to version 3, changed usage.
> see also [CHANGELOG.md][tee_logger-changelog].

- [Rubygems.org](https://rubygems.org/gems/tee_logger)
- [GitHub](https://github.com/k-ta-yamada/tee_logger)
- [RubyDoc.info](https://www.rubydoc.info/gems/tee_logger)

logging to file and standard output.
require standard library only.

<!-- TOC -->

- [1. Characteristic](#1-characteristic)
- [2. Installation](#2-installation)
- [3. Usage](#3-usage)
  - [3.1. let's logging](#31-lets-logging)
  - [3.2. enable only when specified](#32-enable-only-when-specified)
  - [3.3. log meassage indent](#33-log-meassage-indent)
  - [3.4. enabling and indent](#34-enabling-and-indent)
  - [3.5. disable console output](#35-disable-console-output)
  - [3.6. enable console output](#36-enable-console-output)
  - [3.7. disable logfile output](#37-disable-logfile-output)
  - [3.8. enable logfile output](#38-enable-logfile-output)
  - [3.9. disable in block](#39-disable-in-block)
  - [3.10. and others like Logger's](#310-and-others-like-loggers)
- [4. include or extend TeeLogger](#4-include-or-extend-teelogger)
  - [4.1. for casual use](#41-for-casual-use)
  - [4.2. configuration logfile name, progname, level, formatter, and datetime_format](#42-configuration-logfile-name-progname-level-formatter-and-datetime_format)
- [5. Development](#5-development)
- [6. Contributing](#6-contributing)
- [7. License](#7-license)

<!-- /TOC -->

---

## 1. Characteristic

- use standard lib only.
- like Logger: see usage.
- enabled or disabled by switching the output of the console and the logfile.

---

## 2. Installation

Add this line to your application's Gemfile:

```ruby
gem 'tee_logger'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install tee_logger
```

---

## 3. Usage

### 3.1. let's logging

```ruby
require 'tee_logger'

# Logger.new like options(logdev, shift_age, shift_size)
# options default value is
#   logdev     = './tee_logger.log'
#   shift_age  = 0
#   shift_size = 1_048_576
tl = TeeLogger.new

tl.debug 'hello'
tl.debug(:progname) { 'hello world' }
tl.progname = 'App'
tl.debug 'hello tee_logger'
```

### 3.2. enable only when specified

```ruby
tl.info 'this message is console and logfile'
tl.info 'this message is console only', :console
tl.info 'this message is logfile only', :logfile
```

### 3.3. log meassage indent

```ruby
tl.info 'hello'    # => 'hello'
tl.info 'hello', 0 # => 'hello'
tl.info 'hello', 2 # => '  hello'
```

### 3.4. enabling and indent

```ruby
tl.info 'this message is console only', 2, :console
tl.info 'this message is console only', :console, 2
```

### 3.5. disable console output

```ruby
tl.disable(:console)
tl.info 'this message is logfile only'
```

### 3.6. enable console output

```ruby
tl.enable(:console)
tl.info 'this message is logfile and console'
```

### 3.7. disable logfile output

```ruby
tl.disable(:logfile)
tl.info 'this message is consle only'
```

### 3.8. enable logfile output

```ruby
tl.enable(:logfile)
tl.info 'this message is logfile and console'
```

### 3.9. disable in block

```ruby
tl.disable(:console) do
  tl.info 'this message is logfile only'
end
tl.info 'this message is logfile and console'
```

### 3.10. and others like Logger's

```ruby
# log_level
tl.debug? # => true
tl.info?  # => true
tl.warn?  # => true
tl.error? # => true
tl.fatal? # => true

tl.level # => 0
tl.level = Logger::INFO
tl.debug 'this message is not logging'

# formatter
tl.formatter # => nil or Proc
tl.formatter =
  proc { |severity, datetime, progname, message| "#{severity}:#{message}" }

# datetime_formatter
tl.datetime_format # => nil or Proc
tl.datetime_format = '%Y%m%d %H%M%S '
```

---

## 4. include or extend TeeLogger

> the log file will be in default of `./tee_logger.log`

### 4.1. for casual use

```ruby
require 'tee_logger'

class YourAwesomeClass
  # define method #logger for your class.
  # log file will be in default of `./tee_logger.log`
  include TeeLogger

  def awesome_method
    logger.info 'this is message is logging and disp console'
  end
end

module YourAwesomeModule
  # define singleton method .logger for your module.
  # log file will be in default of `./tee_logger.log`
  extend TeeLogger

  def self.awesome_method
    logger.info 'this is message is logging and disp console'
  end
end
```

### 4.2. configuration logfile name, progname, level, formatter, and datetime_format

```ruby
require 'tee_logger'

# Before extend or include the module, allow the configuration.
# TeeLogger.logdev = 'log1.log'
TeeLogger.configure do |config|
  config.logdev = 'log1.log'
  config.level = Logger::Severity::INFO
  config.progname = 'AwesomeApp'
  config.formatter = proc { |s, t, p, m| "#{s} #{t} #{p} #{m}\n" }
  # config.datetime_format = '%Y%m%d %H%M%S '
end

class YourAwesomeClass
  include TeeLogger

  def awesome_method
    logger.info 'this message is output `log1.log`'
  end
end

# reset configuration
TeeLogger.configuration_reset

# NOTE: sorry, `TeeLogger.logev` is deprecate.
TeeLogger.logdev = 'log2.log'
module YourAwesomeModule
  extend TeeLogger

  def self.awesome_method
    logger.info 'this message is output `log2.log`'
  end
end

```

---

## 5. Development

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

---

## 6. Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/k-ta-yamada/tee_logger.
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](https://contributor-covenant.org) code of conduct.

---

## 7. License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

---

eof

[gem_version]: https://badge.fury.io/rb/tee_logger
[gem_version-svg]: https://badge.fury.io/rb/tee_logger.svg
[travis]: https://app.travis-ci.com/k-ta-yamada/tee_logger
[travis-svg]: https://app.travis-ci.com/k-ta-yamada/tee_logger.svg?branch=master
[codeclimate]: https://codeclimate.com/github/k-ta-yamada/tee_logger
[codeclimate-svg]: https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/gpa.svg
[codeclimate_cov]: https://codeclimate.com/github/k-ta-yamada/tee_logger/coverage
[codeclimate_cov-svg]: https://codeclimate.com/github/k-ta-yamada/tee_logger/badges/coverage.svg
[inch-ci]: https://inch-ci.org/github/k-ta-yamada/tee_logger
[inch-ci-svg]: https://inch-ci.org/github/k-ta-yamada/tee_logger.svg?branch=master
[downloads-svg]: https://ruby-gem-downloads-badge.herokuapp.com/tee_logger?type=total&total_label=&color=brightgreen
[tee_logger-changelog]: https://github.com/k-ta-yamada/tee_logger/blob/master/CHANGELOG.md
