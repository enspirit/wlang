require 'spec_helper'
module WLang
  describe Dialect, ".parse" do
    
    let(:expected){
      [:template, [:fn, [:strconcat, [:static, "Hello "], [:wlang, "$", [:fn, [:static, "who"]]], [:static, "!"]]]]
    }
    
    def parse(s)
      Upcasing.parse(s)
    end
    
    it 'returns the expected Array' do
      parse(hello_tpl).should eq(expected)
    end
    
    it 'recognizes objects that respond to :to_path' do
      s = Struct.new(:to_path).new(hello_path)
      parse(s).should eq(expected)
    end
    
    it 'recognizes objects that respond to :to_str' do
      s = Struct.new(:to_str).new(hello_tpl)
      parse(s).should eq(expected)
    end
    
    it 'recognizes IO objects' do
      hello_io do |f|
        parse(f).should eq(expected)
      end
    end
    
  end # describe Dialect
end # module WLang
