require 'spec_helper'
module WLang
  class Source
    describe Raw, "locals" do
      
      subject{ Raw.new("Hello world").locals }

      it 'returns an empty hash' do
        subject.should eq({})
      end

    end
  end
end