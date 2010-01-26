require 'wlang/encoder_set'
require 'wlang/rule_set'
module WLang

  #
  # Implements the _dialect_ abstraction (see {README}[link://files/README.rdoc]).
  # A dialect instance is an aggregation of encoders and ruleset (through EncoderSet
  # and RuleSet classes). A dialect is also a node in the dialect tree and has a 
  # qualified name through this tree. For example <tt>wlang/xhtml</tt> is the 
  # qualified name of a <tt>xhtml</tt> dialect which is a child dialect of 
  # <tt>wlang</tt>.
  #
  # Users are not intended to use this class directly. Use the Domain Specific 
  # Language instead (see WLang::Dialect::DSL). 
  #
  # === For developers only
  #
  # In order to avoid having users to install all required gems of all dialects
  # wlang implements a lazy load design pattern on the dialect tree, through the
  # WLang::Dialect::DSL and WLang::Dialect::Loader classes. The former only creates
  # Dialect instances as tree nodes (by chaining dialects through @parent) and 
  # installs mapping with file extensions. Rules and encoders are not initially 
  # installed (precisely: WLang::Dialect::DSL#require_ruby is simply ignored). 
  # When a given dialect is needed by wlang it is first built (through the build!
  # method and the WLang::Dialect::Loader class). 
  # 
  # Standard dialect obtention methods (WLang#dialect as well as WLang::Dialect#dialect)
  # ensure that returned dialects are built. If you obtain dialects another way, 
  # be sure that they are built before using them (is_built? and build! are your 
  # friends to achieve that goal).      
  #
  # Moreover, child dialects may require tools of their ancestors. The following 
  # invariant should always be respected: if a dialect is built, all its ancestors
  # are built as well. This invariant is not enforced by the build! method because 
  # it is trivially respected by the way WLang::Dialect#dialect is implemented.   
  #
  class Dialect
  
    # Underlying ruleset
    attr_reader :ruleset
  
    # Underlying encoders
    attr_reader :encoders

    # Dialect name
    attr_reader :name
    
    # Parent dialect
    attr_reader :parent
    
    #
    # Creates a dialect instance. _builder_ block is a chunk of code of the DSL
    # that will be executed twice: once at construction time to create sub dialects
    # nodes and install file extensions and once at building time to install ruleset
    # and encoders.
    #
    def initialize(name, parent, &builder)
      @name, @parent = name, parent 
      @builder, @built = builder, builder.nil?
      @dialects = nil
      @encoders = nil
      @ruleset = nil
      DSL.new(self).instance_eval(&builder) unless builder.nil?
    end
  
    ### Lazy load mechanism ######################################################
  
    #
    # Force the dialect to be built. Has no effect if it is already built. Invokes
    # the DSL chunk of code through WLang::DSL::Loader otherwise.
    #
    def build!
      unless is_built?
        WLang::Dialect::Loader.new(self).instance_eval(&@builder)
        @built = true
      end
      self
    end

    # Returns true if this dialect is already built, false otherwise.
    def is_built?
      return @built
    end

    
    ### Installation #############################################################
  
    #
    # Adds a child dialect under _name_. _name_ cannot be qualified and must be a 
    # valid dialect name according to the wlang specification (see WLang::DIALECT_NAME_REGEXP).
    # _child_ must be a Dialect instance. 
    #
    def add_child_dialect(name, child)
      raise(ArgumentError, "Invalid dialect name") unless WLang::DIALECT_NAME_REGEXP =~ name
      raise(ArgumentError, "Dialect expected") unless Dialect===child
      @dialects = {} if @dialects.nil?
      @dialects[name] = child
    end
  
    # See EncoderSet#add_encoder
    def add_encoder(name, &block)
      @encoders = EncoderSet.new if @encoders.nil?
      @encoders.add_encoder(name, &block)
    end
  
    # See EncoderSet#add_encoders
    def add_encoders(mod, pairs)
      @encoders = EncoderSet.new if @encoders.nil?
      @encoders.add_encoders(mod, pairs)
    end
  
    # See RuleSet::add_rule
    def add_rule(name, &block)
      @ruleset = RuleSet.new if @ruleset.nil?
      @ruleset.add_rule(name, &block)
    end
  
    # See RuleSet::add_rules
    def add_rules(mod, pairs)
      @ruleset = RuleSet.new if @ruleset.nil?
      @ruleset.add_rules(mod, pairs)
    end
  
    ### Query API ################################################################
  
    # Returns qualified name of this dialect
    def qualified_name
      parentname = @parent.nil? ? "" : @parent.to_s
      return ""==parentname ? @name : parentname + '/' + @name 
    end
  
    #
    # Finds a child dialect by name. _name_ can be a String denoting a qualified 
    # name as well as an Array of strings, resulting from a qualified name split.
    # This method should always be invoked on built dialects, it always returns nil
    # otherwise. When found, returned dialect is automatically built as well as all 
    # its ancestors. When not found, the method returns nil. 
    #
    def dialect(name)
      # implement argument conventions
      if String===name
        raise(ArgumentError, "Invalid dialect name #{name}") unless WLang::QUALIFIED_DIALECT_NAME_REGEXP =~ name
        name = name.split('/')
      elsif not(Array===name)
        raise(ArgumentError,"Invalid dialect name #{name}")
      end
    
      # not built or no child at all
      return nil if @dialects.nil?
    
      # get first child name and find it
      child_name = name[0]
      child_dialect = @dialects[child_name]
    
      if child_dialect.nil?
        # unexisting, return nil
        return nil
      elsif name.length==1
        # found and last of qualified name -> build it
        return child_dialect.build!
      else
        # found but not last of qualified name -> build it and delegate
        child_dialect.build!
        return child_dialect.dialect(name[1..-1]) 
      end
    end
  
    #
    # Finds an encoder by name.
    #
    def encoder(name)
      # implement argument conventions
      if String===name
        raise(ArgumentError, "Invalid encoder name #{name}") unless WLang::QUALIFIED_ENCODER_NAME_REGEXP =~ name
        name = name.split('/')
      elsif not(Array===name)
        raise(ArgumentError,"Invalid encoder name #{name}")
      end
    
      # last name in qualified?
      if name.length==1
        # delegate to encoders
        return nil if @encoders.nil?
        return @encoders.get_encoder(name[0])
      else
        # find sub dialect, and delegate
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
      return nil if @encoders.nil?
      if @encoders.has_encoder?(name)
        @encoders.get_encoder(name)
      elsif @parent
        @parent.find_encoder(name)
      else
        nil
      end
    end
  
    # See RuleSet#pattern.
    def pattern(block_symbols)
      return RuleSet.new.pattern(block_symbols) if @ruleset.nil?
      @ruleset.pattern(block_symbols)
    end
  
    ### Other utilities ##########################################################
  
    # Factors a spacing friendly buffer for instantiation in this dialect
    def factor_buffer
      IntelligentBuffer.new
    end
  
    # Returns a string representation   
    def to_s
      qualified_name
    end
   
  end # class Dialect
    
end #module WLang  