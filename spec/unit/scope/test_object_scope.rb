require 'spec_helper'
module WLang
  class Scope
    describe ObjectScope do

      it 'implements fetch through [] if a Hash' do
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

      it 'falls back to send' do
        subj = Struct.new(:who).new("World")
        scope = Scope.coerce(subj)
        scope.fetch(:who).should eq("World")
      end

      it 'delegates fetch to its parent when not found' do
        scope = Scope.coerce(12, Scope.coerce({:who => "World"}))
        scope.fetch(:who).should eq("World")
      end

      it 'fetches `self` correctly' do
        scope = Scope.coerce(12)
        scope.fetch(:self).should eq(12)
      end

    end # describe ObjectScope
  end # class Scope
end # module WLang
