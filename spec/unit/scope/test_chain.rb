module WLang
  describe Scope, '.chain' do

    it 'returns Scope.root on empty chain' do
      Scope.chain([]).should eq(Scope.root)
    end

    it 'returns a single scope on singleton' do
      s = Scope.chain([{:who => "World"}])
      s.should be_a(Scope::ObjectScope)
      s.parent.should eq(Scope.root)
    end

    it 'uses the last scope as most specific' do
      s = Scope.chain([{:who => "World"}, lambda{}])
      s.should be_a(Scope::ProcScope)
      s.parent.should be_a(Scope::ObjectScope)
      s.parent.parent.should eq(Scope.root)
    end

    it 'strips nils' do
      s = Scope.chain([nil, {:who => "World"}, nil, lambda{}, nil])
      s.should be_a(Scope::ProcScope)
      s.parent.should be_a(Scope::ObjectScope)
      s.parent.parent.should eq(Scope.root)
    end

  end
end