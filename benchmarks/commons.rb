$:.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems' if RUBY_VERSION <= "1.9"
require 'bundler/setup'
require 'wlang/mustang'
require 'benchmark'
require 'erb'
require 'mustache'
require 'viiite'
require 'epath'