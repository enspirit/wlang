require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/parser'

#
# Main module of the WLang /code generator/template engine/
#
module WLang
  
  # Current version of WLang
  VERSION = "0.1.0".freeze
  
end

text = "\
Hello \\\\} world! ${items as i}{do +{something} \\{with \\} i} here is my name:${name} and { that's not ${common} text } !\\{\
"
#puts text
#text = "hello ${world}"

wlang = WLang::Parser.new(:xhtml)
empty = WLang::RuleSet.new
xhtml = WLang::RuleSet.new
xhtml.add_text_rule('$') {|text| text.upcase}
wlang.add_dialect(:xhtml, xhtml)
begin
wlang.instanciate(text)
rescue => ex
  puts
  raise ex
end