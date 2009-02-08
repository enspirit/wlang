require 'rubygems'
require 'rdoc/markup/to_html'

# Provides the rdoc encoder
module WLang::Encoders::RDoc
  
  # Default encoders  
  DEFAULT_ENCODERS = {"html" => :rdoc_encoding, "div" => :rdoc_encoding}
  
  # Upcase encoding
  def self.rdoc_encoding(src, options); 
    RDoc::Markup::ToHtml.new.convert(src) 
  end
  
end # WLang::Encoders::RDoc
    
