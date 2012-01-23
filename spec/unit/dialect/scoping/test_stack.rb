module WLang
  class Dialect
    module Scoping
      describe Stack do
        include Stack

        it "implements with_scope accurately" do
          with_scope(1) do
            with_scope(2) do
              scope.should eq([1, 2])
            end
            scope.should eq([1])
          end
        end

        it 'uses scopes in the reverse order' do
          each_scope.to_a.should eq([])
          with_scope(1) do
            each_scope.to_a.should eq([1])
            with_scope(2) do
              each_scope.to_a.should eq([2, 1])
            end
          end
        end

        it 'yields scope when requested' do
          seen = []
          with_scope(1) do
            each_scope do |s| seen << s; end
          end
          seen.should eq([1])
        end

      end # describe Stack
    end # module Scoping
  end # class Dialect
end # module WLang