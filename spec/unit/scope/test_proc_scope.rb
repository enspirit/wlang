require 'spec_helper'
module WLang
  class Scope
    describe ProcScope do

      it 'implements fetch through call.xxx' do
        scope = Scope.coerce(lambda{ {:who => "World"} })
        scope.fetch(:who).should eq("World")
      end

      it 'delegates fetch to its parent when not found' do
        scope = Scope.coerce(lambda{ nil }, Scope.coerce({:who => "World"}))
        scope.fetch(:who).should eq("World")
      end

    end # describe ProcScope
  end # class Scope
end # module WLang
