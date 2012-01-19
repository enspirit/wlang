require 'spec_helper'
module WLang
  describe Dialect, "dispatch" do

    let(:foo){ Foo.new }
    let(:bar){ Bar.new }

    it 'dispatches correctly on a class' do
      foo.dispatch("!", "").should eq("(foo#execution )")
      foo.dispatch("$", "").should eq("(foo#escaping )")
      foo.dispatch("@", "").should eq('(foo#link )')
      foo.dispatch("<", "").should eq('(foo#less )')
    end

    it 'dispatches correctly on a subclass' do
      bar.dispatch("!", "").should eq("(foo#execution )")
      bar.dispatch("$", "").should eq("(bar#escaping )")
      bar.dispatch("@", "").should eq('(foo#link )')
      bar.dispatch("<", "").should eq('(bar#less )')
    end

    it 'dispatches correctly on extra symbols' do
      foo.dispatch("!!", "").should eq('!(foo#execution )')
    end

    it 'dispatches correctly on unknown symbols' do
      foo.dispatch("_", "", lambda{|d,buf| d.should eq(foo); buf << "foo"}).should eq('_{foo}')
      bar.dispatch("_", "", lambda{|d,buf| d.should eq(bar); buf << "bar"}).should eq('_{bar}')
    end

    it 'does not let superclasses inherit from subclasses' do
      foo.dispatch('>', "").should eq('>')
      bar.dispatch('>', "").should eq('(bar#greater )')
    end

  end # describe Dialect
end # module WLang
