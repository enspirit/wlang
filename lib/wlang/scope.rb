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

    def each_frame(&blk)
      @parent.each_frame(&blk)
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
    
    def fetch_one_or_fail(s,k)
      return s if k == :self
      if s.respond_to?(:has_key?)
        return s[k] if s.has_key?(k)
        return s[k.to_s] if s.has_key?(k.to_s)
      end
      if s.respond_to?(k)
        return s.send(k)
      end
      throw :fail
    end

  end # class Scope
end # module WLang
require 'wlang/scope/root_scope'
require 'wlang/scope/normal_scope'
require 'wlang/scope/proxy_scope'
