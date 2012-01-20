module WLang
  class Compiler
    class MultiFlattener < Temple::Filters::MultiFlattener
      include Filter::Helpers

      recurse_on :template, :modulo, :dispatch, :proc

    end # class MultiFlattener
  end # class Compiler
end # module WLang
