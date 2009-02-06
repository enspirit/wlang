require 'wlang'
test_files = Dir['**/*_test.rb']
test_files.each { |file|
  require(file) 
}

require "rubygems"
require 'coderay'

tokens = CodeRay.scan "puts 'Hello, world!'", :ruby
page = tokens.html :line_numbers => :inline, :wrap => :div, :css => :style
puts page

