require 'spec_helper'
module WLang
  describe Dialect, ".compile" do
    
    it 'returns a String' do
      Upcasing.compile("Hello !{who}").should be_a(String)
    end
    
    it 'evaluting the String returns a template' do
      str = Upcasing.compile("Hello !{who}!")
      eval(str).should be_a(Proc)
    end
    
  end # describe Dialect
end # module WLang
