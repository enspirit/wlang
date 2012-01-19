require 'spec_helper'
module WLang
  describe Dialect, ".compile" do
    
    def compile(s, options = nil)
      options.nil? ? Upcasing.compile(s) : Upcasing.compile(s, options)
    end
    
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
    
    it 'supports a no-op' do
      t = compile(hello_tpl)
      compile(t).should eq(t)
    end
    
    it 'supports a proc' do
      proc = compile(hello_tpl).inner_proc
      compile(proc).should be_a(Template)
    end
    
    specify 'returned template is instantiable' do
      compile(hello_tpl).call.should eq("Hello WHO!")
    end
    
    it 'returns a thread-safe template object' do
      t = WLang.dialect{ tag('$'){|buf,fn|
        raise if defined?(@somevar)
        @somevar = "World"
      } }.compile('${who}')
      2.times do 
        lambda{ t.call }.should_not raise_error
      end
    end
    
  end # describe Dialect
end # module WLang
