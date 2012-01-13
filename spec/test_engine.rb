require 'spec_helper'
module WLang
  describe Engine do
    
    let(:engine){ WLang::Engine.new }
    
    it 'should compile as expected' do
      compiled = engine.call("Hello ${world}!")
      compiled.should be_a(String)
      Kernel.eval(compiled).should be_a(Proc)
    end
    
  end
end