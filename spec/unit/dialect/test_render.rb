require 'spec_helper'
module WLang
  describe Dialect, "render" do

    U = Upcasing
    let(:expected){ "Hello WHO!" }

    it 'works as expected' do
      U.render(hello_tpl).should eq(expected)
    end

    it 'do not eat extra blocks' do
      U.render("Hello ${who}{world}").should eq("Hello WHO{world}")
    end

    it "accepts an optional scope" do
      U.render(hello_tpl, {}).should eq(expected)
    end

    it "accepts multiple scope objects" do
      U.render(hello_tpl, 12, {}).should eq(expected)
    end

    it 'accepts a :to_path object' do
      U.render(hello_path).should eq(expected)
    end

    it 'accepts an IO instance' do
      hello_io{|io| U.render(io)}.should eq(expected)
    end

    it 'supports specifying the buffer' do
      U.render(hello_tpl, {}, []).should eq(["Hello ", "WHO", "!"])
    end

  end # describe Dialect
end # module WLang
