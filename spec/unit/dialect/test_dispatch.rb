require 'spec_helper'
module WLang
  describe Dialect, "dispatch" do
    
    class Foo < Dialect
      
      def execution(fn)
        "Foo#execution"
      end
      
      def escaping(fn)
        "Foo#escaping"
      end
      
      rule "!", :execution
      rule "$", :escaping
      rule "@" do |fn| "Foo#link"; end
      rule "<" do |fn| "Foo#less"; end
    end
    
    class Bar < Foo
      
      def upcasing(fn, *rest)
        "Bar#upcasing"
      end
      
      rule "$", :upcasing
      rule "<" do |fn| "Bar#less"; end
    end
    
    let(:foo){ Foo.new }
    let(:bar){ Bar.new }
    
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
      foo.dispatch(">", lambda{|buf,d| d.should eq(foo); buf << "foo"}).should eq('>{foo}')
      bar.dispatch(">", lambda{|buf,d| d.should eq(bar); buf << "bar"}).should eq('>{bar}')
    end
    
  end # describe Dialect
end # module WLang