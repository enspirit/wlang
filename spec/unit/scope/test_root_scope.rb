require 'spec_helper'
module WLang
  class Scope
    describe RootScope do

      let(:scope){ RootScope.new }

      it 'throws on evaluation' do
        lambda{ scope.evaluate('who') }.should throw_symbol(:fail)
      end

      it 'has empty frames' do
        scope.frames.should eq([])
      end

      it 'raises on pop' do
        lambda{ scope.pop }.should raise_error
      end

    end # describe ProxyScope
  end # class Scope
end # module WLang
