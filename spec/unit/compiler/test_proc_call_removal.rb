require 'spec_helper'
module WLang
  class Compiler
    describe ProcCallRemoval do

      def optimize(source)
        ProcCallRemoval.new.call(source)
      end

      it 'optimizes :fn' do
        source   = [:fn, [:static, "Hello world"]]
        expected = [:arg, "Hello world"]
        optimize(source).should eq(expected)
      end

      it 'recurses on :wlang' do
        source   = [:wlang, '$', [:fn, [:static, "Hello world"]]]
        expected = [:wlang, '$', [:arg, "Hello world"]]
        optimize(source).should eq(expected)
      end

    end # describe ToRubyCode
  end # class Compiler
end # module WLang
