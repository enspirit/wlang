require 'spec_helper'
module WLang
  describe Scope do

    let(:scope){ Scope.coerce({:who => "World"}) }

    it 'acts like a stack' do
      s = scope
      s.evaluate(:who).should eq("World")
      lambda{ s.pop.evaluate(:who) }.should throw_symbol(:fail)
      s = scope.push(:who => "World2")
      s.evaluate(:who).should eq("World2")
      s = s.pop
      s.evaluate(:who).should eq("World")
    end

    it 'has a `with` helper' do
      scope.with(:who => "World2") do |s|
        s.evaluate(:who).should eq("World2")
      end
      scope.evaluate(:who).should eq("World")
    end

    it 'allows pushing scopes' do
      scope.with Scope.coerce(:other => "World2") do |s|
        s.evaluate(:other).should eq("World2")
        s.evaluate(:who).should eq("World")
      end
    end

    it 'evaluates `self` accurately' do
      scope.evaluate(:self).should eq(:who => "World")
    end

    it 'evaluates dot expressions correctly' do
      scope.evaluate("who.upcase").should eq("WORLD")
    end

    it 'fails when not found' do
      lambda{ scope.evaluate(:nosuchone) }.should throw_symbol(:fail)
    end

    it 'supports a default value instead of fail' do
      scope.evaluate(:nosuchone, 12).should eq(12)
    end

    it 'supports nil as default value' do
      scope.evaluate(:nosuchone, nil).should be_nil
    end

  end # describe Scope
end # module WLang
