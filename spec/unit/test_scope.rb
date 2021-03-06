require 'spec_helper'
module WLang
  describe Scope do

    let(:scope){ Scope.coerce({:who => "World"}) }

    it 'acts like a stack' do
      s = scope
      s.evaluate(:who, nil).should eq("World")
      s = scope.push(:who => "World2")
      s.evaluate(:who, nil).should eq("World2")
      s = s.pop
      s.evaluate(:who, nil).should eq("World")
    end

    it 'has a `with` helper' do
      scope.with(:who => "World2") do |s|
        s.evaluate(:who, nil).should eq("World2")
      end
      scope.evaluate(:who, nil).should eq("World")
    end

    it 'allows pushing scopes' do
      scope.with Scope.coerce(:other => "World2") do |s|
        s.evaluate(:other, nil).should eq("World2")
        s.evaluate(:who, nil).should eq("World")
      end
    end

    it 'gives access to the root' do
      scope.root.should eq(scope)
      scope.with(:other => "World2") do |s|
        s.root.should eq(scope)
      end
    end

    it 'evaluates `self` accurately' do
      scope.evaluate(:self, nil).should eq(:who => "World")
    end

    it 'evaluates dot expressions correctly' do
      scope.evaluate("who.upcase", nil).should eq("WORLD")
    end

    it 'strips strings before evaluation' do
      scope.evaluate("  who  ", nil).should eq("World")
      scope.evaluate(" who.upcase ", nil).should eq("WORLD")
    end

    it 'fails when not found' do
      lambda{
        scope.evaluate(:nosuchone, nil)
      }.should throw_symbol(:fail)
    end

    it 'supports a default value instead of fail' do
      scope.evaluate(:nosuchone, nil, 12).should eq(12)
      scope.evaluate(:nosuchone, nil, nil).should be_nil
    end

    it 'supports a default value through a block instead of fail' do
      scope.evaluate(:nosuchone, nil){ 12 }.should eq(12)
      scope.evaluate(:nosuchone, nil){ nil }.should be_nil
    end

  end # describe Scope
end # module WLang
