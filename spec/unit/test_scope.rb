require 'spec_helper'
module WLang
  describe Scope do

    it 'should act like a stack' do
      s = Scope::RootScope.new
      s = s.push(:who => "World")
      s.evaluate(:who).should eq("World")
    end

  end # describe Scope
end # module WLang
