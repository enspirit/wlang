require 'spec_helper'
module WLang
  class Dialect
    describe Evaluation, "evaluate" do
      include Evaluation
      include Scoping::Strict

      let(:struct){ Struct.new(:who) }

      it 'works with a hash' do
        with_scope({:who => "World"}) do
          evaluate("who").should eq("World")
          evaluate(:who).should eq("World")
        end
      end

      it 'works with a struct' do
        with_scope(struct.new("World")) do
          evaluate("who").should eq("World")
          evaluate(:who).should eq("World")
        end
      end

      it 'uses the hash in priority' do
        with_scope({:keys => [1,2,3]}) do
          evaluate("keys").should eq([1,2,3])
        end
      end

      it 'falls back to send' do
        with_scope({:who => "World"}) do
          evaluate("keys").should eq([:who])
        end
      end

      it 'raises a NameError when not found' do
        lambda{ evaluate("who") }.should raise_error(NameError)
      end

    end # describe Evaluation, "evaluate"
  end # class Dialect
end # module WLang