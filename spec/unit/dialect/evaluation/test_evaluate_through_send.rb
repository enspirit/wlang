module WLang
  class Dialect
    describe Evaluation, "evaluate_through_send" do
      include Evaluation

      let(:struct){ Struct.new(:who) }
      def ev(scope, what)
        evaluate_through_send(scope, what)
      end

      it 'works with exact symbol match' do
        ev(struct.new("World"), :who).should eq("World")
      end

      it 'works with to_sym match' do
        ev(struct.new("World"), "who").should eq("World")
      end

      it 'throw :fail when scope does not respond_to? key' do
        lambda{ ev(nil, "who") }.should throw_symbol(:fail)
        lambda{ ev(self, "who") }.should throw_symbol(:fail)
      end

    end # describe Evaluation, "evaluate_through_send"
  end # class Dialect
end # module WLang