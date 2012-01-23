module WLang
  class Compiler
    class Autospacing < Filter

      recurse_on :template, :strconcat, :wlang

      def on_fn(code)
        case code.first
        when :static
          str = code.last
          str = str.gsub(/^\s*\n/, '').
                    gsub(/^  /m, '').
                    gsub(/\n\s*$/, '')
          [:fn, [:static, str]]
        when :strconcat
          recurse(:fn, *[code])
        else
          recurse(:fn, *[code])
        end
      end

    end # class Autospacing
  end # class Compiler
end # module WLang
