require 'spec_helper'
module WLang
  describe Dialect, ".compile" do
    
    let(:expected_source){%q{
      lambda{|d1,b1| b1 << ("Hello "); d1.dispatch("$", b1, lambda{|d2,b2| b2 << ("who") }); b1 << ("!") }
    }.strip}
    
    def compile(s, options = nil)
      options.nil? ? Upcasing.compile(s) : Upcasing.compile(s, options)
    end
    
    context 'without options' do
      it 'returns a Template' do
        compile(hello_tpl).should be_a(Template)
      end
      it 'supports a path-like as input' do
        compile(hello_path).should be_a(Template)
      end
      it 'supports an IO object as input' do
        hello_io do |f|
          compile(f).should be_a(Template)
        end
      end
      specify 'returned template is instantiabler' do
        compile(hello_tpl).call.should eq("Hello WHO!")
      end
    end
    
    it 'returns the source when options is :source' do
      compile(hello_tpl, :source).should eq(expected_source)
    end
    
    it 'returns a proc when options is :proc' do
      compile(hello_tpl, :proc).should be_a(Proc)
    end
    
    it 'should raise an ArgumentError if options is not recognized' do
      lambda{ compile(hello_tpl, :none) }.should raise_error(ArgumentError)
    end
    
  end # describe Dialect
end # module WLang
