require 'spec_helper'
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
      rule "@" do |fn, *rest| "Foo#link"; end
      rule "<" do |fn, *rest| "Foo#less"; end
    end
    
    class Bar < Foo
      
      def upcasing(fn, *rest)
        "Bar#upcasing"
      end
      
      rule "$", :upcasing
      rule "<" do |fn, *rest| "Bar#less"; end
    end
    
    let(:foo){ Foo.new }
    let(:bar){ Bar.new }
    
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
        foo.dispatch("!", nil).should eq("Foo#execution")
        foo.dispatch("$", nil).should eq("Foo#escaping")
        foo.dispatch("@", nil).should eq('Foo#link')
        foo.dispatch("<", nil).should eq('Foo#less')
      end
      it 'dispatches correctly on a subclass' do
        bar.dispatch("!", nil).should eq("Foo#execution")
        bar.dispatch("$", nil).should eq("Bar#upcasing")
        bar.dispatch("@", nil).should eq('Foo#link')
        bar.dispatch("<", nil).should eq('Bar#less')
      end
      it 'dispatches correctly on unknown symbols' do
        foo.dispatch(">", lambda{|buf,d| d.should eq(foo); "Foo#>"}).should eq('Foo#>')
        bar.dispatch(">", lambda{|buf,d| d.should eq(bar); "Bar#>"}).should eq('Bar#>')
      end
    end
    
  end # describe Dialect
end # module WLang