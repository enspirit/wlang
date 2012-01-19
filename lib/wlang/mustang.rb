require 'wlang'
module WLang
  class Mustang < WLang::Dialect

    module HighOrderFunctions

      def plus(buf, fn)
        if x = evaluate(fn)
          buf << x.to_s
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

    default_options :evaluator => [:hash, :send, :nofail],
                    :scoping   => :strict

    tag '+', :plus
    tag '$', :escape
    tag '&', :escape
    tag '#', :section
    tag '^', :inverted
    tag '!', :comment
    tag '>', :partial

  end # class Mustang
end # module WLang
