require File.expand_path('../../benchmarks/viiite_helper', __FILE__)
require 'ruby-prof'

tpl = WLang::Html.compile template("table.wlang2")

RubyProf.start

tpl.call(scope)

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
