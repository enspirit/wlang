require 'rubygems'
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
    module CodeRayEncoderSet

      # Coderay recognized formats
      RECOGNIZED = ["java", "ruby", "html", "yaml", "sql", "css", "javascript", "json", "php", "xml"]

      # Default encoders  
      DEFAULT_ENCODERS = {}
      RECOGNIZED.each{|f| DEFAULT_ENCODERS[f] = f.to_sym}
  
      # Upcase encoding
      def self.coderay(src, options)
        /([a-z]+)$/ =~ options['_encoder_']
        encoder = $1.to_sym
        tokens = CodeRay.scan src, encoder
        highlighted = tokens.html({
          :wrap => :div, 
          :css => :class}
        )
        return highlighted
      end
      
      RECOGNIZED.each{|f|
        module_eval <<-EOF
          def self.#{f}(src, options) 
            WLang::EncoderSet::CodeRayEncoderSet.coderay(src, options.merge('_encoder_' => #{f.inspect}))
          end
        EOF
      }
  
    end # module CodeRay  
    
  end
end