$:.unshift File.expand_path('../../../lib', __FILE__)
require 'ruby-prof'
require 'wlang/mustang'

scope = {:range => (1..10000).map{|i| {:i => i}}}
tpl = WLang::Mustang.compile('#{range}{!{i}}{, }')

RubyProf.start

tpl.call(scope)

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
