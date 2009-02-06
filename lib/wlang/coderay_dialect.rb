require 'coderay'
  
# Defines encoders of the plain-text dialect
module WLang::Encoders::CodeRay

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
  
end # module PlainText  
