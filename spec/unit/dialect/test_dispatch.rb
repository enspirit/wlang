require 'spec_helper'
module WLang
  describe Dialect, "dispatch" do
    
    let(:foo){ Foo.new }
    let(:bar){ Bar.new }
    
    it 'dispatches correctly on a class' do
      foo.dispatch("!", nil).should eq("(foo#execution )")
      foo.dispatch("$", nil).should eq("(foo#escaping )")
      foo.dispatch("@", nil).should eq('(foo#link )')
      foo.dispatch("<", nil).should eq('(foo#less )')
    end

    it 'dispatches correctly on a subclass' do
      bar.dispatch("!", nil).should eq("(foo#execution )")
      bar.dispatch("$", nil).should eq("(bar#escaping )")
      bar.dispatch("@", nil).should eq('(foo#link )')
      bar.dispatch("<", nil).should eq('(bar#less )')
    end

    it 'dispatches correctly on unknown symbols' do
      foo.dispatch(">", lambda{|d,buf| d.should eq(foo); buf << "foo"}).should eq('>{foo}')
      bar.dispatch(">", lambda{|d,buf| d.should eq(bar); buf << "bar"}).should eq('>{bar}')
    end
    
  end # describe Dialect
end # module WLang
