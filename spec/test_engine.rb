require 'spec_helper'
module WLang
  describe Engine do
    
    let(:engine) { WLang::Engine.new }
    
    subject{ engine.call("Hello ${who}!") }
    
    it 'should compile a String' do
      subject.should be_a(String)
    end
    
    it 'should be the code of a Proc' do
      eval(subject).should be_a(Proc)
    end
    
    it 'should work as expected when evaluated on a context' do
      proc    = eval(subject)
     
      context = Object.new
      def context.wlang(symbols, fns)
        raise unless symbols == "$"
        raise unless fns.map(&:class) == [Proc]
        raise unless fns.first.call(self, "") == "who"
        "world"
      end

      proc.call(context, "").should eq("Hello world!")
    end
    
    it 'should work when evaluated on a dialect' do
      context = Object.new 
      def context.who; "world"; end
      dialect = WLang::Dialect.new(context)
      proc    = eval(subject)
      proc.call(dialect, "").should eq("Hello world!")
    end
    
    describe 'the high-order' do
      subject{ engine.call("Hello ${${who}}!") }
    
      it 'should support high-order' do
        context = Object.new 
        def context.world; "the world"; end
        def context.who; "world"; end
        dialect = WLang::Dialect.new(context)
        proc    = eval(subject)
        proc.call(dialect, "").should eq("Hello the world!")
      end
    end
    
  end
end