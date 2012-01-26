require File.expand_path('../../benchmarks/viiite_helper', __FILE__)
require 'ruby-prof'

RubyProf.start

WLang::Html.compile template("table.wlang2")

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
