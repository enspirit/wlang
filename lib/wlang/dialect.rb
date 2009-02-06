require 'wlang/encoders'
require 'wlang/rule_set'
module WLang

#
# Implements wlang/target dialect abstractions.
#
class Dialect
  attr_reader :name, :ruleset
  
  # Creates an empty target language.
  def initialize(name, parent=nil)
    @name, @parent = name, parent 
    @dialects = {}
    @encoders = Encoders.new
    @ruleset = RuleSet.new
  end

  # Adds a sub dialect
  def dialect(name, &block)
    if String===name
      raise(ArgumentError, "Invalid dialect name #{name}") unless WLang::DIALECT_NAME_REGEXP =~ name
      name = name.split('/')
    elsif not(Array===name)
      raise(ArgumentError,"Invalid dialect name #{name}")
    end
    if block_given?
      # sub-dialect installation
      raise(ArgumentError,"Unsupported composite dialect name on installation")\
        unless name.length == 1
      @dialects[name[0]] = block
      return self
    else
      child_name = name[0]
      child_dialect = factor_dialect(child_name)
      if child_dialect.nil?
        return nil
      elsif name.length==1
        return child_dialect
      else
        return child_dialect.dialect(name[1..-1]) 
      end
    end
  end
  
  # Returns a given encoder
  def encoder(name)
    if String===name
      raise(ArgumentError, "Invalid encoder name #{name}") unless WLang::ENCODER_NAME_REGEXP =~ name
      name = name.split('/')
    elsif not(Array===name)
      raise(ArgumentError,"Invalid encoder name #{name}")
    end
    if name.length==1
      return @encoders.get_encoder(name[0])
    else
      child_name = name[0]
      child_dialect = factor_dialect(child_name)
      if child_dialect.nil?
        return nil
      else
        return child_dialect.encoder(name[1..-1]) 
      end
    end
  end
  
  # Finds a encoder in dialect tree
  def find_encoder(name)
    raise(ArgumentError, "Invalid (relative) encoder name #{name}") unless String===name
    raise(ArgumentError, "Invalid (relative) encoder name #{name}") if name.include?("/")
    if @encoders.has_encoder?(name)
      @encoders.get_encoder(name)
    elsif @parent
      @parent.find_encoder(name)
    else
      nil
    end
  end
      
  # Delegated to Encoders#add_encoders
  def encoders(mod, pairs=nil)
    @encoders.add_encoders(mod, pairs)
  end

  # Delegated to RuleSet#add_rules
  def rules(mod, pairs=nil)
    @ruleset.add_rules(mod, pairs)
  end
  
  # Adds a rule for a given symbol
  def rule(symbol, &block)
    @ruleset.add_rule(symbol, &block)
  end

  # Returns the pattern to use (delagated to RuleSet#pattern)
  def pattern(block_symbols)
    @ruleset.pattern(block_symbols)
  end
  
  # Factors and return a given dialect
  def factor_dialect(name)
    dialect = @dialects[name]
    if Proc===dialect
      block, dialect = dialect, Dialect.new(name, self)
      dialect.instance_eval &block
      @dialects[name] = dialect
    end
    return dialect
  end
        
  private :factor_dialect
end # class Dialect
    
end #module WLang  