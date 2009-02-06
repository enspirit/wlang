module WLang

# Set of encoding functions
class Encoders
  
  # Creates an empty encoder set
  def initialize
    @encoders = {}
  end
  
  # Adds an encoder under a specific name
  def add_encoder(name, encoder=nil, &block)
    # handle String method through symbol 
    if Symbol===name 
      encoder = Proc.new {|src,options| src.send(name)}
      name = name.to_s
    end
    
    # check arguments
    raise(ArgumentError,"Block expected when no encoding function passed")\
      if encoder.nil? and not block_given?
    encoder = encoder.nil? ? block : encoder
    raise(ArgumentError,"Proc expected with arity of 2: #{encoder}, #{encoder.arity}")\
      unless Proc===encoder and encoder.arity==2
        
    # save encoder
    @encoders[name] = encoder
  end
  
  # Add all methods of a given module as encoders
  def add_encoders(mod, pairs=nil)
    raise(ArgumentError,"Module expected",caller) unless Module===mod
    pairs = mod::DEFAULT_ENCODERS if pairs.nil?
    pairs.each_pair do |name,method|
      meth = mod.method(method)
      raise(ArgumentError,"No such method: #{method} in #{mod}") if meth.nil?
      add_encoder(name, meth.to_proc)
    end
  end

  # Checks if an encoder is known
  def has_encoder?(name) 
    @encoders.has_key?(name)
  end
  
  # Returns an encoder by its name, nil if no such encoder
  def get_encoder(name)
    @encoders[name]
  end
  
  # Encodes a given source with a given encoder 
  def encode(encoder, source, options=nil)
    if String===encoder then encoder=get_encoder(encoder) end
    encoder = main_encoder unless encoder
    raise(ArgumentError,"No such encoder (or no main encoder): #{encoder}", caller)\
      unless encoder
    if options
      encoder.call(source, options)
    else
      encoder.call(source)
    end
  end

  # Returns encoder names
  def to_s
    @encoders.keys.join(", ")
  end
  
end # class EncoderSet
end # module WLang