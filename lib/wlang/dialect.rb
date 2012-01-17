require 'wlang/dialect/tags'
module WLang
  class Dialect
    include Dialect::Tags
    
    attr_reader :braces
    
    def initialize(braces = WLang::BRACES)
      @braces = braces
    end
    
    def self.compile(template, braces = WLang::BRACES)
      new(braces).send(:compile, template)
    end
    
    def instantiate(tpl, context = {})
      @context = Scope.factor(context)
      code = engine.call(tpl)
      proc = eval(code)
      proc.call(self, "")
    end
    
    def _(fn)
      fn.call(self, "")
    end
    
    def evaluate(what)
      @context.instance_eval(what)
    end
    
    def with_context(ctx)
      old, @context = @context, ctx
      yield
    ensure
      @context = ctx
    end
    
    private
    
    def compile(template)
      source = engine.call(template)
      proc   = eval(source, TOPLEVEL_BINDING)
      lambda do |context|
        with_context(context) do
          proc.call(self, "")
        end
      end
    end
    
    def engine
      engine = Class.new(Temple::Engine)
      engine.use WLang::Parser
      engine.use WLang::Compiler, :dialect => self
      engine.use WLang::Generator
      engine.new
    end
    
  end # class Dialect
end # module WLang