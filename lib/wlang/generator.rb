module WLang
  class Generator < Temple::Generator

    def call(x)
      compile(x)
    end
    
    def on_wlang(symbols, *procs)
      procs = procs.map{|p| call(p)}.join(', ')
      "wlang(#{symbols.inspect}, [#{procs}])"
    end

    def on_proc(code)
      code = Generator.new(:buffer => "buf").call(code)
      "lambda{|buf| #{code} }"
    end

    def on_dynamic(code)
      concat("(#{code}).to_s")
    end
    
  end # class Generator
end # module WLang