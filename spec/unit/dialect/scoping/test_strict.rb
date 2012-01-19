module WLang
  class Dialect
    module Scoping
      describe Strict do
        include Strict

        it "implements with_scope accurately" do
          with_scope(1) do
            with_scope(2) do
              scope.should eq(2)
            end
            scope.should eq(1)
          end
        end

        it 'has only one scope at a time' do
          each_scope.to_a.should eq([])
          with_scope(1) do
            each_scope.to_a.should eq([1])
            with_scope(2) do
              each_scope.to_a.should eq([2])
            end
          end
        end

      end
    end # module Scoping
  end # class Dialect
end # module WLang