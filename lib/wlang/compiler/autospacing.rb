module WLang
  class Compiler
    class Autospacing < Filter

      recurse_on :template, :strconcat, :wlang

      def optimize?(code)
        case code.first
        when :static
          true
        when :strconcat
          code[1].first  == :static and 
          code[-1].first == :static
        else
          false
        end
      end

      def on_fn(code)
        if optimize?(code)
          code = Strip.new(:left => true).call(code)
          code = Strip.new(:left => false).call(code)
          code = Unindent.new.call(code)
          [:fn, code]
        else
          recurse(:fn, *[code])
        end
      end

      private

      class Strip < Filter
        recurse_on :template, :wlang

        def left?
          !!options[:left]
        end

        def on_strconcat(*blks)
          if left?
            blks.unshift call(blks.shift)
          else
            blks.push call(blks.pop)
          end
          [:strconcat] + blks
        end

        def on_static(text)
          rx = left? ? /\A\s*\n/ : /\n\s*\Z/
          [:static, text.gsub(rx, '')]
        end

      end # class Strip

      class Unindent < Filter
        recurse_on :template, :wlang, :fn, :strconcat

        def on_static(text)
          [:static, text.gsub(/^  /m, '')]
        end

      end # class Unindent

    end # class Autospacing
  end # class Compiler
end # module WLang
