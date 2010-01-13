require 'wlang/rule'
module WLang
  
  #
  # This class allows grouping matching rules together to build a given dialect.
  # Rules are always added with add_rule, which also allows creating simple rules 
  # on the fly (that is, without subclassing Rule).
  #
  # Examples:
  #   # we will create a simple dialect with a special tag:
  #   #   <tt>+{...}</tt> which will uppercase its contents
  #   upcaser = RuleSet.new
  #   upcaser.add_rule '+' do |parser,offset|
  #     parsed, offset = parser.parse(offset)
  #     [parsed.upcase, offset] 
  #   end 
  #
  # == Detailed API
  class RuleSet

    #
    # Creates an new dialect rule set.
    #    
    def initialize() @rules, @pattern = {}, nil; end

    #  
    # Adds a tag matching rule to this rule set. _tag_ must be a String with the
    # tag associated to the rule (without the '{', that is '$' for the tag ${...}
    # for example. If rule is ommited and a block is given, a new Rule instance is 
    # created on the fly with _block_ as implementation (see Rule#new). 
    # Otherwise rule is expected to be a Rule instance. This method check its 
    # arguments, raising an ArgumentError if incorrect. 
    #
    def add_rule(tag, rule=nil, &block) 
      if rule.nil? 
        raise(ArgumentError,"Block required") unless block_given?
        rule = Rule.new(&block)
      end
      raise(ArgumentError, "Rule expected") unless Rule===rule
      @rules[tag] = rule  
      @pattern = nil 
    end

    #
    # Add rules defined in a given RuleSet module.
    #
    def add_rules(mod, pairs=nil)
      raise(ArgumentError,"Module expected") unless Module===mod
      pairs = mod::DEFAULT_RULESET if pairs.nil?
      pairs.each_pair do |symbol,method|
        meth = mod.method(method)
        raise(ArgumentError,"No such method: #{method}") if meth.nil?
        add_rule(symbol, &meth.to_proc)
      end
    end
  
    #
    # Returns a Regexp instance with recognizes all tags installed in the rule set.
    # The returned Regexp is backslashing aware (it matches <tt>\${</tt> for example)
    # as well as '{' and '}' aware. This pattern is used by WLang::Parser and is
    # not intended to be used by users themselve.
    # 
    def pattern(block_symbols) 
      build_pattern(block_symbols); 
    end

    #
    # Returns the Rule associated with a given tag, _nil_ if no such rule.
    #
    def [](tag) @rules[tag];  end
  
    
    ### protected section ######################################################
    protected
  
    # Internal implementation of pattern.
    def build_pattern(block_symbols)
      start, stop = WLang::Template::BLOCK_SYMBOLS[block_symbols]
      start, stop = Regexp.escape(start), Regexp.escape(stop)
      s = '([\\\\]{0,2}('
      i=0
      @rules.each_key do |tag|
        s << '|' if i>0
        s << '(' << Regexp.escape(tag) << ')'
        i += 1
      end
      s << ")#{start})|[\\\\]{0,2}#{start}|[\\\\]{0,2}#{stop}"
      Regexp.new(s)
    end
  
  end # class RuleSet

end # module WLang