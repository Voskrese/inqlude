# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "inqlude"
  s.version     = Inqlude::VERSION
  s.license     = 'GPL-2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Cornelius Schumacher']
  s.email       = ['schumacher@kde.org']
  s.homepage    = "http://inqlude.org"
  s.summary     = "Command line tool for handling Qt based libraries"
  s.description = "Inqlude is the command line interface for accessing the independent Qt library archive."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "inqlude"

  s.add_dependency "thor", ">=0.14.0"
  s.add_dependency "json", ">=1.5.1"
  s.add_dependency "haml", ">=3.1.1"
  s.add_dependency "json-schema", ">= 2.1.3"
  s.add_dependency "kramdown"
  s.add_dependency "xdg"

  s.add_development_dependency "rspec", "~>3"
  s.add_development_dependency "given_filesystem",  ">=0.1.2"
  s.add_development_dependency "cli_tester"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
