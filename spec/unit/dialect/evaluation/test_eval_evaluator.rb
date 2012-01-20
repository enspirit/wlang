module WLang
  class Dialect
    module Evaluation
      describe "eval_evaluator" do

        let(:struct){ Struct.new(:who) }
        def ev(scope, what)
          Strategies.eval_evaluator.call(scope, what)
        end

        context 'with a Binding' do
          it 'works if found' do
            who = "World"
            ev(binding, :who).should eq([true, "World"])
            ev(binding, "who").should eq([true, "World"])
          end
          it 'does not raise error when not found' do
            ev(binding, :who).should be_nil
            ev(binding, "who").should be_nil
          end
        end

        context 'with a Struct' do
          it 'works if found' do
            s = struct.new("World")
            ev(s, :who).should eq([true, "World"])
            ev(s, "who").should eq([true, "World"])
          end
          it 'does not raise error when not found' do
            ev(self, :who).should be_nil
            ev(self, "who").should be_nil
          end
        end

        it 'allows literals' do
          ev(self, "1..10").should eq([true, 1..10])
        end

        it 'allows complex expressions' do
          h = struct.new("World")
          ev(binding, "h.who").should eq([true, "World"])
        end

      end
    end # module Evaluation
  end # class Dialect
end # module WLang