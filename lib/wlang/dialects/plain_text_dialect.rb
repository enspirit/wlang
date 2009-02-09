# Defines encoders of the plain-text dialect
module WLang::Encoders::PlainText

  # Default encoders  
  DEFAULT_ENCODERS = {"upcase" => :upcase, 
                      "downcase" => :downcase, 
                      "capitalize" => :capitalize}
  
  # Upcase encoding
  def self.upcase(src, options); src.upcase; end
  
  # Downcase encoding
  def self.downcase(src, options); src.downcase; end
  
  # Capitalize encoding
  def self.capitalize(src, options); src.capitalize; end
  
end # module WLang::Encoders::PlainText  

# Defines rulset of the plain-text dialect
module WLang::RuleSet::PlainText
    
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'+' => :upcase, '-' => :downcase}
  
  # Upcase rule as <tt>+{wlang/hosted}</tt>
  def self.upcase(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    value = parser.evaluate(expression)
    value = value.nil? ? "" : value.to_s
    result = EncoderSet::PlainText.upcase(value)
    [result, reached]
  end
  
  # Downcase rule as <tt>-{wlang/hosted}</tt>
  def self.downcase(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    value = parser.evaluate(expression)
    value = value.nil? ? "" : value.to_s
    result = EncoderSet::PlainText.downcase(value)
    [result, reached]
  end
  
end # module WLang::RuleSet::PlainText