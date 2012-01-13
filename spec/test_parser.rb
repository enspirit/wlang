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
    
  end
end