module WLang
  class Compiler
    class Autospacing < Filter
      
      def on_strconcat(*exps)
        optimized = []
        exps.each_with_index do |exp,i|
          optimized[i] = call(exp)
          if exp.first == :wlang and multiline?(exp) and i != 0
            optimized[i-1] = RightStrip.new.call(optimized[i-1])
          end
        end
        [:strconcat] + optimized
      end

      def on_wlang(symbols, *fns)
        fns.inject [:wlang, symbols] do |rw,fn|
          fn = Unindent.new.call(fn)
          fn = RightStrip.new.call(fn)
          rw << call(fn)
        end
      end

      private

      def multiline?(who)
        case who.first
        when :static
          who.last =~ /\n/
        when :wlang
          who[2..-1].any?{|s| multiline?(s)}
        else
          who[1..-1].any?{|s| multiline?(s)}
        end
      end

      class RightStrip < Filter

        def on_strconcat(*exps)
          exps[-1] = call(exps[-1])
          [:strconcat] + exps
        end

        def on_static(text)
          [:static, text.gsub(/\s+\Z/m, '')]
        end

      end # class RightStrip

      class Unindent < Filter

        def on_static(text)
          [:static, text.gsub(/^  /m, '')]
        end

      end # class Unindent

    end # class Autospacing
  end # class Compiler
end # module WLang
