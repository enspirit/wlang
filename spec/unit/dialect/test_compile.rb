require 'spec_helper'
module WLang
  describe Dialect, ".compile" do
    
    it 'returns a Proc' do
      Upcasing.compile("Hello !{who}").should be_a(Proc)
    end
    
    it 'calling the Proc instantiates the template' do
      proc = Upcasing.compile("Hello !{who}!")
      proc.call({}).should eq("Hello WHO!")
    end
    
  end # describe Dialect
end # module WLang
