require 'wlang'
require 'wlang/dummy'
module WLang
  class Html < WLang::Dialect

    module Helpers

      def value_of(fn)
        evaluate(render(fn).to_s.strip)
      end
      private :value_of
      
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
        val = value_of(fn).to_s
        render(val, nil, buf)
      end

      def plus(buf, fn)
        val = value_of(fn)
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
      
      def question(buf, fn_if, fn_then, fn_else)
        val = value_of(fn_if) ? fn_then : fn_else
        render(val, nil, buf) if val
      end
      
      def caret(buf, fn_if, fn_then, fn_else)
        val = value_of(fn_if) ? fn_else : fn_then
        render(val, nil, buf) if val
      end

      def star(buf, coll_fn, elm_fn, between_fn)
        collection, first = value_of(coll_fn), true
        collection.each do |elm|
          unless first
            render(between_fn, elm, buf) if between_fn 
          end
          render(elm_fn, elm, buf)
          first = false
        end
      end

    end
    include HighOrderFunctions

    tag '!', :bang
    tag '+', :plus
    tag '$', :dollar
    tag '&', :ampersand
    tag '?', :question
    tag '^', :caret
    tag '*', :star

  end # class Html
end # module WLang
