module WLang
  class Compiler
    class DialectEnforcer < Filter

      def dialect; options[:dialect]; end

      recurse_on :template, :strconcat, :fn

      def on_wlang(symbols, *fns)
        extra, meth = find_dispatching_method(symbols, :unbound_method)
        if meth
          argsize, arity = fns.size, meth.arity - 1
          if extra.size > 0
            rewrite_extra_symbols(extra, symbols[extra.length..-1], fns)
          elsif argsize > arity
            rewrite_trailing_fns(symbols, fns[0...arity], fns[arity..-1])
          elsif argsize < arity
            rewrite_missing_fns(symbols, fns, arity - argsize)
          else 
            enforce_sub_dialects(symbols, fns)
          end
        else
          rewrite_unknown_tag(symbols, fns)
        end
      end

      private

      def enforce_sub_dialects(symbols, fns)
        ds = dialect.dialects_for(symbols) || []
        fns.zip(ds).inject [:wlang, symbols] do |rw, (fn, d)|
          if d
            enforcer = DialectEnforcer.new(:dialect => d.factor)
            rw << [:modulo, d, enforcer.call(fn)]
          else
            rw << call(fn)
          end
        end
      end

      def rewrite_missing_fns(symbols, fns, count)
        count.times do
          fns << [:arg, nil]
        end
        call([:wlang, symbols] + fns)
      end

      def rewrite_trailing_fns(symbols, fns, trailing)
        wlanged = call([:wlang, symbols] + fns)
        trailing.inject [:strconcat, wlanged] do |rw,fn|
          rw << [:static, '{']
          rw << call(fn.last)
          rw << [:static, '}']
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

      def find_dispatching_method(symbols, kind = :name)
        extra, symbols, found = [], symbols.chars.to_a, nil
        dialect.tap do |d|
          begin
            meth = Dialect.tag_dispatching_name(symbols)
            if d.respond_to?(meth)
              found = d.class.instance_method(meth)
              break
            else
              extra << symbols.shift
            end
          end until symbols.empty?
        end
        found = found.name.to_sym if found && kind == :name
        [extra.join, found]
      end

    end # class DialectEnforcer
  end # class Compiler
end # module WLang
