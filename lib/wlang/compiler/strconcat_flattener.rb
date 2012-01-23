module WLang
  class Compiler
    class StrconcatFlattener < Filter
      recurse_on :template, :fn, :wlang, :modulo

      def on_strconcat(*children)
        if children.size == 1
          call(children.first)
        else
          children.inject [:strconcat] do |rw,child|
            child = call(child)
            if child.first == :strconcat
              child[1..-1].each do |subchild|
                rw << subchild
              end              
            else
              rw << child
            end
            rw
          end
        end
      end

    end # class StrconcatFlattener
  end # class Compiler
end # module WLang
