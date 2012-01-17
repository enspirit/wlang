require 'spec_helper'
module WLang
  describe Dialect, ".parse" do
    
    it 'returns an Arrau' do
      Upcasing.parse("Hello !{who}").should be_a(Array)
    end
    
  end # describe Dialect
end # module WLang
