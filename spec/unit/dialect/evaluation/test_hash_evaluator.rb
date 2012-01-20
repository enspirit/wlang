module WLang
  class Dialect
    module Evaluation
      describe "hash_evaluator" do

        def ev(scope, what)
          Strategies.hash_evaluator.call(scope, what)
        end

        it 'works with exact symbol match' do
          ev({:who => "World"}, :who).should eq([true, "World"])
        end

        it 'works with exact string match' do
          ev({"who" => "World"}, "who").should eq([true, "World"])
        end

        it 'works with to_sym match' do
          ev({:who => "World"}, "who").should eq([true, "World"])
        end
        
        it 'supports hash-like objects' do
          h = Object.new.tap{|o|
            def o.has_key?(k) true; end
            def o.[](k) "World"; end
          }
          ev(h, "who").should eq([true, "World"])
        end

        it 'return nil when not a Hash' do
          ev(nil, "who").should be_nil
          ev(self, "who").should be_nil
        end

        it 'return nil on unfound' do
          ev({}, "who").should be_nil
          ev({:whoelse => "War"}, "who").should be_nil
        end

      end
    end # module Evaluation
  end # class Dialect
end # module WLang