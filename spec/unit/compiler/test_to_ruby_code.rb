require 'spec_helper'
module WLang
  class Compiler
    describe ToRubyCode do

      def generate(source)
        ToRubyCode.new.call(source)
      end

      it 'compiles [:proc, ...]' do
        source   = [:proc, [:static, "Hello world"]]
        expected = %q{lambda{|d1,b1| b1 << ("Hello world") }}
        generate(source).should eq(expected)
      end

      it 'compiles [:dispatch, ...]' do
        source   = [:dispatch, :_dtag_36, [:proc, [:static, "Hello world"]]]
        expected = %q{d0._dtag_36(b0, [lambda{|d1,b1| b1 << ("Hello world") }])}
        generate(source).should eq(expected)
      end

    end # describe ToRubyCode
  end # class Compiler
end # module WLang
