require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    class Upcasing < Dialect
      
      def upcasing(fn, *rest)
        fn.call(self, "").upcase
      end
      
      rule "!", :upcasing
    end
    
    let(:upcasing){ Upcasing.new }
    
    it 'works as expected' do
      upcasing.instantiate("Hello !{who}").should eq("Hello WHO")
    end
    
  end # describe Dialect
end # module WLang