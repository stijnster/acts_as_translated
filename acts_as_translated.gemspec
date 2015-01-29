# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_translated/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_translated"
  spec.version       = ActsAsTranslated::VERSION
  spec.authors       = ["Stijn Mathysen"]
  spec.email         = ["stijn@skylight.be"]
  spec.summary       = %q{TODO: This acts_as extension allows easy attribute translation.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
