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
        buf << Temple::Utils.escape_html(evaluate(fn))
      end

      def section(buf, fn1, fn2)
        case x = evaluate(fn1)
        when FalseClass, NilClass
          nil
        when Array, Range
          x.each{|item|
            render(fn2, item, buf)
          }
        when Proc
          buf << x.call(lambda{ render(fn2) })
        else
          render(fn2, x, buf)
        end
      end

      def inverted(buf, fn1, fn2)
        case x = evaluate(fn1)
        when FalseClass, NilClass
          render(fn2, scope, buf)
        when Array
          render(fn2, scope, buf) if x.empty?
        end
      end

      def comment(buf, fn)
      end

      def partial(buf, fn)
        if x = Mustang.compile(evaluate(fn))
          render(x, scope, buf)
        end
      end

    end
    include HighOrderFunctions

    default_options :evaluator => [:hash, :send, :eval],
                    :scoping   => :stack
    tag '!', :bang
    tag '+', :plus

  end # class Html
end # module WLang
