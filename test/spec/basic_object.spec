require "wlang"
describe "WLang's version of BasicObject" do
  
  class A 
    # Methods that we keep
    KEPT_METHODS = ["__send__", "__id__", "instance_eval", "initialize", 
                    "object_id", "nil?", "singleton_method_added", "__clean_scope__",
                    "singleton_method_undefined"]

    def self.__clean_scope__
      # Removes all methods that are not needed to the class
      (instance_methods + private_instance_methods).each do |m|
        undef_method(m.to_s.to_sym) unless KEPT_METHODS.include?(m.to_s)
      end
    end
    __clean_scope__
  end
  
  it "should not have kernel methods except certain" do
    [:puts, :to_s, :hash].each do |sym|
      begin
        A.new.instance_eval{ __send__(sym, []) }
        "Not pass here".should == ""
      rescue NoMethodError 
        true.should == true
      end
    end
  end
  
  it "should not gain methods when requiring gems" do
    Kernel.load(File.join(File.dirname(__FILE__),"global_extensions.rb"))
    begin
      A.new.__clean_scope__.instance_eval{ hello_world }
      "Not pass here".should == ""
    rescue NoMethodError 
      true.should == true
    end
  end
  
end
