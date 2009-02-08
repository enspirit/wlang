require 'cgi'

# Defines encoders of the whtml dialect
module WLang::Encoders::XHtml
  
  # Default encoders  
  DEFAULT_ENCODERS = {"main-encoding"     => :entities_encoding, 
                      "entities-encoding" => :entities_encoding}
  
  # Upcase encoding
  def self.entities_encoding(src, options); 
    CGI::escapeHTML(src)
  end
  
end # module WLang::Encoders::XHtml  


# Defines rulset of the wlang/xhtml dialect
module WLang::RuleSet::XHtml
    
  # Default mapping between tag symbols and methods
  DEFAULT_RULESET = {}
  
end # module WLang::RuleSet::XHtml