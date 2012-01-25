require 'spec_helper'
module WLang
  class Scope
    describe ProxyScope do

      it 'delegates fetch to its subject' do
        proxy = Scope.proxy(Scope.normal(:who => "World"))
        proxy.fetch(:who).should eq("World")
      end
      
      it 'delegates fetch to its parent when not found' do
        proxy  = Scope.proxy(Scope.root, Scope.normal(:who => "World"))
        proxy.fetch(:who).should eq("World")
      end

      it 'fetches `self` correctly' do
        Scope.proxy(Scope.normal(12)).fetch(:self).should eq(12)
      end

    end # describe ProxyScope
  end # class Scope
end # module WLang
