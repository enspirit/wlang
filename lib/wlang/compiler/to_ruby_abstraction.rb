module WLang
  class ToRubyAbstraction < Temple::Filter

    def on_template(fn)
      [:template, call(fn)]
    end

    def on_strconcat(*cases)
      [:multi] + cases.map{|c| call(c)}
    end

    def on_dispatch(kind, to, *fns)
      fns.inject [:dispatch, kind, to] do |rw,fn|
        rw << call(fn)
      end
    end

    def on_fn(code)
      [:proc, call(code)]
    end

  end # class ToRubyAbstraction
end # module WLang
