require "wlang"
describe("WLang should support redcloth encoder") do
  
  it("should support basic redcloth encoding") {
    expected = "<h1>This is a title</h1>"
    WLang::encode("h1. This is a title", "redcloth/xhtml").should == expected
  }
  
end