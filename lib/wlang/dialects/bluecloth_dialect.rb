require 'rubygems'
module WLang
  class EncoderSet
    module BlueClothEncoders
  
      # Default encoders  
      DEFAULT_ENCODERS = {"xhtml" => :xhtml_encoding}
  
      # RDoc encoding
      def self.xhtml_encoding(src, options)
        BlueCloth.new(src).to_html
      end
  
    end # BlueClothEncoders
  end # module EncoderSet
end # module WLang