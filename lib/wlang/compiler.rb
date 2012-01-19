require 'wlang/compiler/parser'
require 'wlang/compiler/to_ruby_abstraction'
require 'wlang/compiler/to_ruby_code'
module WLang
  class Compiler
    
    attr_reader :dialect
    
    def initialize(dialect)
      @dialect = dialect
    end
    
    def parse(source)
      WLang::Parser.new.call(source)
    end
    
    def compile(source)
      case source
      when Template
        source
      when Proc
        Template.new(@dialect, source)
      else
        parsed   = parse(source)
        compiled = compiler.call(parsed)
        proc     = eval(compiled)
        compile(proc)
      end
    end
    
    def compiler
      Class.new(Temple::Engine) do
        use WLang::ToRubyAbstraction, :dialect => @dialect
        use WLang::ToRubyCode
      end.new
    end
    
  end # class Compiler
end # module WLang
