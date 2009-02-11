# Encoders for ruby
module WLang::EncoderSet::Ruby
  
  # Default encoders  
  DEFAULT_ENCODERS = {"single-quoting" => :single_quoting, 
                      "double-quoting" => :double_quoting, 
                      "regex-escaping" => :regex_escaping}
  
  # Upcase encoding
  def self.single_quoting(src, options); 
    src.gsub(/([^\\])'/,%q{\1\\\'}); 
  end
  
  # Downcase encoding
  def self.double_quoting(src, options); src.gsub('"','\"'); end
  
  # Capitalize encoding
  def self.regex_escaping(src, options); Regexp.escape(src); end
  
end # module WLang::EncoderSet::Ruby  

# Defines rulset of the wlang/ruby dialect
module WLang::RuleSet::Ruby
    
    # Default mapping between tag symbols and methods
    DEFAULT_RULESET = {}
    
end # module WLang::RuleSet::Ruby