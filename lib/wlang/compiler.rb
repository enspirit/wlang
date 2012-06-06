require 'wlang/compiler/parser'
require 'wlang/compiler/filter'
require 'wlang/compiler/dialect_enforcer'
require 'wlang/compiler/strconcat_flattener'
require 'wlang/compiler/proc_call_removal'
require 'wlang/compiler/autospacing'
require 'wlang/compiler/to_ruby_abstraction'
require 'wlang/compiler/static_merger'
require 'wlang/compiler/to_ruby_code'
module WLang
  #
  # Provides the wlang compiler which works on the following AST abstractions:
  #
  # - :template,  the root element      [:template, [:fn, ...]]
  # - :fn,        a concrete function   [:fn, code]
  # - :wlang,     a high-order function [:wlang, symbols, [:fn, ..], [:fn, ...], ...]
  # - :strconcat, concatenation         [:strconcat, [...], [...], [...]]
  # - :modulo,    modulation            [:modulo, dialect, [:fn, ...]]
  # - :static,    constant text         [:static, "..."]
  #
  class Compiler

    attr_reader :dialect

    def initialize(dialect)
      @dialect = dialect
    end

    def options
      dialect.options
    end

    def to_ruby_proc(source)
      source = eval(to_ruby_code(source), TOPLEVEL_BINDING)
      if String===source
        Proc.new{|d,buf| buf << source}
      else
        source
      end
    end

    def to_ruby_code(source)
      engine.call(source)
    end

    def to_ast(source)
      parser.new.call(source)
    end

    def parser(engine = Class.new(Temple::Engine))
      engine.tap{|c|
        c.use Parser
        c.use DialectEnforcer, :dialect => @dialect
        c.use Autospacing if options[:autospacing]
        c.use StrconcatFlattener
        c.use StaticMerger
      }
    end

    def engine(generate_code = true)
      parser.tap{|c|
        c.use ProcCallRemoval
        c.use ToRubyAbstraction
        c.use ToRubyCode if generate_code
      }.new
    end

  end # class Compiler
end # module WLang
