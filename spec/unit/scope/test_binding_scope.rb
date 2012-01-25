require 'spec_helper'
module WLang
  class Scope
    describe BindingScope do

      it 'implements fetch through eval' do
        who = "World"
        scope = Scope.coerce(binding)
        scope.fetch(:who).should eq("World")
      end

      it 'delegates fetch to its parent when not found' do
        scope = Scope.coerce(binding, Scope.coerce(:who => "World"))
        scope.fetch(:who).should eq("World")
      end

      it 'fetches `self` correctly' do
        o = Object.new
        x = o.instance_eval do
          Scope.coerce(binding).fetch(:self)
        end
        x.should eq(o)
      end

    end # describe BindingScope
  end # class Scope
end # module WLang
