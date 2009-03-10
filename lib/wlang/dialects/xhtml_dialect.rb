require 'cgi'
module WLang
  class EncoderSet
    
    # Defines encoders of the whtml dialect
    module XHtml
  
      # Default encoders  
      DEFAULT_ENCODERS = {"main-encoding"     => :entities_encoding,
                          "single-quoting"    => :single_quoting,
                          "double-quoting"    => :double_quoting,
                          "entities-encoding" => :entities_encoding}
  
  
      # Single-quoting encoding
      def self.single_quoting(src, options); src.gsub(/([^\\])'/,%q{\1\\\'}); end
  
      # Double-quoting encoding
      def self.double_quoting(src, options); src.gsub('"','\"'); end
    
      # Entities-encoding
      def self.entities_encoding(src, options); 
        CGI::escapeHTML(src)
      end
  
    end # module XHtml  
  end
  class RuleSet
    
    # Defines rulset of the wlang/xhtml dialect
    module XHtml
    
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {}
  
    end # module XHtml
    
  end
end

