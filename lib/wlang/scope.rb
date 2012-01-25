module WLang
  class Scope

    attr_reader :subject
    attr_reader :parent

    def initialize(subject, parent)
      @subject, @parent = subject, parent
    end

    def self.root
      @root ||= RootScope.new
    end

    def self.coerce(arg, parent = root)
      clazz = case arg
      when Binding
        BindingScope
      when Scope
        ProxyScope
      else
        ObjectScope
      end
      clazz.new(arg, parent)
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
      if expr.to_s.index('.').nil?
        fetch(expr.to_sym, &unfound)
      else
        keys = expr.split('.').map(&:to_sym)
        keys.inject(self){|scope,key|
          Scope.coerce(scope.fetch(key, &unfound))
        }.subject
      end
    end

  end # class Scope
end # module WLang
require 'wlang/scope/root_scope'
require 'wlang/scope/proxy_scope'
require 'wlang/scope/object_scope'
require 'wlang/scope/binding_scope'
