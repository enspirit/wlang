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
    
  end
end