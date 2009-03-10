require 'coderay'
module WLang
  class EncoderSet
    
    #
    # Allows coderay highlighter to be used as encoder. When using standard dialects,
    # these encoders are installed under <tt>xhtml/coderay/ruby</tt>, 
    # <tt>xhtml/coderay/html</tt>, etc. qualified names. 
    #
    # Available languages are: java, ruby, html, yaml.   
    #
    module WLang::EncoderSet::CodeRay

      # Default encoders  
      DEFAULT_ENCODERS = {"java" => :coderay, "ruby" => :coderay, "html" => :coderay, 
                          "yaml" => :coderay}
  
      # Upcase encoding
      def self.coderay(src, options);
        /([a-z]+)$/ =~ options['_encoder_']
        encoder = $1.to_sym
        tokens = CodeRay.scan src, encoder
        highlighted = tokens.html({
          :line_numbers => :inline, 
          :wrap => :div, 
          :css => :style,
          :style => :cygnus}
        )
        return highlighted
      end
  
    end # module CodeRay  
    
  end
end