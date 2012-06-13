module WLang
  class Scope

    attr_reader :subject
    attr_reader :parent

    def initialize(subject, parent)
      @subject, @parent = subject, parent
    end

    def self.null
      @null ||= NullScope.new
    end

    def self.coerce(arg, parent = nil)
      return arg if Scope===arg && parent.nil?
      clazz = case arg
        when Binding then BindingScope
        when Scope   then ProxyScope
        when Proc    then ProcScope
        else
          ObjectScope
      end
      clazz.new(arg, parent)
    end

    def self.chain(scopes)
      scopes.compact.inject(nil){|parent,child|
        Scope.coerce(child, parent)
      }
    end

    def root
      parent.nil? ? self : parent.root
    end

    def push(x)
      Scope.coerce(x, self)
    end

    def pop
      @parent
    end

    def with(x)
      yield(self.push(x))
    end

    def evaluate(expr, *default)
      unfound = lambda{ default.empty? ? throw(:fail) : default.first }
      expr    = expr.to_s.strip
      if expr.to_s.index('.').nil?
        fetch(expr.to_sym, &unfound)
      else
        keys = expr.split('.').map(&:to_sym)
        keys.inject(self){|scope,key|
          Scope.coerce(scope.fetch(key, &unfound))
        }.subject
      end
    end

    protected

      def safe_parent
        parent || Scope.null
      end

  end # class Scope
end # module WLang
require 'wlang/scope/null_scope'
require 'wlang/scope/proxy_scope'
require 'wlang/scope/object_scope'
require 'wlang/scope/binding_scope'
require 'wlang/scope/proc_scope'
