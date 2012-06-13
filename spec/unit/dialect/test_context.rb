require 'spec_helper'
module WLang
  describe Dialect, 'context' do

    let(:dialect){ Dialect.new }

    subject{ dialect.context }

    it 'defaults to nil if no scope' do
      subject.should be_nil
    end

    it "is the scope's subject when one scope" do
      dialect.with_scope(:x) do
        subject.should eq(:x)
      end
    end

    it "is the root scope's subject when multiple scope" do
      dialect.with_scope(:x) do
        dialect.with_scope(:y) do
          subject.should eq(:x)
        end
      end
    end

  end
end