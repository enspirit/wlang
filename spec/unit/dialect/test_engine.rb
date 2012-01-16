require 'spec_helper'
module WLang
  describe Dialect do
    
    class Upcasing < Dialect
      public :engine
      
      def upcasing(fn, *rest)
        fn.call(self, "").upcase
      end
      
      rule "!", :upcasing
    end
    
    let(:upcasing){ Upcasing.new }
    
    describe 'engine' do
      
      it "returns an Engine" do
        upcasing.engine.should be_a(Temple::Engine)
      end
      
    end # engine
    
    describe "instantiate" do
      
      it 'works as expected' do
        upcasing.instantiate("Hello !{who}").should eq("Hello WHO")
      end
      
    end
    
  end # describe Dialect
end # module WLang