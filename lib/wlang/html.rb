require 'wlang'
require 'wlang/dummy'
module WLang
  class Html < WLang::Dialect

    module Helpers

      def to_html(val)
        val = val.to_html if val.respond_to?(:to_html)
        val = to_html(val.call) if val.is_a?(Proc)
        val.to_s
      end
      private :to_html

      def escape_html(val)
        Temple::Utils.escape_html(val)
      end
      private :escape_html

    end
    include Helpers

    module HighOrderFunctions

      def bang(buf, fn)
        val = evaluate(fn).to_s
        render(val, nil, buf)
      end

      def plus(buf, fn)
        val = evaluate(fn)
        val = to_html(val) unless val.is_a?(Template)
        render(val, nil, buf)
      end

      def dollar(buf, fn)
        val = escape_html(plus("", fn))
        render(val, nil, buf)
      end

      def ampersand(buf, fn)
        val = escape_html(render(fn))
        render(val, nil, buf)
      end

      def slash(buf, fn)
      end

      def modulo(buf, fn)
        render(fn, nil, buf)
      end

      def question(buf, fn_if, fn_then, fn_else)
        val   = evaluate(fn_if)
        val   = val.call if Proc===val
        block = val ? fn_then : fn_else
        render(block, nil, buf) if block
      end

      def caret(buf, fn_if, fn_then, fn_else)
        question(buf, fn_if, fn_else, fn_then)
      end

      def star(buf, coll_fn, elm_fn, between_fn)
        collection = evaluate(coll_fn)
        collection.each_with_index do |elm,i|
          render(between_fn, elm, buf) if between_fn and (i > 0)
          render(elm_fn, elm, buf)
        end
      end

      def greater(buf, fn)
        val = evaluate(fn)
        val = Html.compile(val) if String === val
        val = val.call if Proc === val and val.arity<=0
        render(val, nil, buf)
      end

      def sharp(buf, who_fn, then_fn)
        val = evaluate(who_fn, nil)
        if val and not(val.respond_to?(:empty?) and val.empty?)
          render(then_fn, val, buf)
        end
      end

    end
    include HighOrderFunctions

    default_options :autospacing => true
    tag '!', :bang
    tag '+', :plus
    tag '$', :dollar
    tag '&', :ampersand
    tag '/', :slash
    tag '%', [WLang::Dummy], :modulo
    tag '?', :question
    tag '^', :caret
    tag '*', :star
    tag '>', :greater
    tag '#', :sharp

  end # class Html
end # module WLang
