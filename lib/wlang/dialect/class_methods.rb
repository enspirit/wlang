module WLang
  class Dialect
    module ClassMethods
      
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
      
    end
    extend ClassMethods
  end # class Daialect
end # module WLang