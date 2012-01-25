require 'spec_helper'
module WLang
  class Scope
    describe HashLikeScope do

      it 'implements fetch through []' do
        scope = Scope.coerce(:who => "World")
        scope.fetch(:who).should eq("World")
      end

      it 'supports any obj that responds to :has_key?' do
        subj = Object.new.tap{|x|
          def x.has_key?(k); true; end
          def x.[](k); "World"; end
        }
        scope = Scope.coerce(subj)
        scope.fetch(:who).should eq("World")
      end

      it 'delegates fetch to its parent when not found' do
        scope = Scope.coerce({}, Scope.coerce({:who => "World"}))
        scope.fetch(:who).should eq("World")
      end

      it 'fetches `self` correctly' do
        scope = Scope.coerce(:who => "World")
        scope.fetch(:self).should eq(:who => "World")
      end

    end # describe HashLikeScope
  end # class Scope
end # module WLang
