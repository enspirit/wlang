require 'spec_helper'
require 'wlang/mustang'
module WLang
  describe Mustang do

    describe "The Highlighter example" do

      class Highlighter < WLang::Dialect

        def highlight(buf, fn)
          var_name  = render(fn)
          var_value = evaluate(var_name)
          buf << var_value.to_s.upcase
        end

        tag '$', :highlight
      end

      it 'works as announced' do
        expected = "Hello YOU & THE WORLD!"
        got      = Highlighter.render "Hello ${who}!", who: "you & the world"
        got.should eq(expected)
      end

    end # Highlighter example

    describe "the HighLevel example" do

      class HighLevel < WLang::Dialect

        def join(buf, expr, main, between)
          evaluate(expr).each_with_index do |val,i|
            buf << render(between, val) unless i==0
            buf << render(main, val).strip
          end
        end

        def print(buf, fn)
          buf << evaluate(fn).to_s
        end

        tag '*', :join
        tag '$', :print
      end

      it 'works as announced' do
        expected = "Hello you and wlang and world !"
        template = 'Hello *{ ${collection} }{ ${self} }{ and } !'
        context  = {collection: 'whos', whos: [ "you", "wlang", "world" ] }
        got = HighLevel.render template, context
        got.should eq(expected)
      end
    end

  end
end
