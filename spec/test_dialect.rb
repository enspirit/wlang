module WLang
  describe Dialect do
    
    class Foo < Dialect
      
      def execution(fn, *rest)
        "Foo#execution"
      end
      
      def escaping(fn, *rest)
        "Foo#escaping"
      end
      
      rule "!", :execution
      rule "$", :escaping
    end
    
    class Bar < Foo
      
      def upcasing(fn, *rest)
        "Bar#upcasing"
      end
      
      rule "$", :upcasing
    end
    
    describe 'dispatch_name' do
      include Dialect::ClassMethods
      it "works with a single char" do
        dispatch_name("$").should eq(:_dynamic_36)
      end
      it "works with a multiple chars" do
        dispatch_name("$$").should eq(:_dynamic_36_36)
      end
    end
    
    describe 'dispatch' do
      it 'dispatches correctly on a class' do
        Foo.new.dispatch("!", nil).should eq("Foo#execution")
        Foo.new.dispatch("$", nil).should eq("Foo#escaping")
      end
      it 'dispatches correctly on a subclass' do
        Bar.new.dispatch("!", nil).should eq("Foo#execution")
        Bar.new.dispatch("$", nil).should eq("Bar#upcasing")
      end
    end
    
    
  end
end # module WLang