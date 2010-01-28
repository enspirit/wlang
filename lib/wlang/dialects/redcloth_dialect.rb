require 'rubygems'
module WLang
  class EncoderSet
    module RedClothEncoders
  
      # Default encoders  
      DEFAULT_ENCODERS = {"xhtml" => :xhtml_encoding}
  
      # RDoc encoding
      def self.xhtml_encoding(src, options)
        RedCloth.new(src).to_html
      end
  
    end # RedClothEncoders
  end # module EncoderSet
end # module WLang