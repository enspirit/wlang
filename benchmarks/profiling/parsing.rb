$:.unshift File.expand_path('../../../lib', __FILE__)
$:.unshift File.expand_path('../../../spec', __FILE__)
require 'ruby-prof'
require 'spec_helper'

RubyProf.start

Mustiche.parse("*{1..10000}{!{self}}{, }")

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)