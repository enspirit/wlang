require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    def instantiate(source, scope = {})
      scope.nil? ? Upcasing.instantiate(source) : Upcasing.instantiate(source, scope)
    end
    let(:expected){ "Hello WHO!" }
    
    it 'works as expected' do
      instantiate(hello_tpl, {}).should eq(expected)
    end
    
    it 'do not eat extra blocks' do
      instantiate("Hello ${who}{world}", {}).should eq("Hello WHO{world}")
    end
    
    it "does not require a scope" do
      instantiate(hello_tpl).should eq(expected)
    end
    
    it 'accepts a :to_path object' do
      instantiate(hello_path).should eq(expected)
    end
    
    it 'accepts an IO instance' do
      hello_io{|io| instantiate(io)}.should eq(expected)
    end
    
  end # describe Dialect
end # module WLang
