require 'spec_helper'
module WLang
  describe Scope, ".coerce" do

    it 'recognizes Binding' do
      Scope.coerce(binding).should be_a(Scope::BindingScope)
    end

    it 'recognizes Scopes' do
      Scope.coerce(Scope.root).should be_a(Scope::ProxyScope)
    end

    it 'falls back to ObjectScope on Hash' do
      Scope.coerce({}).should be_a(Scope::ObjectScope)
    end

    it 'falls back to ObjectScope' do
      Scope.coerce(12).should be_a(Scope::ObjectScope)
    end

  end # describe Scope
end # module WLang
