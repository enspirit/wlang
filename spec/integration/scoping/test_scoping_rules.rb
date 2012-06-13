require 'spec_helper'
module WLang
  describe "WLang scoping rules" do

    let(:template){ Template.new(Path.dir / 'hello.wlang') }

    specify 'template locals are used by default' do
      template.render.should eq("Hello world!")
    end

    specify 'template locals are overriden by render locals' do
      template.render(:who => "wlang").should eq("Hello wlang!")
    end

  end
end