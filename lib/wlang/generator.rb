module WLang
  class Generator < Temple::Generator

    def call(x)
      compile(x)
    end
    
    def on_wlang(symbols, *procs)
      procs = procs.map{|p| call(p)}.join(', ')
      call [:dynamic, "d.wlang(#{symbols.inspect}, [#{procs}])"]
    end

    def on_proc(code)
      code = Generator.new(:buffer => "b").call(code)
      "lambda{|d,b=''| #{code} }"
    end

    def on_dynamic(code)
      concat(code)
    end
    
  end # class Generator
end # module WLang