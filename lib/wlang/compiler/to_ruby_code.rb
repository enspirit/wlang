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

      def on_dispatch(meth, *procs)
        procs = procs.map{|p| call(p)}.join(', ')
        "d#{myid}.#{meth}(b#{myid}, #{procs})"
      end

      def on_arg(code)
        code.inspect
      end

      def on_modulo(dialect, fn)
        if fn.first == :arg
          call(fn)
        else
          id   = idgen.next
          code = call(fn)
          "Proc.new{|d#{id},b#{id}| #{code}.call(#{dialect}.new(d#{id}.options, d#{id}.template), b#{id}) }"
        end
      end

      def on_proc(code)
        id   = idgen.next
        gen  = ToRubyCode.new(:buffer => "b#{id}", :idgen => idgen, :myid => id)
        code = gen.call(code)
        "Proc.new{|d#{id},b#{id}| #{code} }"
      end

    end # class ToRubyCode
  end # class Compiler
end # module WLang
