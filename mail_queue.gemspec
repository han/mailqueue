# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'mail_queue/version'

Gem::Specification.new do |s|
  s.name        = "mail_queue"
  s.version     = MailQueue::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Han Kessels"]
  s.email       = ["han.kessels@gmail.com"]
  s.homepage    = "github.com/han/mail_queue"
  s.summary     = "Delivery method for Mail gem to deliver to a beanstalk queue"
  s.description = "Delivery method for Mail gem. Delivers mail to a beanstalk queue"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "mail_queue"

  s.add_dependency "stalker", ">= 0.6.1"
  s.add_dependency "mail", "~> 2.2.14"
  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"
  s.add_development_dependency "rspec", "~> 2.4.0 "

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end