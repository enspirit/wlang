module WLang
  class Dialect
    describe Evaluation, "evaluate_through_hash" do
      include Evaluation

      def ev(scope, what)
        evaluate_through_hash(scope, what)
      end

      it 'works with exact symbol match' do
        ev({:who => "World"}, :who).should eq("World")
      end

      it 'works with exact string match' do
        ev({"who" => "World"}, "who").should eq("World")
      end

      it 'works with to_sym match' do
        ev({:who => "World"}, "who").should eq("World")
      end

      it 'supports hash-like objects' do
        h = Object.new.tap{|o|
          def o.has_key?(k) true; end
          def o.[](k) "World"; end
        }
        ev(h, "who").should eq("World")
      end

      it 'throws :fail when not a Hash' do
        lambda{ ev(nil,  "who") }.should throw_symbol(:fail)
        lambda{ ev(self, "who") }.should throw_symbol(:fail)
      end

      it 'throws :fail when not found' do
        lambda{ ev({},  "who") }.should throw_symbol(:fail)
        lambda{ ev({:whoelse => "War"},  "who") }.should throw_symbol(:fail)
      end

    end # describe Evaluation, "evaluate_through_hash"
  end # class Dialect
end # module WLang