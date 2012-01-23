require 'spec_helper'
module WLang
  class Compiler
    describe StrconcatFlattener do

      def optimize(source)
        StrconcatFlattener.new.call(source)
      end
      
      it 'cleans singleton' do
        source   = [:strconcat, [:static, "Hello World!"]]
        expected = [:static, "Hello World!"]
        optimize(source).should eq(expected)
      end
      
      it 'does nothing on single :strconcat' do
        source   = [:strconcat, [:static, "Hello "], [:static, "World"]]
        expected = [:strconcat, [:static, "Hello "], [:static, "World"]]
        optimize(source).should eq(expected)
      end
      
      it 'flattens :strconcat' do
        source   = [:strconcat, [:strconcat, [:static, "Hello "], [:static, "World"]], [:static, "!"]]
        expected = [:strconcat, [:static, "Hello "], [:static, "World"], [:static, "!"]]
        optimize(source).should eq(expected)
      end

    end # describe StrconcatFlattener
  end # class Compiler
end # module WLang
