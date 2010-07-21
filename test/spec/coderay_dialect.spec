require "wlang"
describe("WLang should support coderay encoder") do
  
  it("should support basic coderay encoding") {
    WLang::encode("<h1>This is a title</h1>", "xhtml/coderay/html").should_not be_nil
  }
  
end