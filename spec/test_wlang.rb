require File.expand_path('../spec_helper', __FILE__)
describe WLang do
  
  it "should have a version number" do
    WLang.const_defined?(:VERSION).should be_true
  end
  
  it 'dialect' do
    d = WLang::dialect do
      tag('$') do |buf, fn| buf << evaluate(fn) end
    end
    d.instantiate("Hello ${who}!", :who => "world").should eq("Hello world!")
  end
  
end
