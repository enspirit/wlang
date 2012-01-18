require 'spec_helper'
module WLang
  describe Dialect, ".template" do
    
    def template(source)
      Upcasing.template(source)
    end
    
    it 'returns a Proc' do
      template(hello_tpl).should be_a(Proc)
    end
    
    it 'calling the Proc instantiates the template' do
      template(hello_tpl).call({}).should eq("Hello WHO!")
    end
    
    it 'supports a :to_path object' do
      template(hello_path).should be_a(Proc)
    end
    
    it 'supports an IO' do
      hello_io{|io| template(io).should be_a(Proc)}
    end
    
  end # describe Dialect
end # module WLang
