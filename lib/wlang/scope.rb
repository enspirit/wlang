module WLang
  class Scope

    attr_reader :subject
    attr_reader :parent

    def initialize(subject, parent)
      @subject, @parent = subject, parent
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
    
    def each_frame(&blk)
      @parent.each_frame(&blk)
    end
    
    def frames
      frames = []
      each_frame{|f| frames << f}
      frames
    end
    
    def fetch(expr)
      @parent.fetch(expr)
    end

    def evaluate(expr)
      fetch(expr.to_s.split('.'))
    end

  end # class Scope
end # module WLang
require 'wlang/scope/root_scope'
require 'wlang/scope/normal_scope'
require 'wlang/scope/proxy_scope'

