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

  #
  # Instanciates the string as a wlang template using
  # a context object and a dialect.
  #
  def wlang(context=nil, dialect="wlang/active-string") 
    WLang::Parser.instantiator(self, dialect, context).instantiate[0]
  end
    
end

