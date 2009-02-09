require 'wlang/encoder'
module WLang

#
# This class allows grouping encoders together to build a given dialect.
# Encoders are always added with add_encoder, which also allows creating simple 
# encoders on the fly (that is, without subclassing Encoder).
#
# Examples:
#   # we will create a simple encoder set with two encoders, one for upcasing
#   # the other for downcasing.
#   encoders = EncoderSet.new
#   encoder.add_encoder 'upcaser' do |src,options|
#     src.upcase
#   end 
#   encoder.add_encoder 'downcaser' do |src,options|
#     src.downcase
#   end 
#
# == Detailed API
class EncoderSet
  
  # Creates an empty encoder set.
  def initialize
    @encoders = {}
  end
  
  #
  # Adds an encoder under a specific name. Supported signatures are as follows:
  # - _name_ is a symbol: _encoder_ and _block_ are ignored and encoder is 
  #   interpreted as being a method of the String class whose name is the symbol. 
  # - _name_ is a String and a block is provided: encoder is expected to be 
  #   implemented by the block which takes |src,options| arguments.
  # - _name_ is a String and _encoder_ is a Proc: same as if _encoder_ was a
  #   given block.
  #
  # Examples:
  #   encoders = EncoderSet.new
  #   # add an encoder by reusing String method
  #   encoders.add_encoder(:upcase)
  #
  #   # add an encoder by providing a block
  #   encoders.add_encoder("ucase") do |src,options|
  #     src.upcase
  #   end
  #
  #   # add an encoder by providing a Proc
  #   upcaser = Proc.new {|src,options| src.upcase}
  #   encoders.add_encoder("upcase", upcaser) 
  #
  def add_encoder(name, encoder=nil, &block)
    # handle String method through symbol 
    if Symbol===name 
      encoder, block = nil, Proc.new {|src,options| src.send(name)}
      name = name.to_s
    elsif Proc===encoder
      encoder, block = nil, encoder
    end
    
    # check arguments
    if encoder.nil? 
      raise(ArgumentError,"Block required") if block.nil?
      encoder = Encoder.new(&block)
    end
    raise(ArgumentError, "Encoder expected") unless Encoder===encoder
        
    # save encoder
    @encoders[name] = encoder
  end
  
  #
  # Adds reusable encoders defined in a Ruby module. _mod_ must be a Module instance.
  # If _pairs_ is ommitted (nil), all encoders of the module are added, under their
  # standard names (see DEFAULT_ENCODERS under WLang::EncoderSet::XHtml for example).
  # Otherwise, _pairs_ is expected to be a Hash providing a mapping between encoder 
  # names and _mod_ methods (whose names are given by ruby symbols).  
  #
  def add_encoders(mod, pairs=nil)
    raise(ArgumentError,"Module expected",caller) unless Module===mod
    pairs = mod::DEFAULT_ENCODERS if pairs.nil?
    pairs.each_pair do |name,method|
      meth = mod.method(method)
      raise(ArgumentError,"No such method: #{method} in #{mod}") if meth.nil?
      add_encoder(name, &meth.to_proc)
    end
  end

  # Checks if an encoder is installed under _name.
  def has_encoder?(name) 
    @encoders.has_key?(name)
  end
  
  # Returns an encoder by its name, nil if no such encoder.
  def get_encoder(name)
    @encoders[name]
  end
  
  #
  # Shortcut for <tt>get_encoder(encoder).encode(source,options)</tt>
  # 
  def encode(encoder, src, options=nil)
    if String===encoder then 
      ename, encoder = encoder, get_encoder(encoder) 
      raise(ArgumentError,"No such encoder: #{ename}") if encoder.nil?
    end
    raise(ArgumentError,"Invalid encoder: #{encoder}") unless Encoder===encoder
    encoder.encode(src, options)
  end

  # Returns a string with comma separated encoder names. 
  def to_s
    @encoders.keys.join(", ")
  end
  
end # class EncoderSet
end # module WLang