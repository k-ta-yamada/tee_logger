# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tee_logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'tee_logger'
  spec.version       = TeeLogger::VERSION
  spec.authors       = ['k-ta-yamada']
  spec.email         = ['key.luvless@gmail.com']

  spec.required_ruby_version = '>= 2.5.0'

  spec.summary       = 'logging to file and standard output.'
  # rubocop:disable Metrics/LineLength
  spec.description   = 'logging to file and standard output. require standard library only.'
  # rubocop:enable Metrics/LineLength

  spec.homepage      = 'https://github.com/k-ta-yamada/tee_logger'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # rubocop:enable Metrics/LineLength
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fuubar'
  # Workaround for cc-test-reporter with SimpleCov 0.18.
  # Stop upgrading SimpleCov until the following issue will be resolved.
  # https://github.com/codeclimate/test-reporter/issues/418
  # https://github.com/codeclimate/test-reporter/issues/413
  spec.add_development_dependency 'simplecov', '= 0.17'
  spec.add_development_dependency 'simplecov-console'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-theme'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rubocop'

  spec.add_development_dependency 'capture_stdout'
  spec.add_development_dependency 'fakefs'
end
