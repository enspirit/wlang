module WLang
  class Compiler
    class StaticMerger < Temple::Filters::StaticMerger
      include Filter::Helpers

      recurse_on :template, :modulo, :dispatch, :proc

    end # class StaticMerger
  end # class Compiler
end # module WLang
