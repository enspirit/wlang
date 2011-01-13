module WLang
  
  # 
  # Encapsulates some encoding algorithm. This class is to EncoderSet what Rule
  # is to RuleSet. Encoders are always installed on a EncoderSet (using EncoderSet#add_encoder), 
  # which is itself installed on a Dialect. Note that the method mentionned previously 
  # provides a DRY shortcut, allowing not using this class directly.
  #  
  # Example:
  #    # Encoder subclassing can be avoided by providing a block to new
  #    # The following encoder job is to upcase the text:
  #    encoder = Encoder.new do |src,options|
  #      src.upcase
  #    end
  #    
  #    # It is even better to use the DSL
  #    WLang::dialect("mydialect") do
  #      # The following encoder job is to upcase the text and will be installed
  #      # under mydialect/myupcaser qualified name 
  #      encoder("myupcaser") do |src,options|
  #        src.upcase
  #      end
  #    end
  #
  # Creating a a new encoder can be made in two ways: by subclassing this class and
  # overriding the encoder method or by passing a block to new. In both cases,
  # <b>encoders should always be stateless</b>, to allow reusable dialects that could
  # even be used in a multi-threading environment.
  #
  # == Detailed API
  class Encoder
  
    #
    # Creates a new encoder. If no block is given, the invocation of new MUST be made 
    # on a subclass overriding encoder. Otherwise, the block is considered as the 
    # effective stateless implementation of encoder and will be called with the 
    # same arguments. 
    #
    def initialize(&block)
      @block = block
    end
  
    #
    # Fired by the parser when a rule request encoding of some instantiated text.
    # Typical example is the standard tag <tt>^{encoder/qualified/name}{...}</tt>
    # (see WLang::RuleSet::Basic) which requires the second block instantiation to
    # be encoded by the encoder whose qualified name is given by the first block.
    # This method must simply return the encoded text. 
    #
    # Arguments:
    # - src: source text to encode.
    # - options: encoding options through a Hash. Available options are documented 
    #   by encoders themselve. 
    #
    def encode(src, options = {})
      raise(NotImplementedError) unless @block
      @block.call(src, options)
    end

  end # class Encoder

end