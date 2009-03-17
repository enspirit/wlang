module WLang
  class RuleSet
    module Utils
  
      # Regexp string for 'dialect'
      DIALECT = '[-a-z]+'
      
      # Regexp string for 'encoder'
      ENCODER = '[-a-z]+'
      
      # Regexp string for 'qualified/dialect'
      QDIALECT = DIALECT + '([\/]' + DIALECT + ')*'
      
      # Regexp string for 'qualified/encoder'
      QENCODER = ENCODER + '([\/]' + ENCODER + ')*'
      
      # Regexp string for 'user_variable'
      VAR = '[a-z][a-z0-9_]*'
      
      # Regexp string for expression in the hosting language
      EXPR = '.*?'
      
      # Regexp string for expression in the hosting language
      NO_SPACE = '[^\s]+'
      
      # Regexp string for URI expresion
      URI = '[^\s]+'
      
      # Part of a with expression
      WITH_PART = '(' + VAR + ')' + '\s*:\s*(' + EXPR + ')'
      
      # Regexp string for with expression
      WITH = WITH_PART + '(\s*,\s*(' + WITH_PART + '))*'
      
      # Regexp string for as expression
      MULTI_AS = VAR + '(' + '\s*,\s*' + VAR + ')*'
      
      # Basic blocks for building expressions
      BASIC_BLOCKS = {
        :dialect   => {:str => DIALECT,   :groups => 0, :decoder => nil},
        :encoder   => {:str => ENCODER,   :groups => 0, :decoder => nil},
        :qdialect  => {:str => QDIALECT,  :groups => 1, :decoder => nil},
        :qencoder  => {:str => QENCODER,  :groups => 1, :decoder => nil},
        :var       => {:str => VAR,       :groups => 0, :decoder => nil},
        :no_space  => {:str => NO_SPACE,  :groups => 0, :decoder => :decode_expr},
        :expr      => {:str => EXPR,      :groups => 0, :decoder => :decode_expr},
        :uri       => {:str => URI,       :groups => 0, :decoder => nil},
        :with      => {:str => WITH,      :groups => 6, :decoder => :decode_with},
        :multi_as  => {:str => MULTI_AS,  :groups => 1, :decoder => :decode_multi_as}      
      }
      
      # Regular expressions of built expressions
      REGEXPS = {}
      
      # Builds an expression.
      def self.expr(*args)
        expr = REGEXPS[args]
        if expr.nil?
          # 1) we simply create an equivalent regular expression in _str_
          str, hash, count = '^\s*', {}, 0
          args.each do |arg|
            case arg
              when Symbol
                raise ArgumentError, "No reusable RuleSet::Utils block called #{arg}"\
                  unless BASIC_BLOCKS[arg]
                str << '(' << BASIC_BLOCKS[arg][:str] << ')'
                hash[arg] = [(count+=1), BASIC_BLOCKS[arg][:decoder]]
                count += BASIC_BLOCKS[arg][:groups]
              when Array
                keyword, what, mandatory = arg
                raise ArgumentError, "No reusable RuleSet::Utils block called #{what}"\
                  unless BASIC_BLOCKS[what]
                mandatory = true if mandatory.nil?
                unless mandatory
                  str << '('
                  count += 1
                end
                str << '\s+' << keyword << '\s+'
                str << '(' << BASIC_BLOCKS[what][:str] << ')'
                str << ')?' unless mandatory
                hash[keyword.to_sym] = [(count+=1), BASIC_BLOCKS[what][:decoder]]
                count += BASIC_BLOCKS[what][:groups]
              else
                raise ArgumentError, "Symbol or Array expected"
            end
          end
          str << '\s*$'
          
          # here is the expression, on which we put a decode method
          expr = {:regexp  => Regexp.new(str), :places  => hash}
          def expr.decode(str, parser=nil)
            matchdata = self[:regexp].match(str)
            return nil if matchdata.nil?
            decoded = {}
            self[:places].each_pair do |k,v|
              value = matchdata[v[0]]
              value = Utils.send(v[1], value, parser)\
                if v[1] and not(value.nil?)
              decoded[k] = value
            end
            return decoded
          end
          
          # and we save it!
          REGEXPS[args] = expr   
        end
        expr
      end
      
      # Decodes an expression using the parser
      def self.decode_expr(expr, parser) 
        return expr if parser.nil?
        parser.evaluate(expr)
      end
        
      # Regular expression for WITH
      RG_WITH = Regexp.new('^' + WITH + '$')
    
      # Decodes a with expression
      def self.decode_with(expr, parser, hash={})
        matchdata = RG_WITH.match(expr)
        return hash if matchdata.nil?
        hash[matchdata[1]] = decode_expr(matchdata[2], parser)
        decode_with(matchdata[4], parser, hash)
      end
      
      # Decodes a multi as expression
      def self.decode_multi_as(expr, parser)
        expr.split(/\s*,\s*/)
      end
      
      # Builds a hash for 'using ... with ...' rules from a decoded expression
      def self.context_from_using_and_with(decoded)
        context = decoded[:using]
        context = context.dup unless context.nil?
        context = {} if context.nil?
        context.merge!(decoded[:with]) unless decoded[:with].nil?
        context  
      end
      
      
      ### DEPRECATED API ####################################################
        
      # Regular expression for 'user_variable'
      RG_VAR = Regexp.new('^\s*(' + VAR + ')\s*$')
      
      # Regular expression for expression in the hosting language
      RG_EXPR = Regexp.new('^\s*(' + EXPR + ')\s*$')
      
      # Regular expression for expression in the hosting language
      RG_URI = Regexp.new('^\s*(' + URI + ')\s*$')
      
      # Part of a with expression
      RG_WITH_PART = Regexp.new('(' + VAR + ')' + '\s*:\s*([^,]+)')
      
      # Regular expression for 'dialect'
      RG_DIALECT = Regexp.new('^\s*(' + DIALECT + ')\s*$')
      
      # Regular expression for 'encoder'
      RG_ENCODER = Regexp.new('^\s*(' + ENCODER + ')\s*$')
      
      # Regular expression for 'qualified/dialect'
      RG_QDIALECT = Regexp.new('^\s*(' + QDIALECT + ')\s*$')
      
      # Regular expression for 'qualified/encoder'
      RG_QENCODER = Regexp.new('^\s*(' + QENCODER + ')\s*$')
      
      # Regexp string for 'qualified/dialect as var'
      QDIALECT_AS = '(' + QDIALECT + ')\s+as\s+(' + VAR + ')'
      
      # Regular expression for 'qualified/dialect as var'
      RG_QDIALECT_AS = Regexp.new('^\s*(' + QDIALECT_AS + ')\s*$')
      
      # Regexp string for 'qualified/dialect with ...'
      QDIALECT_WITH = '(' + QDIALECT + ')\s+as\s+(' + WITH + ')'
      
      # Regular expression for 'qualified/dialect with ...'
      RG_QDIALECT_WITH = Regexp.new('^\s*(' + QDIALECT_WITH + ')\s*$')
      
      # Regexp string for 'qualified/encoder as var'
      QENCODER_AS = '(' + QENCODER + ')\s+as\s+(' + VAR + ')'
      
      # Regular expression for 'qualified/encoder as var'
      RG_QENCODER_AS = Regexp.new('^\s*(' + QENCODER_AS + ')\s*$')
      
      # Regexp string for 'wlang/hosted as var'
      EXPR_AS = '(' + EXPR + ')\s+as\s+(' + VAR + ')'
      
      # Regular expression for 'wlang/hosted as var'
      RG_EXPR_AS = Regexp.new('^\s*(' + EXPR_AS + ')\s*$')
      
      # Regexp string for 'wlang/uri as var'
      URI_AS = '(' + URI + ')\s+as\s+(' + VAR + ')'
      
      # Regular expression for 'wlang/uri as var'
      RG_URI_AS = Regexp.new('^\s*(' + URI_AS + ')\s*$')
  
      # Regespc string for 'wlang/uri with ...'
      URI_WITH = '(' + URI + ')\s+with\s+(' + WITH + ')'
            
      # Regular expression for 'wlang/uri as var'
      RG_URI_WITH = Regexp.new('^\s*(' + URI_WITH + ')\s*$')
      
      # Decodes a simple var expression
      def self.decode_var(src)
        match = RG_VAR.match(src)
        return nil unless match
        {:variable => match[1]} 
      end
      
      # Decodes a 'qualified/dialect as var'. Returns a hash
      # with :dialect and :variable keys, or nil if _str_ does
      # not match.
      def self.decode_qdialect_as(str)
        match = RG_QDIALECT_AS.match(str)
        return nil unless match
        {:dialect => match[2], :variable => match[4]} 
      end
      
      # Decodes a 'qualified/encoder as var'. Returns a hash
      # with :encoder and :variable keys, or nil if _str_ does
      # not match.
      def self.decode_qencoder_as(str)
        match = RG_QENCODER_AS.match(str)
        return nil unless match
        {:encoder => match[2], :variable => match[4]} 
      end
      
      # Decodes a 'wlang/hosted as var'. Returns a hash
      # with :expression and :variable keys, or nil if _str_ does
      # not match.
      def self.decode_expr_as(str)
        match = RG_EXPR_AS.match(str)
        return nil unless match
        {:expr => match[2], :variable => match[3]} 
      end
      
      # Decodes a 'wlang/uri as var'. Returns a hash
      # with :uri and :variable keys, or nil if _str_ does
      # not match.
      def self.decode_uri_as(str)
        match = RG_URI_AS.match(str)
        return nil unless match
        {:uri => match[2], :variable => match[3]} 
      end
      
      # Decodes a 'wlang/uri with ...'. Returns a hash
      # with :uri and :with keys (with being another hash), or nil if _str_ does
      # not match.
      def self.decode_uri_with(str, parser=nil, optional=false)
        match = RG_URI_WITH.match(str)
        if match.nil?
          return nil unless optional
          match = RG_URI.match(str)
          return nil if match.nil?
          return {:uri => match[1], :with => nil}
        else
          with_expr, with = match[3], {}
          exprs = with_expr.split(/\s*,\s*/)
          exprs.each do |expr|
            RG_WITH_PART =~ expr
            with[$1] = parser.nil? ? $2 : parser.evaluate($2)
          end
          {:uri => match[2], :with => with} 
        end
      end
  
      # Decodes a 'wlang/dialect with ...'. Returns a hash
      # with :dialect and :with keys (with being another hash), 
      # or nil if _str_ does not match.
      def self.decode_qdialect_with(str, parser=nil, optional=false)
        match = RG_QDIALECT_WITH.match(str)
        if match.nil?
          return nil unless optional
          match = RG_QDIALECT.match(str)
          return nil if match.nil?
          return {:dialect => match[1], :with => nil}
        else
          with_expr, with = match[3], {}
          exprs = with_expr.split(/\s*,\s*/)
          exprs.each do |expr|
            RG_WITH_PART =~ expr
            with[$1] = parser.nil? ? $2 : parser.evaluate($2)
          end
          {:dialect => match[2], :with => with} 
        end
      end

    end
  end
end