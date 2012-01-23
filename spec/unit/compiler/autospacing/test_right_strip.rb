require 'spec_helper'
module WLang
  class Compiler
    describe Autospacing::RightStrip do

      def optimize(source)
        Autospacing::RightStrip.new.call(source)
      end

      it 'does not touch single line statics' do
        source   = [:static, "Hello World"]
        expected = [:static, "Hello World"]
        optimize(source).should eq(expected)
      end

      it 'strips at right on :static' do
        source   = [:static, "Hello World  \n  "]
        expected = [:static, "Hello World"]
        optimize(source).should eq(expected)
      end

      it 'strips the right-most :static on :strconcat' do
        source   = [:strconcat, [:static, "Hello  \n"], [:static, "  World\n"]]
        expected = [:strconcat, [:static, "Hello  \n"], [:static, "  World"]]
        optimize(source).should eq(expected)
      end

    end # describe Autospacing::RightStrip
  end # class Compiler
end # module WLang
