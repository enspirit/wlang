class Hash
  
  # Allows using hash.key as a synonym for hash[:key] and
  # hash['key']
  def method_missing(name, *args, &block)
    if args.empty? and block.nil?
      self[name] || self[name.to_s]
    else
      super(name, *args, &block)
    end
  end
  
end