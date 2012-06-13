require 'spec_helper'
module WLang
  class Scope
    describe NullScope do

      let(:scope){ NullScope.new }

      it 'throws on fetch' do
        lambda{ scope.fetch(:who) }.should throw_symbol(:fail)
      end

      it 'throws on fetch even on `self`' do
        lambda{ scope.fetch(:self) }.should throw_symbol(:fail)
      end

      it 'returns pushed scope on push' do
        pushed = ObjectScope.new(12, nil)
        scope.push(pushed).should eq(pushed)
      end

      it 'coerces pushed scope on push' do
        scope.push(12).should be_a(ObjectScope)
      end

      it 'returns nil on pop' do
        scope.pop.should be_nil
      end

    end # describe NullScope
  end # class Scope
end # module WLang
