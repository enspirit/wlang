require 'spec_helper'
module WLang
  describe Parser do
    
    let(:parser){ WLang::Parser.new }

    it 'should parse "Hello ${world}!" as expected' do
      expected = \
        [:concat,
          [:static, "Hello "],
          [:wlang,  "$",
            [:fn, 
              [:static, "world"]
            ]
          ],
          [:static, "!"]
        ]
      parser.call("Hello ${world}!").should eq(expected)
    end
    
    it 'should support high-order wlang' do
      expected = \
        [:wlang,  "$",
          [:fn, [:wlang, "$", [:fn, [:static, "who"]]]]
        ]
      parser.call("${${who}}").should eq(expected)
    end
    
    it 'should support mutli-block functions' do
      expected = \
        [:wlang,  "$",
          [:fn, [:static, "first" ]],
          [:fn, [:static, "second"]],
        ]
      parser.call("${first}{second}").should eq(expected)
    end
    
  end
end