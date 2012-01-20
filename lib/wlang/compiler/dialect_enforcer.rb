module WLang
  class Compiler
    class DialectEnforcer < Filter

      def dialect; options[:dialect]; end

      recurse_on :template, :strconcat, :fn

      def on_wlang(symbols, *fns)
        extra, meth = dialect.find_dispatching_method(symbols)
        if meth && (extra.nil? or extra.empty?)
          rewrite_known_tag(symbols, fns)
        elsif meth
          symbols = symbols[extra.length..-1]
          rewrite_extra_symbols(extra, symbols, fns)
        else
          rewrite_unknown_tag(symbols, fns)
        end
      end

      private

      def rewrite_known_tag(symbols, fns)
        fns.inject [:wlang, symbols] do |rw, fn|
          rw << call(fn)
        end
      end

      def rewrite_extra_symbols(extra, symbols, fns)
        wlang = fns.inject [:wlang, symbols] do |rw,fn|
          rw << fn
        end
        [:strconcat, [:static, extra], call(wlang)]
      end

      def rewrite_unknown_tag(symbols, fns)
        start, stop = dialect.braces
        from = [:strconcat, [:static, symbols]]
        fns.inject(from) do |rw, fn|
          rw << [:static, start]
          rw << call(fn.last)
          rw << [:static, stop]
        end
      end

    end # class DialectEnforcer
  end # class Compiler
end # module WLang
