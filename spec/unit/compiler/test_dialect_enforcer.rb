require 'spec_helper'
module WLang
  class Compiler
    describe DialectEnforcer do

      let(:dialect){
        WLang::dialect{ tag('$') do |buf,fn| instantiate(fn, buf).upcase end }.factor
      }

      def optimize(source)
        DialectEnforcer.new(:dialect => dialect).call(source)
      end

      let(:hello_fn){[
        [:fn, [:static, "hello"]],
        [:fn, [:static, "hello"]]
      ]}
      let(:unknown){[
        [:wlang, '!', [:fn, [:static, "hello"]]],
        [:strconcat, [:static, "!"], [:static, "{"], [:static, "hello"], [:static, "}"]]
      ]}
      let(:hello_dollar){[
        [:wlang, '$', hello_fn.first],
        [:wlang, '$', hello_fn.last]
      ]}

      it 'recurses on template' do
        source   = [:template, hello_dollar.first]
        expected = [:template, hello_dollar.last]
        optimize(source).should eq(expected)
      end

      it 'leaves [:static, ...] unchanged' do
        source = [:static, "Hello world"]
        optimize(source).should eq(source)
      end

      it 'leaves [:strconcat, ...] unchanged if no tag' do
        source = [:strconcat, [:static, "Hello "], [:static, "world"]]
        optimize(source).should eq(source)
      end

      it 'recurses on [:strconcat, ...] to optimize further' do
        source   = [:strconcat, unknown.first]
        expected = [:strconcat, unknown.last]
        optimize(source).should eq(expected)
      end

      it 'optimizes on exact symbols' do
        optimize(hello_dollar.first).should eq(hello_dollar.last)
      end

      it 'detects extract symbols' do
        source   = [:wlang, '!$', hello_fn.first]
        expected = [:strconcat, [:static, "!"], hello_dollar.last]
        optimize(source).should eq(expected)
      end

      it 'recognizes unknown tags' do
        optimize(unknown.first).should eq(unknown.last)
      end

      it 'recognizes unknown tags even if enclosed' do
        source   = [:wlang, '$', [:fn, unknown.first]]
        expected = [:wlang, '$', [:fn, unknown.last]]
        optimize(source).should eq(expected)
      end

      it 'applies dynamic dispatching on high-order wlang' do
        source   = [:wlang, '$', [:fn, hello_dollar.first]]
        expected = [:wlang, '$', [:fn, hello_dollar.last]]
        optimize(source).should eq(expected)
      end

      it 'detects extra blocks' do
        source   = [:wlang, '$', hello_fn.first, hello_fn.first]
        expected = \
          [:strconcat,
            [:wlang, '$', hello_fn.last],
            [:static, '{'],
            hello_fn.last.last,
            [:static, '}']
          ] 
        pending{
          optimize(source).should eq(expected)
        }
      end

    end # describe DialectEnforcer
  end # class Compiler
end # module WLang
