#
# Provides an Object with all inherited instance methods removed.
#
class WLang::BasicObject

  # Methods that we keep
  KEPT_METHODS = ["__send__", "__id__", "instance_eval", "initialize",
                  :__send__, :__id__, :instance_eval, :initialize]

  # Removes all methods that are not needed to the class
  (instance_methods + private_instance_methods).each do |m|
    undef_method(m) unless KEPT_METHODS.include?(m) 
  end
    
end
