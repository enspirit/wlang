require 'wlang/dialect/tags'
module WLang
  class Dialect
    include Dialect::Tags
    
    attr_reader :braces
    
    def initialize(braces = WLang::BRACES)
      @braces = braces
    end
    
    def self.parse(source, braces = WLang::BRACES)
      new(braces).send(:parse, source)
    end
    
    def self.compile(source, braces = WLang::BRACES)
      new(braces).send(:compile, source)
    end
    
    def self.template(source, braces = WLang::BRACES)
      new(braces).send(:template, source)
    end
    
    def self.instantiate(tpl, context = {}, braces = WLang::BRACES)
      new(braces).send(:instantiate, tpl, context)
    end
    
    private
    
    def parse(source)
      WLang::Parser.new.call(source)
    end
    
    def compile(source)
      engine.call(source)
    end
    
    def template(source)
      compiled = compile(source)
      proc     = eval(compiled, TOPLEVEL_BINDING)
      lambda do |context|
        with_context(context) do
          proc.call(self, "")
        end
      end
    end
    
    def instantiate(source, context)
      template(source).call(context)
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