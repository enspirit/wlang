# Encoders for ruby
module WLang::EncoderSet::SQL
  
  # Default encoders  
  DEFAULT_ENCODERS = {"single-quoting" => :single_quoting}
  
  # Upcase encoding
  def self.single_quoting(src, options); src.gsub("'","\\\\'"); end
  
end # module WLang::EncoderSet::Ruby  

# Defines rulset of the wlang/ruby dialect
module WLang::RuleSet::SQL
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {}
    
end # module WLang::RuleSet::Ruby

# Encoders for ruby
module WLang::EncoderSet::SQL::Sybase
  
  # Default encoders  
  DEFAULT_ENCODERS = {"single-quoting" => :single_quoting}
  
  # Upcase encoding
  def self.single_quoting(src, options); src.gsub("'","''"); end
  
end # module WLang::EncoderSet::Ruby  
