require 'spec_helper'
module WLang
  class Compiler
    class DialectEnforcer
      public :find_dispatching_method
    end
    describe DialectEnforcer do

      let(:dialect){
        WLang::dialect{
          tag('$')  do |buf,fn| buf << "$"  end
          tag('!$') do |buf,fn| buf << "!$" end
          tag('*')  do |buf,fn1,fn2|        end
          tag('%', [WLang::Dummy]) do |buf, fn| end
        }.factor
      }

      describe 'find_dispatching_method' do
        let(:e){ DialectEnforcer.new(:dialect => dialect) }
        it 'works on exact matching' do
          e.find_dispatching_method("$").should eq(['', :_tag_36])
        end
        it 'takes the most specific' do
          e.find_dispatching_method("$").should eq(['', :_tag_36])
          e.find_dispatching_method("!$").should eq(['', :_tag_33_36])
        end
        it 'recognizes extras' do
          e.find_dispatching_method("@$").should eq(['@', :_tag_36])
          e.find_dispatching_method("@!$").should eq(['@', :_tag_33_36])
        end
        it 'recognizes missings' do
          e.find_dispatching_method("#").should eq(['#', nil])
          e.find_dispatching_method("@#").should eq(['@#', nil])
        end
      end

      def optimize(source)
        DialectEnforcer.new(:dialect => dialect).call(source)
      end

      let(:unknown){[
        [:wlang, '!', [:fn, [:static, "hello"]]],
        [:strconcat, [:static, "!"], [:static, "{"], [:static, "hello"], [:static, "}"]]
      ]}
      let(:hello_fn){[
        [:fn, unknown.first],
        [:fn, unknown.last]
      ]}
      let(:hello_dollar){[
        [:wlang, '$', hello_fn.first],
        [:wlang, '$', hello_fn.last]
      ]}

      ### recursion rules

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

      ### exact symbols

      it 'optimizes on exact symbols' do
        optimize(hello_dollar.first).should eq(hello_dollar.last)
      end

      it 'detects extra symbols' do
        source   = [:wlang, '@$', hello_fn.first]
        expected = [:strconcat, [:static, "@"], hello_dollar.last]
        optimize(source).should eq(expected)
      end

      ### unknown tags

      it 'recognizes unknown tags' do
        optimize(unknown.first).should eq(unknown.last)
      end

      it 'recognizes unknown tags even if enclosed' do
        source   = [:wlang, '$', [:fn, unknown.first]]
        expected = [:wlang, '$', [:fn, unknown.last]]
        optimize(source).should eq(expected)
      end

      ### high-order wlang

      it 'applies dynamic dispatching on high-order wlang' do
        source   = [:wlang, '$', [:fn, hello_dollar.first]]
        expected = [:wlang, '$', [:fn, hello_dollar.last]]
        optimize(source).should eq(expected)
      end

      ### arity 2

      it 'supports tags of arity 2' do
        source   = [:wlang, '*', hello_fn.first, hello_fn.first]
        expected = [:wlang, '*', hello_fn.last, hello_fn.last]
        optimize(source).should eq(expected)
      end

      ### missing blocks

      it 'detects missing blocks on arity 1' do
        source   = [:wlang, '$']
        expected = [:wlang, '$', [:arg, nil]]
        optimize(source).should eq(expected)
      end

      it 'detects missing blocks on arity 2' do
        source   = [:wlang, '*', hello_fn.first]
        expected = [:wlang, '*', hello_fn.last, [:arg, nil]]
        optimize(source).should eq(expected)
      end

      ### trailing blocks

      it 'detects trailing blocks' do
        source   = [:wlang, '$', hello_fn.first, hello_fn.first]
        expected = \
          [:strconcat,
            [:wlang, '$', hello_fn.last],
            [:static, '{'],
            hello_fn.last.last,
            [:static, '}']
          ]
        optimize(source).should eq(expected)
      end

      it 'detects trailing blocks on arity 2' do
        source   = [:wlang, '*', hello_fn.first, hello_fn.first, hello_fn.first]
        expected = \
          [:strconcat,
            [:wlang, '*', hello_fn.last, hello_fn.last],
            [:static, '{'],
            hello_fn.last.last,
            [:static, '}']
          ]
        optimize(source).should eq(expected)
      end

      ### dialect switching

      it 'introduce dialect switching mechanism' do
        source   = [:wlang, '%', hello_fn.first]
        expected = [:wlang, '%', [:modulo, WLang::Dummy, hello_fn.last]]
        optimize(source).should eq(expected)
      end

    end # describe DialectEnforcer
  end # class Compiler
end # module WLang
