module WLang
  class Compiler
    class StaticMerger < Filter
      
      def on_strconcat(*exps)
        result = [:strconcat]
        text = nil

        exps.each do |exp|
          if exp.first == :static
            if text
              text << exp.last
            else
              text = exp.last.dup
              result << [:static, text]
            end
          else
            result << compile(exp)
            text = nil
          end
        end

        result
      end

    end # class StaticMerger
  end # class Compiler
end # module WLang
