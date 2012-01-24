require 'wlang'
require 'wlang/dummy'
module WLang
  class Html < WLang::Dialect

    module HighOrderFunctions

      def value_of(fn)
        evaluate(render(fn).to_s.strip)
      end
      private :value_of

      def bang(buf, fn)
        buf << value_of(fn).to_s
      end

      def plus(buf, fn)
        val = value_of(fn)
        case val
        when Template
          render(val, nil, buf)
        else
          if val.respond_to?(:to_html)
            buf << val.to_html
          else
            buf << val.to_s
          end
        end
      end

      def escape(buf, fn)
        buf << Temple::Utils.escape_html(plus("", fn))
      end

    end
    include HighOrderFunctions

    tag '!', :bang
    tag '+', :plus
    tag '$', :escape

  end # class Html
end # module WLang
