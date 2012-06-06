require 'spec_helper'
module WLang
  describe Dialect, 'tag_dispatching_name' do

    def tag_dispatching_name(symbol)
      Dialect.tag_dispatching_name(symbol)
    end

    it "works with a single char" do
      tag_dispatching_name("$").should eq(:_tag_36)
    end

    it "works with a multiple chars" do
      tag_dispatching_name("!$").should eq(:_tag_33_36)
    end

    it "works with an array" do
      tag_dispatching_name(['!', '$']).should eq(:_tag_33_36)
    end

  end # describe Dialect
end # module WLang
