require 'spec_helper'
module WLang
  describe Parser do
    
    def parse(input)
      WLang::Parser.new.call(input)
    end
    
    let(:expected) {
      [:template,
        [:fn, 
          [:strconcat,
            [:static, "Hello "],
            [:wlang,  "$",
              [:fn, 
                [:static, "who"]]],
            [:static, "!"]]]]
    }
    
    it 'should parse "Hello ${world}!" as expected' do
      parse(hello_tpl).should eq(expected)
    end
    
    it 'should support high-order wlang' do
      expected = \
      [:template,
        [:fn, 
          [:wlang,  "$",
            [:fn, 
              [:wlang, "$", 
                [:fn, 
                  [:static, "who"]]]]]]]
      parse("${${who}}").should eq(expected)
    end
    
    it 'should support mutli-block functions' do
      expected = \
      [:template,
        [:fn, 
          [:wlang,  "$",
            [:fn, [:static, "first" ]],
            [:fn, [:static, "second"]]]]]
      parse("${first}{second}").should eq(expected)
    end
    
    it 'is idempotent' do
      parse(parse(hello_tpl)).should eq(expected)
    end
    
    it 'supports a path-like object' do
      parse(hello_path).should eq(expected)
    end
    
    it 'supports an IO object' do
      hello_io{|io| parse(io)}.should eq(expected)
    end
    
    it 'recognizes objects that respond to :to_path' do
      s = Struct.new(:to_path).new(hello_path)
      parse(s).should eq(expected)
    end
    
    it 'recognizes objects that respond to :to_str' do
      s = Struct.new(:to_str).new(hello_tpl)
      parse(s).should eq(expected)
    end
    
  end
end