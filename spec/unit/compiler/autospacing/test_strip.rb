require 'spec_helper'
module WLang
  class Compiler
    describe Autospacing::Strip do

      def optimize(source, left)
        Autospacing::Strip.new(:left => left).call(source)
      end

      context "on left" do

        it 'does not touch single line statics' do
          source   = [:static, "Hello World"]
          expected = [:static, "Hello World"]
          optimize(source, true).should eq(expected)
        end

        it 'strips :static' do
          source   = [:static, "\n  Hello World"]
          expected = [:static, "  Hello World"]
          optimize(source, true).should eq(expected)
        end

        it 'supports trailing spaces before \n' do
          source   = [:static, "    \n  Hello World"]
          expected = [:static, "  Hello World"]
          optimize(source, true).should eq(expected)
        end

        it 'strips the first :static of a :strconcat' do
          source   = [:strconcat, [:static, "\n  Hello\n"], [:static, "  World\n"]]
          expected = [:strconcat, [:static, "  Hello\n"], [:static, "  World\n"]]
          optimize(source, true).should eq(expected)
        end

      end # on left

      context "on right" do

        it 'does not touch single line statics' do
          source   = [:static, "Hello World"]
          expected = [:static, "Hello World"]
          optimize(source, false).should eq(expected)
        end

        it 'strips :static' do
          source   = [:static, "  Hello World\n  "]
          expected = [:static, "  Hello World"]
          optimize(source, false).should eq(expected)
        end

        it 'supports trailing spaces after \n' do
          source   = [:static, "  Hello World\n  "]
          expected = [:static, "  Hello World"]
          optimize(source, false).should eq(expected)
        end

        it 'strips the last :static of a :strconcat' do
          source   = [:strconcat, [:static, "\n  Hello\n"], [:static, "  World\n  "]]
          expected = [:strconcat, [:static, "\n  Hello\n"], [:static, "  World"]]
          optimize(source, false).should eq(expected)
        end

      end # on left

    end # describe Autospacing::Strip
  end # class Compiler
end # module WLang
