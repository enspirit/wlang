require 'spec_helper'
module WLang
  class Scope
    describe RootScope do

      let(:scope){ RootScope.new }

      it 'throws on fetch' do
        lambda{ scope.fetch(:who) }.should throw_symbol(:fail)
      end

      it 'throws on fetch even on `self`' do
        lambda{ scope.fetch(:self) }.should throw_symbol(:fail)
      end

      it 'raises on pop' do
        lambda{ scope.pop }.should raise_error
      end

    end # describe ProxyScope
  end # class Scope
end # module WLang
