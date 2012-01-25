require 'spec_helper'
module WLang
  describe Scope, ".coerce" do

    it 'recognizes Binding' do
      Scope.coerce(binding).should be_a(Scope::BindingScope)
    end

    it 'recognizes Hashes' do
      Scope.coerce({}).should be_a(Scope::HashLikeScope)
    end

    it 'recognizes hash-like objects' do
      subj = Object.new.tap{|x|
        def x.has_key?(k); true; end
        def x.[](k); "World"; end
      }
      subj.should respond_to(:has_key?)
      Scope.coerce(subj).should be_a(Scope::HashLikeScope)
    end

    it 'recognizes Scopes' do
      Scope.coerce(Scope.root).should be_a(Scope::ProxyScope)
    end

    it 'falls back to ObjectScope' do
      Scope.coerce(12).should be_a(Scope::ObjectScope)
    end

  end # describe Scope
end # module WLang
