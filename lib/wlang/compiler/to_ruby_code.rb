module WLang
  class Compiler
    class ToRubyCode < Temple::Generator

      class IdGen
        def initialize; @current = 0;  end
        def next;       @current += 1; end
        def to_s;       @current.to_s; end
      end

      def idgen
        options[:idgen] ? options[:idgen] : (@idgen ||= IdGen.new)
      end

      def myid
        options[:myid] || 0
      end

      def call(x)
        compile(x)
      end

      def on_template(fn)
        call(fn)
      end

      def on_dispatch_dynamic(symbols, *procs)
        procs = procs.map{|p| call(p)}.join(', ')
        "d#{myid}.dispatch(#{symbols.inspect}, b#{myid}, [#{procs}])"
      end

      def on_dispatch_static(meth, *procs)
        procs = procs.map{|p| call(p)}.join(', ')
        "d#{myid}.#{meth}(b#{myid}, [#{procs}])"
      end

      def on_proc(code)
        id   = idgen.next
        gen  = ToRubyCode.new(:buffer => "b#{id}", :idgen => idgen, :myid => id)
        code = gen.call(code)
        "lambda{|d#{id},b#{id}| #{code} }"
      end

    end # class ToRubyCode
  end # class Compiler
end # module WLang
