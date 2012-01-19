require 'wlang/compiler/parser'
require 'wlang/compiler/to_ruby_abstraction'
require 'wlang/compiler/to_ruby_code'
module WLang
  class Compiler
    
    attr_reader :dialect
    
    def initialize(dialect)
      @dialect = dialect
    end
    
    def compile(source)
      case source
      when Template
        source
      when Proc
        Template.new(@dialect, source)
      else
        code = engine.call(source)
        proc = eval(code, TOPLEVEL_BINDING)
        compile(proc)
      end
    end
    
    def engine
      Class.new(Temple::Engine) do
        use WLang::Parser
        use WLang::ToRubyAbstraction, :dialect => @dialect
        use WLang::ToRubyCode
      end.new
    end
    
  end # class Compiler
end # module WLang
