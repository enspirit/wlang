require 'spec_helper'
module WLang
  class Dialect
    describe Scope do
      
      it 'behaves like a stack' do
        s = Scope.new(0)
        s = s.push(1)
        s.should be_a(Scope)
        s.to_a.should eq([1, 0])
        s = s.pop
        s.should be_a(Scope)
        s.to_a.should eq([0])
      end

    end # describe Scope
  end # class Dialect
end # module WLang