require 'spec_helper'
module WLang
  describe Engine do
    
    let(:engine){ WLang::Engine.new }
    
    it 'should compile as expected' do
      engine.call("Hello ${world}!").should eq("Hello ${world}!")
    end
    
  end
end