module WLang
  
  #
  # Provides an Object with all inherited instance methods removed.
  #
  class BasicObject

    # Methods that we keep
    KEPT_METHODS = ["__send__", "__id__", "instance_eval", "initialize", "object_id",
                    :__send__, :__id__, :instance_eval, :initialize, :object_id]

    # Removes all methods that are not needed to the class
    (instance_methods + private_instance_methods).each do |m|
      undef_method(m) unless KEPT_METHODS.include?(m)
    end
    
  end # class BasicObject
  
end