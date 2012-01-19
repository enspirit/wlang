require 'spec_helper'
module WLang
  describe Upcasing do

  def upcasing(tpl, scope = {})
    Upcasing.render(tpl, scope)
  end

  it 'upcases the string under $' do
    upcasing("Hello ${world}!").should eq("Hello WORLD!")
  end

  it 'evaluates the string under #' do
    upcasing('Hello #{who}!', :who => "World").should eq("Hello World!")
  end

  it 'raises when not found' do
    lambda{ upcasing('Hello #{who}!') }.should raise_error(NameError)
  end

  end # describe Dummy
end # module WLang
