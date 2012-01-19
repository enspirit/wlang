module WLang
  class Compiler
    class ToRubyAbstraction < Filter

      recurse_on :template, :dispatch

      def on_strconcat(*cases)
        [:multi] + cases.map{|c| call(c)}
      end

      def on_fn(code)
        [:proc, call(code)]
      end

    end # class ToRubyAbstraction
  end # class Compiler
end # module WLang
