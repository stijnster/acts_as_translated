# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'acts_as_translated/version'

Gem::Specification.new do |spec|
  spec.name                   = 'acts_as_translated'
  spec.version                = ActsAsTranslated::VERSION
  spec.authors                = [ 'Stijn Mathysen' ]
  spec.email                  = [ 'stijn@skylight.be' ]
  spec.summary                = 'This acts_as extension allows easy attribute translation.'
  spec.homepage               = 'https://github.com/stijnster/acts_as_translated'
  spec.license                = 'MIT'
  spec.description            = 'ActsAsTranslated is an acts_as for ActiveRecord that allows easy attribute translation.'

  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths          = [ 'lib' ]

  spec.required_ruby_version  = '~> 2.0'

  spec.add_dependency 'activerecord', '>= 3.0.0'

  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'minitest', '~> 5.8'
end