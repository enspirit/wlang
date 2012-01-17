require 'spec_helper'
module WLang
  describe Dialect, ".template" do
    
    it 'returns a Proc' do
      Upcasing.template("Hello !{who}").should be_a(Proc)
    end
    
    it 'calling the Proc instantiates the template' do
      tpl = Upcasing.template("Hello !{who}!")
      tpl.call({}).should eq("Hello WHO!")
    end
    
  end # describe Dialect
end # module WLang
