require 'spec_helper'
module WLang
  describe Dialect, "instantiate" do
    
    U = Upcasing
    let(:expected){ "Hello WHO!" }
    
    it 'works as expected' do
      U.instantiate(hello_tpl).should eq(expected)
    end
    
    it 'do not eat extra blocks' do
      U.instantiate("Hello ${who}{world}").should eq("Hello WHO{world}")
    end
    
    it "accepts an optional scope" do
      U.instantiate(hello_tpl, {}).should eq(expected)
    end
    
    it 'accepts a :to_path object' do
      U.instantiate(hello_path).should eq(expected)
    end
    
    it 'accepts an IO instance' do
      hello_io{|io| U.instantiate(io)}.should eq(expected)
    end
    
    it 'supports specifying the buffer' do
      U.instantiate(hello_tpl, {}, []).should eq(["Hello ", "WHO", "!"])
    end
    
  end # describe Dialect
end # module WLang
