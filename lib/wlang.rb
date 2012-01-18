require "wlang/version"
require "wlang/loader"
#
# WLang is a powerful code generation and templating engine
#
module WLang
  
  # These are allows block symbols
  SYMBOLS = "!^%\"$&'*+?@~#,-./:;=<>|_".chars.to_a
  
  # Template braces
  BRACES = ['{', '}']
  
  # Defines an anonymous dialect on the fly.
  #
  # Example:
  #
  #   d = WLang::dialect do
  #     tag('$') do |fn| evaluate(fn) end
  #     ...
  #   end
  #   d.instantiate("Hello ${who}!", :who => "world")
  #   # => "Hello world!"
  #
  def self.dialect(&defn)
    Class.new(WLang::Dialect, &defn)
  end
  
end # module WLang
require 'wlang/scope'
require 'wlang/parser'
require 'wlang/compiler'
require 'wlang/generator'
require 'wlang/dialect'