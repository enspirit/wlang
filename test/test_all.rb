require 'wlang'
test_files = Dir['**/*_test.rb']
test_files.each { |file|
  require(file) 
}


module WLang
  
  text = "Hello \\\\} world! ${items as i}{do +{something} \\{with \\} i} here is my name:${name} and { that's not ${common} text } !\\{"
  wlang = WLang::Parser.new()
  wlang.add_dialect(:xhtml) do |s|
    s.add_rule('+', Rule.UPCASE)
    s.add_rule('-', Rule.DOWNCASE)
  end
  wlang.instanciate(text)
  puts
  
  text = "SELECT * FROM people where PEOPLE_name='${Bryan's Sheffield}'"
  wlang = WLang::Parser.new()
  wlang.add_dialect(:sql) do |s|
    s.add_rule('$', Rule.BACKQUOTE)
  end
  wlang.instanciate(text)
  puts
  
  text = %q{SELECT * FROM people where PEOPLE_name="${Bryan"s Sheffield}"}
  wlang = WLang::Parser.new()
  wlang.add_dialect(:sql) do |s|
    s.add_rule('$', Rule.BACKDOUBLEQUOTE)
  end
  wlang.instanciate(text)
  puts
  
end
                                                                                                                                    