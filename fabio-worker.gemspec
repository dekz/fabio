# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'version'

Gem::Specification.new do |s|
  s.name        = "fabio-worker"
  s.version     = Fabio::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jacob Evans"]
  s.email       = ["jacob@dekz.net"]
  s.summary     = %q{Fabio worker}
  s.description = %q{Fabio worker}

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "bundler"

  git_files            = `git ls-files`.split("\n") rescue ''
  s.files              = git_files
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables        = %w(fabio)
  s.require_paths      = ["lib"]
end
