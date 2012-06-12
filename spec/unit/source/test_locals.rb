require 'spec_helper'
module WLang
  describe Source, 'locals' do

    subject{ Source.new("Hello world").locals }

    it 'is empty by default' do
      subject.should eq({})
    end

  end
end