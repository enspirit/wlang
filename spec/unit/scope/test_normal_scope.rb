require 'spec_helper'
module WLang
  class Scope
    describe NormalScope do

      it 'fetches correctly on a Hash' do
        Scope.normal(:who => "World").fetch(:who).should eq("World")
      end

      it 'fetches correctly on a Object' do
        subj = Struct.new(:who).new("World")
        Scope.normal(subj).fetch(:who).should eq("World")
      end

      it 'delegates to its parent when not found' do
        parent = Scope.normal(:who => "World")
        Scope.normal(Scope.root, parent).fetch(:who).should eq("World")
      end

      it 'fetches `self` correctly' do
        Scope.normal(12).fetch(:self).should eq(12)
      end

    end # describe NormalScope
  end # class Scope
end # module WLang
