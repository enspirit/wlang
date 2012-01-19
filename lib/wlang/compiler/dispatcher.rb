module WLang
  class Compiler
    class Dispatcher < Filter

      def dialect; options[:dialect]; end

      recurse_on :template, :strconcat, :fn

      def on_wlang(symbols, *fns)
        if dialect
          extra, meth = dialect.find_dispatching_method(symbols)
          if meth && (extra.nil? or extra.empty?)
            dispatch_known_tag(symbols, meth, fns)
          elsif meth
            dispatch_extra_symbols(extra, symbols, fns)
          else
            dispatch_unknown_tag(symbols, fns)
          end
        else
          dispatch_no_dialect(symbols, fns)
        end
      end

      private

      def dispatch_no_dialect(symbols, fns)
        fns.inject([:dispatch, :dynamic, symbols]) do |rw, fn|
          rw << call(fn)
        end
      end

      def dispatch_known_tag(symbols, meth, fns)
        d = Dispatcher.new(:dialect => nil)
        fns.inject([:dispatch, :static, meth]) do |rw, fn|
          rw << d.call(fn)
        end
      end

      def dispatch_extra_symbols(extra, symbols, fns)
        wlang = [:wlang, symbols[extra.length..-1]] + fns
        wlang = call(wlang)
        [:strconcat, [:static, extra], wlang]
      end

      def dispatch_unknown_tag(symbols, fns)
        start, stop = dialect.braces
        from = [:strconcat, [:static, symbols]]
        fns.inject(from) do |rw, fn|
          rw << [:static, start]
          rw << call(fn.last)
          rw << [:static, stop]
        end
      end

    end # class Dispatcher
  end # class Compiler
end # module WLang
