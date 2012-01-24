module WLang
  class Dialect
    describe Evaluation, "evaluate_through_eval" do
      include Evaluation

      let(:struct){ Struct.new(:who) }
      def ev(scope, what)
        evaluate_through_eval(scope, what)
      end

      context 'with a Binding' do
        it 'works if found' do
          who = "World"
          ev(binding, :who).should eq("World")
          ev(binding, "who").should eq("World")
        end
        it 'does not raise error when not found' do
          lambda{ ev(binding, :who)  }.should throw_symbol(:fail)
          lambda{ ev(binding, "who") }.should throw_symbol(:fail)
        end
      end

      context 'with a Struct' do
        it 'works if found' do
          s = struct.new("World")
          ev(s, :who).should eq("World")
          ev(s, "who").should eq("World")
        end
        it 'does not raise error when not found' do
          lambda{ ev(self, :who)  }.should throw_symbol(:fail)
          lambda{ ev(self, "who") }.should throw_symbol(:fail)
        end
      end

      it 'allows literals' do
        ev(self, "1..10").should eq(1..10)
      end

      it 'allows complex expressions' do
        h = struct.new("World")
        ev(binding, "h.who").should eq("World")
      end

    end # describe Evaluation, "evaluate_through_eval"
  end # class Dialect
end # module WLang