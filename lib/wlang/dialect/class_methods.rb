module WLang
  class Dialect
    module ClassMethods
      
      def engine
        engine = Class.new(Temple::Engine)
        engine.use WLang::Parser
        engine.use WLang::Compiler, :dialect => self
        engine.use WLang::Generator
        engine.new
      end
      
      def rule(symbols, method = nil, &block)
        method ||= block
        aliasname = dispatch_name(symbols)
        if method.is_a?(Proc)
          define_method(aliasname, &block)
        else
          module_eval <<-EOF
            alias :#{aliasname} :#{method}
          EOF
        end
      end
      
      def dispatch_name(symbols)
        chars = if RUBY_VERSION >= "1.9"
          symbols.chars.map{|s| s.ord}.join("_")
        else
          symbols.chars.map{|s| s[0]}.join("_")
        end
        "_dynamic_#{chars}".to_sym
      end
      
      def dispatch(dialect, symbols, fns)
        meth = dispatch_name(symbols)
        if dialect.respond_to?(meth)
          dialect.send meth, *fns
        else
          fns.inject(""){|buf,fn| fn.call(buf, dialect)}
        end
      end
      
    end
    extend ClassMethods
  end # class Daialect
end # module WLang