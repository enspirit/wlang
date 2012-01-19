require 'wlang'
module WLang
  class Mustang < WLang::Dialect
    include Temple::Utils
    
    def evaluate(what)
      super(what)
    rescue NameError, NoMethodError
      nil
    end
  
    def plus(buf, fn)
      if x = evaluate(fn)
        buf << x.to_s
      end
    end
    tag '+', :plus
  
    def escape(buf, fn)
      buf << escape_html(evaluate(fn))
    end
    tag '$', :escape
    tag '&', :escape
  
    def section(buf, fn1, fn2)
      case x = evaluate(fn1)
      when FalseClass, NilClass
        nil
      when Array, Range
        x.each{|item|
          with_scope(item){ 
            buf << instantiate(fn2) 
          }
        }
      when Proc
        buf << x.call(lambda{ instantiate(fn2) })
      else
        with_scope(x){ buf << instantiate(fn2) }
      end
    end
    tag '#', :section
  
    def inverted(buf, fn1, fn2)
      case x = evaluate(fn1)
      when FalseClass, NilClass
        buf << instantiate(fn2)
      when Array
        buf << instantiate(fn2) if x.empty?
      end
    end
    tag '^', :inverted
  
    def comment(buf, fn)
    end
    tag '!', :comment
  
    def partial(buf, fn)
      if x = evaluate(fn)
        buf << instantiate(x)
      end
    end
    tag '>', :partial
  
  end # class Mustang
end # module WLang
