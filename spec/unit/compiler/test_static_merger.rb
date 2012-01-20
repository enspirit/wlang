require 'spec_helper'
module WLang
  class Compiler
    describe StaticMerger do

      def optimize(source)
        StaticMerger.new.call(source)
      end

      let(:trailing){[
        [:multi, [:static, "{"], [:static, "Hello world"], [:static, "}"]],
        [:multi, [:static, "{Hello world}"]]
      ]}

      it 'optimize result of trailing blocks' do
        optimize(trailing.first).should eq(trailing.last)
      end

      [:template, :modulo, :dispatch, :proc].each do |kind|

        it "recurses on :#{kind}" do
          optimize([kind, trailing.first]).should eq([kind, trailing.last])
        end

      end

    end # describe StaticMerger
  end # class Compiler
end # module WLang
