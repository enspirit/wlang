require 'wlang/dialect/dispatching'
require 'wlang/dialect/dsl'
module WLang
  class Dialect
    include Dialect::Dispatching
    include Dialect::DSL
    
    DEFAULT_OPTIONS = {
      :braces     => WLang::BRACES,
      :compile_as => :template
    }
    
    def initialize(options = {})
      options = {:compile_as => options} if options.is_a?(Symbol)
      @options = DEFAULT_OPTIONS.merge(options)
    end
    
    def self.parse(source, options = {})
      new(options).send(:parse, source)
    end
    
    def self.compile(source, options = {})
      new(options).send(:compile, source)
    end
    
    def self.instantiate(tpl, scope = {}, options = {})
      new(options).send(:instantiate, tpl, scope)
    end
    
    private
    
    attr_reader :options
    
    def braces
      options[:braces]
    end
    
    def parse(source)
      source = File.read(source.to_path) if source.respond_to?(:to_path)
      source = source.to_str if source.respond_to?(:to_str)
      WLang::Parser.new.call(source)
    end
    
    def compile(source)
      rubycode = compiler.call(parse(source))
      case options[:compile_as]
      when :source
        rubycode
      when :proc
        eval(rubycode, TOPLEVEL_BINDING)
      when :template
        Template.new self, &eval(rubycode, TOPLEVEL_BINDING)
      else
        msg = "No such compilation scheme #{options[:compile_as]}"
        raise ArgumentError, msg, caller
      end
    end
    
    def instantiate(source, scope)
      case source
      when Template
        source.call(scope)
      when Proc
        with_scope(scope){ source.call(self, "") }
      else
        instantiate(compile(source), scope)
      end
    end
    
    def compiler
      Class.new(Temple::Engine) do
        use WLang::Compiler, :dialect => self
        use WLang::Generator
      end.new
    end
    
  end # class Dialect
end # module WLang