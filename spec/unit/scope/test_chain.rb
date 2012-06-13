module WLang
  describe Scope, '.chain' do

    it 'returns the NullScope on empty chain' do
      Scope.chain([]).should eq(Scope.null)
    end

    it 'returns a single scope on singleton' do
      s = Scope.chain([{:who => "World"}])
      s.should be_a(Scope::ObjectScope)
      s.parent.should be_nil
    end

    it 'uses the last scope as most specific' do
      s = Scope.chain([{:who => "World"}, lambda{}])
      s.should be_a(Scope::ProcScope)
      s.parent.should be_a(Scope::ObjectScope)
      s.parent.parent.should be_nil
    end

    it 'strips nils' do
      s = Scope.chain([nil, {:who => "World"}, nil, lambda{}, nil])
      s.should be_a(Scope::ProcScope)
      s.parent.should be_a(Scope::ObjectScope)
      s.parent.parent.should be_nil
    end

  end
end