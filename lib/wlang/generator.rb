module WLang
  class Generator < Temple::Generator

    class IdGen
      def initialize; @current = 0;  end
      def next;       @current += 1; end
      def to_s;       @current.to_s; end
    end

    def idgen
      if options[:idgen]
        options[:idgen] 
      else
        @idgen ||= IdGen.new
      end
    end
    
    def myid
      options[:myid] || 0
    end

    def call(x)
      compile(x)
    end
    
    def on_wlang(symbols, *procs)
      procs = procs.map{|p| call(p)}.join(', ')
      call [:dynamic, "d#{myid}.wlang(#{symbols.inspect}, [#{procs}])"]
    end

    def on_proc(code)
      id   = idgen.next
      gen  = Generator.new(:buffer => "b#{id}", :idgen => idgen, :myid => id)
      code = gen.call(code)
      "lambda{|d#{id},b#{id}| #{code} }"
    end

    def on_dynamic(code)
      concat(code)
    end
    
  end # class Generator
end # module WLang