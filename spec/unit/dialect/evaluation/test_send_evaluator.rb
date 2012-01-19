module WLang
  class Dialect
    module Evaluation
      describe "send_evaluator" do

        let(:struct){ Struct.new(:who) }
        def ev(scope, what)
          Strategies.send_evaluator.call(scope, what)
        end

        it 'works with exact symbol match' do
          ev(struct.new("World"), :who).should eq([true, "World"])
        end

        it 'works with to_sym match' do
          ev(struct.new("World"), "who").should eq([true, "World"])
        end

        it 'return nil when the object does not respond_to? key' do
          ev(nil, "who").should be_nil
          ev(self, "who").should be_nil
        end

      end
    end # module Evaluation
  end # class Dialect
end # module WLang