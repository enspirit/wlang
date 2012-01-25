module WLang
  class Scope

    attr_reader :subject
    attr_reader :parent

    def initialize(subject, parent)
      @subject, @parent = subject, parent
    end

    def self.root
      RootScope.new
    end

    def self.normal(subject, parent = root)
      NormalScope.new(subject, parent)
    end

    def self.proxy(subject, parent = root)
      ProxyScope.new(subject, parent)
    end

    def push(x)
      case x
      when Scope
        ProxyScope.new(x, self)
      else
        NormalScope.new(x, self)
      end
    end

    def pop
      @parent
    end

    def with(x)
      yield(self.push(x))
    end

    def evaluate(expr, *default)
      case expr
      when Symbol
        if default.empty?
          fetch(expr)
        else
          catch(:fail){ return fetch(expr) }
          default.first
        end
      else
        syms  = expr.to_s.split('.').map(&:to_sym)
        first = evaluate(syms.first, *default)
        syms[1..-1].inject(first){|s,k|
          fetch_one_or_fail(s,k)
        }
      end
    end

    private

    def fetch_on_binding(s,k)
      s.eval(k.to_s)
    rescue NameError, NoMethodError
      block_given? ? yield(s,k) : throw(:fail)
    end

    def fetch_on_hash(s, k)
      if k == :self
        s
      elsif s.has_key?(k)
        s[k]
      elsif s.has_key?(k.to_s)
        s[k.to_s]
      else
        block_given? ? yield(s,k) : throw(:fail)
      end
    end

    def fetch_on_object(s,k)
      if k == :self
        return s
      elsif s.respond_to?(k)
        s.send(k)
      else
        block_given? ? yield(s,k) : throw(:fail)
      end
    rescue ArgumentError
      block_given? ? yield(s,k) : throw(:fail)
    end

    def fetch_one_or_fail(s,k)
      case s
      when Binding
        fetch_on_binding(s,k)
      when HashLike
        fetch_on_hash(s,k) do
          fetch_on_object(s,k)
        end
      else
        fetch_on_object(s,k)
      end
    end

    HashLike = Object.new.tap{|o|
      def o.===(arg)
        arg.respond_to?(:has_key?)
      end
    }
  end # class Scope
end # module WLang
require 'wlang/scope/root_scope'
require 'wlang/scope/normal_scope'
require 'wlang/scope/proxy_scope'
