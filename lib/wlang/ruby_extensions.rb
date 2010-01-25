#
# Installs _wlang_ utility methods on Ruby String. 
#
class String

  # Converts the string to a wlang template
  def wlang_template(dialect = "wlang/active-string", block_symbols = :braces)
    WLang::template(self, dialect, block_symbols)
  end
  
  #
  # Instantiates the string as a wlang template using
  # a context object and a dialect.
  #
  def wlang_instantiate(context = nil, dialect = "wlang/active-string", block_symbols = :braces)
    WLang::instantiate(self, context, dialect, block_symbols)
  end
  alias :wlang :wlang_instantiate
    
  def __wlang_column_of(index)
    return 1 if index == 0
    newline_index = rindex("\n", index - 1)
    if newline_index
      index - newline_index
    else
      index + 1
    end
  end
  
  def __wlang_line_of(index)
    self[0...index].count("\n") + 1
  end

end

