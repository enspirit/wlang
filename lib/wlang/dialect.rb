require 'wlang/dialect/dispatching'
require 'wlang/dialect/scoping'
require 'wlang/dialect/evaluation'
require 'wlang/dialect/tags'
module WLang
  class Dialect
    include Dialect::Dispatching
    include Dialect::Scoping
    include Dialect::Evaluation
    include Dialect::Tags

    scoping   :strict
    evaluator :hash, :send

    class << self

      def factor(options = {})
        d = new(default_options.merge(options))
        yield(d) if block_given?
        d
      end

      def default_options
        {:braces => WLang::BRACES}
      end

      def to_ruby_code(source, options = {})
        factor(options).compiler.to_ruby_code(source)
      end

      def compile(source, options = {})
        factor(options).compiler.compile(source)
      end

      def render(source, scope = {}, buffer = "")
        compile(source).call(scope, buffer)
      end

    end

    attr_reader :options
    def braces; options[:braces]; end

    attr_reader :compiler

    def initialize(options = {})
      @options  = options
      @compiler = WLang::Compiler.new(self)
    end
    private_class_method :new

  end # class Dialect
end # module WLang
