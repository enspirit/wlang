require 'wlang/compiler/parser'
require 'wlang/compiler/filter'
require 'wlang/compiler/dispatcher'
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
        code = to_ruby_code(source)
        proc = eval(code, TOPLEVEL_BINDING)
        Template.new(@dialect, proc)
      end
    end

    def to_ruby_code(source)
      engine.call(source)
    end

    def engine
      Class.new(Temple::Engine).tap{|c|
        c.use Parser
        c.use Dispatcher, :dialect => @dialect
        c.use ToRubyAbstraction
        c.use ToRubyCode
      }.new
    end

  end # class Compiler
end # module WLang
