require "wlang"

describe "The wlang/xhtml dialect" do
  
  it("should provide helpers to create links") {
    "@{/details}".wlang({}, 'wlang/xhtml').should == "/details"
    "@{/details}{Details}".wlang({}, 'wlang/xhtml').should == '<a href="/details">Details</a>'
  }
  
  it("should provide to_xhtml_link callback on links") {
    ::String.module_eval do
      def to_xhtml_link(url, label) 
        "#{url}:#{label}"
      end
      def to_xhtml_href(url)
        "Hello:#{url}"
      end
    end
    "@{/details}{Details}".wlang({}, 'wlang/xhtml').should == '/details:Details'
    "@{/details}".wlang({}, 'wlang/xhtml').should == 'Hello:/details'
  }

end