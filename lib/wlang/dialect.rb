require 'wlang/dialect/dispatching'
require 'wlang/dialect/dsl'
module WLang
  class Dialect
    include Dialect::Dispatching
    include Dialect::DSL
    
    DEFAULT_OPTIONS = {
      :braces => WLang::BRACES,
    }
    
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end
    
    def self.parse(source, options = {})
      new(options).send(:parse, source)
    end
    
    def self.compile(source, options = {})
      new(options).send(:compile, source)
    end
    
    def self.render(source, scope = {}, buffer = "")
      compile(source).call(scope, buffer)
    end
    
    private
    
    attr_reader :options
    
    def braces
      options[:braces]
    end
    
    def parse(source)
      source = File.read(source.to_path) if source.respond_to?(:to_path)
      source = source.to_str if source.respond_to?(:to_str)
      unless source.is_a?(String)
        raise ArgumentError, "Unable to parse from #{source.class}"
      end
      WLang::Parser.new.call(source)
    end
    
    def compile(source)
      case source
      when Template
        source
      when Proc
        Template.new(self, source)
      else
        compile(eval(to_ruby_code(source)))
      end
    end
    
    def to_ruby_code(source)
      compiler.call(parse(source))
    end
    
    def compiler
      Class.new(Temple::Engine) do
        use WLang::Compiler, :dialect => self
        use WLang::Generator
      end.new
    end
    
  end # class Dialect
end # module WLang
