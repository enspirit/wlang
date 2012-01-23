require 'spec_helper'
module WLang
  class Compiler
    describe Autospacing::Unindent do

      def optimize(source)
        Autospacing::Unindent.new.call(source)
      end

      it 'unindents :static' do
        source   = [:static, "  Hello World"]
        expected = [:static, "Hello World"]
        optimize(source).should eq(expected)
      end

      it 'unindents :static when multiple lines' do
        source   = [:static, "  Hello\n  World"]
        expected = [:static, "Hello\nWorld"]
        optimize(source).should eq(expected)
      end

      it 'recurses on :strconcat' do
        source   = [:strconcat, [:static, "  Hello"], [:static, "  World"]]
        expected = [:strconcat, [:static, "Hello"], [:static, "World"]]
        optimize(source).should eq(expected)
      end

    end # describe Autospacing::Unindent
  end # class Compiler
end # module WLang
