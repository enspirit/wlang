module WLang
  class Compiler
    class ProcCallRemoval < Filter

      def on_fn(core)
        if core.first == :static
          [:arg, core.last]
        else
          [:fn, call(core)]
        end
      end

    end # class ProcCallRemoval
  end # class Compiler
end # module WLang
