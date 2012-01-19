require 'spec_helper'
module WLang
  class Dialect
    module Evaluation
      describe "evaluate" do
        include Scoping::Strict

        let(:struct){ Struct.new(:who) }

        context 'without evaluator' do
          include Evaluation

          it 'has an empty evaluation chain' do
            evaluation_chain.should be_empty
          end

          it 'raises a NameError by default' do
            lambda{ evaluate("who") }.should raise_error(NameError)
          end
        end

        context 'with a hash evaluator' do
          include Evaluation
          evaluator :hash

          it 'has a singleton evaluation chain' do
            evaluation_chain.size.should eq(1)
          end

          it 'returns the value when found' do
            with_scope({:who => "World"}) do
              evaluate("who").should eq("World")
              evaluate(:who).should eq("World")
            end
          end

          it 'raises a NameError when not found' do
            lambda{ evaluate("who") }.should raise_error(NameError)
          end
        end

        context 'with a send evaluator' do
          include Evaluation
          evaluator :send

          it 'has a singleton evaluation chain' do
            evaluation_chain.size.should eq(1)
          end

          it 'returns the value when found' do
            with_scope(struct.new("World")) do
              evaluate("who").should eq("World")
              evaluate(:who).should eq("World")
            end
          end

          it 'raises a NameError when not found' do
            lambda{ evaluate("who") }.should raise_error(NameError)
          end
        end

        context 'with a chain' do
          include Evaluation
          evaluator :hash, :send

          it 'has a singleton evaluation chain' do
            evaluation_chain.size.should eq(2)
          end

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
        end

      end
    end # module Evaluation
  end # class Dialect
end # module WLang