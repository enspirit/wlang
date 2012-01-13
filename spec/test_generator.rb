require 'spec_helper'
module WLang
  describe Generator do
    
    let(:generator){ WLang::Generator.new }
    
    subject{ generator.call(source) }

    describe '[:proc, ...]' do
      let(:source)  { [:proc, [:static, "Hello world"]] }
      let(:expected){ %q{lambda{|buf| buf << ("Hello world") }} }
      it{ should eq(expected) }
    end
    
  end
end