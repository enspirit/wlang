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
            instantiate(fn2, buf)
          }
        }
      when Proc
        buf << x.call(lambda{ instantiate(fn2) })
      else
        with_scope(x){ instantiate(fn2, buf) }
      end
    end
    tag '#', :section
  
    def inverted(buf, fn1, fn2)
      case x = evaluate(fn1)
      when FalseClass, NilClass
        instantiate(fn2, buf)
      when Array
        instantiate(fn2, buf) if x.empty?
      end
    end
    tag '^', :inverted
  
    def comment(buf, fn)
    end
    tag '!', :comment
  
    def partial(buf, fn)
      if x = evaluate(fn)
        instantiate(x, buf)
      end
    end
    tag '>', :partial
  
  end # class Mustang
end # module WLang
