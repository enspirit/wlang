require 'rubygems'
require 'rdoc/markup/to_html'

# Provides the rdoc encoder
module WLang::EncoderSet::RDoc
  
  # Default encoders  
  DEFAULT_ENCODERS = {"html" => :rdoc_encoding, "div" => :rdoc_encoding, "nop" => :nop_encoding}
  
  # RDoc encoding
  def self.rdoc_encoding(src, options); 
    RDoc::Markup::ToHtml.new.convert(src) 
  end
  
  # RDoc encoding, removing enclosing <tt><p>...</p></tt>
  def self.nop_encoding(src, options); 
    rdoc = RDoc::Markup::ToHtml.new.convert(src)
    rdoc = $1 if /^\s*<p>\s*(.*?)\s+<\/p>\s*$/m =~ rdoc
    rdoc
  end
  
end # WLang::EncoderSet::RDoc
    