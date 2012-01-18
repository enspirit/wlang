require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    def instantiate(source, scope)
      Upcasing.instantiate(source, scope)
    end
    
    it 'works as expected' do
      instantiate(hello_tpl, {}).should eq("Hello WHO!")
    end
    
    it 'do not eat extra blocks' do
      instantiate("Hello ${who}{world}", {}).should eq("Hello WHO{world}")
    end
    
    it "does not require a scope" do
      Upcasing.instantiate(hello_tpl).should eq("Hello WHO!")
    end
    
  end # describe Dialect
end # module WLang
