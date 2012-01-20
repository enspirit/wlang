module WLang
  class Compiler
    class DialectEnforcer < Filter

      def dialect; options[:dialect]; end

      recurse_on :template, :strconcat, :fn

      def on_wlang(symbols, *fns)
        extra, meth = find_dispatching_method(symbols, :unbound_method)
        if meth && (extra.nil? or extra.empty?)
          rewrite_known_tag(meth, symbols, fns)
        elsif meth
          symbols = symbols[extra.length..-1]
          rewrite_extra_symbols(extra, symbols, fns)
        else
          rewrite_unknown_tag(symbols, fns)
        end
      end

      private

      def rewrite_known_tag(meth, symbols, fns)
        argsize, arity = fns.size, meth.arity - 1
        optimized = nil
        if argsize > arity                    
          # trailing blocks here ${...}{xxx}
          fns, trailing = fns[0...arity], fns[arity..-1]
          wlanged = call([:wlang, symbols] + fns)
          optimized = [:strconcat, wlanged]
          trailing.inject optimized do |rw,fn|
            rw << [:static, '{']
            rw << call(fn.last)
            rw << [:static, '}']
          end
        else argsize < arity
          # possibly missing blocks in here *{...}
          optimized = fns.inject [:wlang, symbols] do |rw,fn|
            rw << call(fn)
          end
          (arity - argsize).times do 
            optimized << [:arg, nil]
          end
        end
        optimized
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
        found = found.name if found && kind == :name
        [extra.join, found]
      end

    end # class DialectEnforcer
  end # class Compiler
end # module WLang
