# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modata/version'

Gem::Specification.new do |spec|
  spec.name          = "modata"
  spec.version       = Modata::VERSION
  spec.authors       = ["Yury Dymov"]
  spec.email         = ["yury@dymov.me"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  end

  spec.summary       = "Provides objective-c source code generation from models and generates web services for exposing data"
  spec.description   = ""
  spec.homepage      = "https://github.com/yury-dymov/modata"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
