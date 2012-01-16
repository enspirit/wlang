require File.expand_path('../spec_helper', __FILE__)
describe WLang do

  it "should have a version number" do
    WLang.const_defined?(:VERSION).should be_true
  end

end
