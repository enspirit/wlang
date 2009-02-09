#
# Installs _wlang_ utility methods on Ruby String. 
#
class String

  # Converts the string to a wlang template
  def wlang_template(dialect="wlang/active-string", context=nil, block_symbols=:braces)
    WLang::Template.new(self, dialect, context, block_symbols)
  end
  
  #
  # Instanciates the string as a wlang template using
  # a context object and a dialect.
  #
  def wlang_instanciate(context=nil, dialect="wlang/active-string", block_symbols=:braces)
    wlang_template(dialect, context, block_symbols).instantiate
  end
  alias :wlang :wlang_instanciate
    
end

