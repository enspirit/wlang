require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/encoders'
require 'wlang/dialect'
require 'wlang/parser'

#
# Main module of the WLang /code generator/template engine.
#
module WLang
  
  # Current version of WLang
  VERSION = "0.1.0".freeze
  
  # Regular expression for dialect names
  DIALECT_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Regular expression for encoder names
  ENCODER_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Main dialect
  @dialect = Dialect.new("")
  
  # Installs a dialect
  def self.dialect(name, &block)
    @dialect.dialect(name, &block)
  end
  
  # Returns an encoder
  def self.encoder(name)
    @dialect.encoder(name)
  end

end
require 'wlang/standard_dialects'

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

