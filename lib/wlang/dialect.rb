require 'wlang/encoders'
require 'wlang/rule_set'
module WLang

#
# Implements wlang/target dialect abstractions.
#
class Dialect
  attr_reader :name, :ruleset
  
  # Domain specific language
  class DSL
    
    # Initializes vis a real dialect instance
    def initialize(dialect)
      @dialect = dialect
    end
    
    # Builds a sub-dialect
    def dialect(name, *extensions, &block)
      child = Dialect.new(name, @dialect, &block)
      extensions.each do |ext|
        ext = ('.' << ext) unless ext[0,1]=='.'
        WLang::FILE_EXTENSIONS[ext] = child.qualified_name
      end
      @dialect.add_child_dialect(name, child)
    end
    
    # Adds an encoder whose code is provided by a block
    def encoder(name, &block) end
    
    # Adds encoders from a given Ruby module
    def encoders(mod, pairs=nil) end
      
    # Adds a rule whose code is provided by a block 
    def rule(symbol, &block) end
    
    # Adds rules from a given Ruby module
    def rules(mod, pairs=nil) end
      
    # File extension that should be considered as being of this dialect
    def extensions(*args)
      args.each do |ext|
        ext = ('.' << ext) unless ext[0,1]=='.'
        WLang::FILE_EXTENSIONS[ext] = @dialect.qualified_name
      end
    end
    alias :extension :extensions 
    
  end # class DSL
  
  # Domain specific language for loading
  class LoadDSL
    
    # Initializes vis a real dialect instance
    def initialize(dialect)
      @dialect = dialect
    end
    
    # Builds a sub-dialect
    def dialect(name, *extensions, &block) end
    
    # Adds an encoder whose code is provided by a block
    def encoder(name, &block) 
      @dialect.add_encoder(name, &block)
    end
    
    # Adds encoders from a given Ruby module
    def encoders(mod, pairs=nil) 
      @dialect.add_encoders(mod, pairs)
    end
      
    # Adds a rule whose code is provided by a block 
    def rule(symbol, &block) 
      @dialect.add_rule(symbol, &block)
    end
    
    # Adds rules from a given Ruby module
    def rules(mod, pairs=nil) 
      @dialect.add_rules(mod, pairs)
    end
      
    # File extension that should be considered as being of this dialect
    def extensions(*args) end
    alias :extension :extensions 
    
  end # class DSL
  
  # Creates an empty target language.
  def initialize(name, parent, &builder)
    @name, @parent = name, parent 
    @builder, @built = builder, builder.nil?
    @dialects = {}
    @encoders = Encoders.new
    @ruleset = RuleSet.new
    DSL.new(self).instance_eval(&builder) unless builder.nil?
  end
  
  ### Lazy load installation ###################################################
  
  # Install the dialect
  def install
    unless is_built?
      LoadDSL.new(self).instance_eval(&@builder)
      @built = true
    end
    self
  end

  # Checks if the dialect is already built
  def is_built?
    return @built
  end
  
  # Adds a child dialect
  def add_child_dialect(name, child)
    @dialects[name] = child
  end
  
  # Adds an encoder
  def add_encoder(name, &block)
    @encoders.add_encoder(name, &block)
  end
  
  # Adds encoders from a Ruby module
  def add_encoders(mod, pairs)
    @encoders.add_encoders(mod, pairs)
  end
  
  # Adds a rule
  def add_rule(name, &block)
    @ruleset.add_rule(name, &block)
  end
  
  # Adds rules from a Ruby module
  def add_rules(mod, pairs)
    @ruleset.add_rules(mod, pairs)
  end
  
  ### Query API ################################################################
  
  # Returns a given child dialect
  def dialect(name)
    if String===name
      raise(ArgumentError, "Invalid dialect name #{name}") unless WLang::DIALECT_NAME_REGEXP =~ name
      name = name.split('/')
    elsif not(Array===name)
      raise(ArgumentError,"Invalid dialect name #{name}")
    end
    child_name = name[0]
    child_dialect = @dialects[child_name]
    if child_dialect.nil?
      return nil
    elsif name.length==1
      return child_dialect.install
    else
      child_dialect.install
      return child_dialect.dialect(name[1..-1]) 
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
      child_dialect = dialect(child_name)
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
      
  # Returns the pattern to use (delagated to RuleSet#pattern)
  def pattern(block_symbols)
    @ruleset.pattern(block_symbols)
  end
  
  ### Classical API ############################################################
  
  # Returns dialect qualified name
  def qualified_name
    parentname = @parent.nil? ? "" : @parent.to_s
    return ""==parentname ? @name : parentname + '/' + @name 
  end
  
  # Returns a string representation   
  def to_s
    qualified_name
  end
   
end # class Dialect
    
end #module WLang  