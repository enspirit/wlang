require 'wlang'
require 'wlang/dummy'
module WLang
  #
  # A WLang dialect mimicing the excellent Mustache.
  #
  # This dialect installs the following high-order functions:
  #
  # * `${...}` mimics mustache's `{{ ... }}` that is, it evaluates the variable and
  #    returns the HTML-escaped string
  # * `+{...}` mimics mustache's `{{{ ... }}}` that is, it evaluates the variable and
  #   returns its string representation (through `to_s`)
  # * `#{..1..}{..2..}` mimics mustache's `{{#..1..}}..2..{{/..1..}}`. For false and nil,
  #   it returns nil. For scopes and ranges, it instantiates the second block in the scope
  #   of each element in turn and returns the concatenation of instantiation results. For
  #   a Proc, it calls it, passing a rendering continuation as first argument. Every other
  #   object is used as a new scope in which the second block is instantiated.
  # * `^{..1..}{..2..}` mimics mustache's `{{^..1..}}..2..{{/..1..}}`, instantiating the
  #   second only if the evaluation of the first yields false, nil, an empty list or an
  #   unbound variable.
  # * `>{...}` mimics mustache's `{{>...}}`, instantiating the partial denoted by the
  #    evaluated expression.
  # * `!{...}` mimics mustache's `{{!...}}`, taking the block content as a comment
  #   therefore skipping it.
  #
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

    def evaluate(expr)
      super
    rescue
      nil
    end

    tag '+', :plus
    tag '$', :escape
    tag '#', :section
    tag '^', :inverted
    tag '>', :partial
    tag '!', [WLang::Dummy], :comment

  end # class Mustang
end # module WLang
