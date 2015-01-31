#!/usr/bin/env rake
require "bundler/gem_tasks"
 
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/acts_as_translated'
  t.test_files = FileList['test/lib/acts_as_translated/*_test.rb']
  t.verbose = true
end
 
task :default => :test