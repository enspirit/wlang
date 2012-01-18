require 'spec_helper'
module WLang
  describe Dialect, ".compile" do
    
    let(:expected){%q{
      lambda{|d1,b1| b1 << ("Hello "); d1.dispatch("$", b1, lambda{|d2,b2| b2 << ("who") }); b1 << ("!") }
    }.strip}
    
    def compile(s)
      Upcasing.compile(s)
    end
    
    it 'returns the expected String' do
      compile(hello_tpl).should eq(expected)
    end
    
    it 'evaluating the String returns a template' do
      eval(compile(hello_tpl)).should be_a(Proc)
    end
    
    it 'supports a path-like as input' do
      compile(hello_path).should eq(expected)
    end
    
    it 'supports an IO object as input' do
      hello_io do |f|
        compile(f).should eq(expected)
      end
    end
    
  end # describe Dialect
end # module WLang
