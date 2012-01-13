module WLang
  class Generator < Temple::Generator

    def call(x)
      compile(x)
    end

    def on_proc(name, code)
      code = Generator.new(:buffer => "buf").call(code)
      "#{name} = lambda{|buf| #{code} }"
    end

    def on_dynamic(code)
      concat("(#{code}).to_s")
    end
    
  end # class Generator
end # module WLang