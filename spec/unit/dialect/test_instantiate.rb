require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    class Upcasing < Dialect
      
      rule "!" do |fn|
        fn.call(self, "").upcase
      end
      
    end
    
    let(:upcasing){ Upcasing.new }
    
    it 'works as expected' do
      upcasing.instantiate("Hello !{who}").should eq("Hello WHO")
    end
    
    it 'do not eat extra blocks' do
      pending { upcasing.instantiate("Hello !{who}{world}").should eq("Hello WHO{world}") }
    end
    
  end # describe Dialect
end # module WLang