# v3.2.1
- [issue #18](https://github.com/k-ta-yamada/tee_logger/issues/18)
  use initial value `DEFAULT_FILE`, it's change TeeLogger.logdev

# v3.2.0
- [issue #15](https://github.com/k-ta-yamada/tee_logger/issues/15)
  Before extend or include the module, allow the setting of logdev

# v3.1.2
- add .gemspec required_ruby_version = '>= 2.0.0'

# v3.1.1
- [[clean] module split](https://github.com/k-ta-yamada/tee_logger/pull/14)

# v3.1.0
- [issue #12](https://github.com/k-ta-yamada/tee_logger/issues/12)
  Include and Extend support

# v3.0.3
- shared_examples_for_tee_logger_spec.rb [ae1e481](https://github.com/k-ta-yamada/tee_logger/commit/ae1e481)
- new constant for disabling formatter [478eccb](https://github.com/k-ta-yamada/tee_logger/commit/478eccb)

# v3.0.2
- refactoring
  - CONSTANTS move to ./lib/constants.rb

# v3.0.1
- refactoring for [issue #9](https://github.com/k-ta-yamada/tee_logger/issues/9)

# v3.0.0
- [issue #4](https://github.com/k-ta-yamada/tee_logger/issues/4)
  logging method's parametrer disabling_target change to enabling_targe
- [issue #5](https://github.com/k-ta-yamada/tee_logger/issues/5)
  log message indentation

# v2.7.0
- add datetime_format, datetime_format=

# v2.6.0
- disabling option add to logging_methods

# v2.5.0
- level, progname and formatter were changed to instance variable
- refactoring: disabling and enabling
- rm ./lib/tee_logger/constants.rb. Constants move to ./lib/tee_logger.rb

# v2.4.1
- update README.md
- and YARD comment

# v2.4.0
- TeeLogger#disable is allow block given

# v2.3.1
- refactoring TeeLogger#disable

# v2.3.0
- remove TeeLogger.attr_reader
  - and rename instance variable: @logger => @logfile
- implementation `#level` and `level=`
- implementation `#formatter` and `formatter=`

# v2.2.0
- disabling and enabling

# v2.1.1
- refactoring of test case
  - Introduced capture_stdout
  - Introduced FakeFS
- Change logdev of Console for Logger from STDOUT to $ stdout

# v2.1.0
- Integrate TeeLogger::Base class to TeeLogger::TeeLogger class

# v2.0.2
- bugfix

# v2.0.1
- bugfix

# v2.0.0
- Change to Class from Module

# v1.1.0
- bugfix

# v1.0.0
- first
