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
  
end # module WLang
require 'wlang/scope'
require 'wlang/parser'
require 'wlang/compiler'
require 'wlang/generator'
require 'wlang/dialect'