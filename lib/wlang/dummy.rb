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
  #
  #       def dollar(buf, fn)
  #         buf << evaluate(fn)
  #       end
  #
  #       def no_wlang(buf, fn)
  #         render(fn)
  #       end
  #
  #       tag '$', :dollar
  #       tag '%', [WLang::Dummy], :no_wlang
  #     end
  #
  class Dummy < Dialect
  end # class Dummy
end # module WLang
