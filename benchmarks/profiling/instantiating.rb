require File.expand_path('../../commons', __FILE__)
require 'ruby-prof'

People = Struct.new(:name, :score)
people = (1..10000).map{|i| People.new("People#{i}", rand)}
scope  = {:people => people}

tpl = WLang::Html.compile Path.dir/"../templates/table.mustang"

RubyProf.start

tpl.call(scope)

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
