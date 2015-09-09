# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tee_logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'tee_logger'
  spec.version       = TeeLogger::VERSION
  spec.authors       = ['k-ta-yamada']
  spec.email         = ['key.luvless@gmail.com']

  spec.summary       = 'logging to file and standard output'
  spec.description   = 'logging to file and standard output'
  spec.homepage      = 'https://github.com/k-ta-yamada/tee_logger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-theme'
  spec.add_development_dependency 'rubocop'

  spec.add_development_dependency 'capture_stdout'
  spec.add_development_dependency 'fakefs'
end
