require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    it 'works as expected' do
      Upcasing.instantiate("Hello !{who}", {}).should eq("Hello WHO")
    end
    
    it 'do not eat extra blocks' do
      Upcasing.instantiate("Hello !{who}{world}", {}).should eq("Hello WHO{world}")
    end
    
    it "does not require a context" do
      Upcasing.instantiate("Hello !{who}").should eq("Hello WHO")
    end
    
  end # describe Dialect
end # module WLang
