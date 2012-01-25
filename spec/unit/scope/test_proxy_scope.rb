require 'spec_helper'
module WLang
  class Scope
    describe ProxyScope do

      let(:scope){ NormalScope.new(subject, RootScope.new) }
      let(:proxy){ ProxyScope.new(scope, RootScope.new)    }
      let(:subject){ {:who => "World"} }

      it 'delegates evaluation to its subject' do
        scope.evaluate('who').should eq("World")
        scope.evaluate('who.upcase').should eq("WORLD")
        lambda{ scope.evaluate('nosuchone') }.should throw_symbol(:fail)
        scope.frames.should eq([subject])
      end

    end # describe ProxyScope
  end # class Scope
end # module WLang
