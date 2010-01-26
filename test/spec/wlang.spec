require 'wlang'
describe ::WLang do
  
  it("should allow easy use of encoders") {
    WLang::encode('&', 'xhtml/entities-encoding').should == '&amp;'
    WLang::encode("O'Neil", 'ruby/single-quoting').should == "O\\'Neil"
    WLang::encode('O"Neil', 'ruby/double-quoting').should == 'O\\"Neil'
  }
  
end
