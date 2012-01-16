require 'spec_helper'
module WLang
  describe Dialect do
    
    class Foo < Dialect
      
      def execution(fn, *rest)
        "Foo#execution"
      end
      
      rule "!", :execution
    end
    
    let(:foo){ Foo.new }
    
    describe 'engine' do
      it "returns an Engine" do
        Foo.engine.should be_a(Temple::Engine)
      end
    end
    
  end # describe Dialect
end # module WLang