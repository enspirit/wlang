# Defines encoders of the plain-text dialect
module WLang::EncoderSet::PlainText

  # Default encoders  
  DEFAULT_ENCODERS = {"upcase" => :upcase, 
                      "downcase" => :downcase, 
                      "capitalize" => :capitalize,
                      "camel-case" => :camel_case}
  
  # Accents to replace when camel-casing
#  ACCENTS = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
#              ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
#              ['í','ì','î','ï','I','Î','Ì'] => 'i',
#              ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
#              ['œ'] => 'oe',
#              ['ß'] => 'ss',
#              ['ú','ù','û','ü','U','Û','Ù'] => 'u'}
                      
  # Upcase encoding
  def self.upcase(src, options); src.upcase; end
  
  # Downcase encoding
  def self.downcase(src, options); src.downcase; end
  
  # Capitalize encoding
  def self.capitalize(src, options); src.capitalize; end
  
  # Converts a string as CamelCase
  def self.camel_case(src, options)
#    ACCENTS.each do |ac,rep|
#      ac.each do |s|
#        src.gsub!(s, rep)
#      end
#    end
    src.gsub!(/[^a-zA-Z ]/," ")
    src = " " + src.split.join(" ")
    src.gsub!(/ (.)/) { $1.upcase }    
  end
    
end # module WLang::EncoderSet::PlainText

# Defines rulset of the plain-text dialect
module WLang::RuleSet::PlainText
    
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {'+' => :upcase, '-' => :downcase}
  
  # Upcase rule as <tt>+{wlang/hosted}</tt>
  def self.upcase(parser, offset)
    expression, reached = parser.parse(offset, "wlang/ruby")
    value = parser.evaluate(expression)
    value = value.nil? ? "" : value.to_s
    result = WLang::EncoderSet::PlainText.upcase(value)
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