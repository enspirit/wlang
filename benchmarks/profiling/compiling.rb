require File.expand_path('../../commons', __FILE__)
require 'ruby-prof'

RubyProf.start

WLang::Mustang.compile("*{1..10000}{!{self}}{, }")

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
