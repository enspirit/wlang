require 'rubygems'
require 'rdoc/markup/to_html'
module WLang
  class EncoderSet
    
    # Provides the rdoc encoder
    module RDocEncoders
  
      # Default encoders  
      DEFAULT_ENCODERS = {"html" => :rdoc_encoding, "div" => :rdoc_encoding, "nop" => :nop_encoding}
  
      # RDoc encoding
      def self.rdoc_encoding(src, options); 
        encoder = RDoc::Markup::ToHtml.new
        encoder.instance_eval do
          @from_path = File.dirname(options['_template_'].source_file)
        end
        encoder.convert(src) 
      end
  
      # RDoc encoding, removing enclosing <tt><p>...</p></tt>
      def self.nop_encoding(src, options); 
        rdoc = RDoc::Markup::ToHtml.new.convert(src)
        rdoc = $1 if /^\s*<p>\s*(.*?)\s+<\/p>\s*$/m =~ rdoc
        rdoc
      end
  
    end # RDoc
    
  end
end