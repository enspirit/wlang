require 'spec_helper'
module WLang
  describe Scope, ".coerce" do

    it 'recognizes Binding' do
      Scope.coerce(binding).should be_a(Scope::BindingScope)
    end

    it 'recognizes Procs' do
      Scope.coerce(lambda{}).should be_a(Scope::ProcScope)
    end

    it 'falls back to ObjectScope on Hash' do
      Scope.coerce({}).should be_a(Scope::ObjectScope)
    end

    it 'falls back to ObjectScope' do
      Scope.coerce(12).should be_a(Scope::ObjectScope)
    end

    it 'returns the Scope if nothing has to be done' do
      Scope.coerce(Scope.root).should eq(Scope.root)
      s = Scope.coerce({})
      Scope.coerce(s).should eq(s)
    end

    it 'builds ProxyScope on Scopes' do
      s = Scope.coerce({})
      Scope.coerce(s, Scope.root).should be_a(Scope::ProxyScope)
    end

  end # describe Scope
end # module WLang
