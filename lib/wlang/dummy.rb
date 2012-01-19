require 'wlang'
module WLang
  #
  # The _dummy_ dialect, which has no tag at all.
  #
  # This dialect can be used to parse tag blocks without further interpreting
  # any wlang tag. This is needed to flush wlang output in certain situations
  # as illustrated by the following template:
  #
  #     Hello ${who}! This is wlang, a templating language which comes with 
  #     special tags such as %{ ${who}, +{who}, *{authors}{...}, etc }
  #
  # The special tag %{ } might easily be implemented using the Dummy dialect:
  #
  #     require 'wlang/dummy'
  #     class MyDialect < WLang::Dialect
  #       tag('$') do |fn| evaluate(fn)                 end
  #       tag('%') do |fn| WLang::Dummy.instantiate(fn) end
  #     end
  #
  class Dummy < Dialect
  end # class Dummy
end # module WLang
