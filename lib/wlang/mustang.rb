require 'wlang'
module WLang
  class Mustang < WLang::Dialect
    include Temple::Utils
  
    def plus(fn)
      varname = instantiate(fn)
      known?(varname) ? evaluate(varname) : nil
    end
    tag '+', :plus
  
    def escape(fn)
      escape_html plus(fn)
    end
    tag '$', :escape
    tag '&', :escape
  
    def section(fn1, fn2)
      case x = plus(fn1)
      when FalseClass, NilClass
        nil
      when Array, Range
        x.inject(""){|buf,item|
          buf << with_scope(item){ instantiate(fn2) }
        }
      when Proc
        x.call lambda{ instantiate(fn2) }
      else
        with_scope(x){ instantiate(fn2) }
      end
    end
    tag '#', :section
  
    def inverted(fn1, fn2)
      case x = plus(fn1)
      when FalseClass, NilClass
        instantiate(fn2)
      when Array
        instantiate(fn2) if x.empty?
      end
    end
    tag '^', :inverted
  
    def comment(fn)
    end
    tag '!', :comment
  
    def partial(fn)
      if x = plus(fn)
        instantiate(x)
      end
    end
    tag '>', :partial
  
  end # class Mustang
end # module WLang
