require 'wlang/dialect/dispatching'
require 'wlang/dialect/scoping'
require 'wlang/dialect/evaluation'
require 'wlang/dialect/dsl'
module WLang
  class Dialect
    include Dialect::Dispatching
    include Dialect::DSL

    DEFAULT_OPTIONS = {
      :braces => WLang::BRACES,
    }

    def initialize(options = {})
      @options  = DEFAULT_OPTIONS.merge(options)
      @compiler = WLang::Compiler.new(self)
    end

    def self.to_ruby_code(source, options = {})
      new(options).send(:to_ruby_code, source)
    end

    def self.compile(source, options = {})
      new(options).send(:compile, source)
    end

    def self.render(source, scope = {}, buffer = "")
      compile(source).call(scope, buffer)
    end

    def braces
      options[:braces]
    end

    private

    attr_reader :options

    def compile(source)
      @compiler.compile(source)
    end

    def to_ruby_code(source)
      @compiler.to_ruby_code(source)
    end

  end # class Dialect
end # module WLang
