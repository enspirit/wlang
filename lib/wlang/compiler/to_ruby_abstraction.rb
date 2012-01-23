module WLang
  class Compiler
    class ToRubyAbstraction < Filter

      def on_strconcat(*cases)
        [:multi] + cases.map{|c| call(c)}
      end

      def on_fn(code)
        [:proc, call(code)]
      end

      def on_wlang(symbols, *fns)
        meth = Dialect.tag_dispatching_name(symbols)
        fns.inject [:dispatch, meth] do |rw, fn|
          rw << call(fn)
        end
      end

    end # class ToRubyAbstraction
  end # class Compiler
end # module WLang
