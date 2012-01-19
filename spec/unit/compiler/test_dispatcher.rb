require 'spec_helper'
module WLang
  describe Dispatcher do

    def optimize(source)
      WLang::Dispatcher.new(:dialect => dialect).call(source)
    end

    let(:hello_fn){[
      [:fn, [:static, "hello"]],
      [:fn, [:static, "hello"]]
    ]}
    let(:unknown){[
      [:wlang, '!', [:fn, [:static, "hello"]]],
      [:strconcat, [:static, "!"], [:static, "{"], [:static, "hello"], [:static, "}"]]
    ]}

    context 'without dialect' do
      let(:dialect){ nil }

      let(:hello_dollar){[
        [:wlang, '$', hello_fn.first],
        [:dispatch, :dynamic, '$', hello_fn.last]
      ]}

      it 'recurses on template' do
        source   = [:template, hello_dollar.first]
        expected = [:template, hello_dollar.last]
        optimize(source).should eq(expected)
      end

      it 'applies dynamic dispatching' do
        optimize(hello_dollar.first).should eq(hello_dollar.last)
      end

      it 'recurses on strconcat' do
        source   = [:strconcat, hello_dollar.first]
        expected = [:strconcat, hello_dollar.last]
        optimize(source).should eq(expected)
      end

      it 'recurses on high-order wlang' do
        source   = [:wlang, '+', [:fn, hello_dollar.first]]
        expected = [:dispatch, :dynamic, '+', [:fn, hello_dollar.last]]
        optimize(source).should eq(expected)
      end

    end

    context 'with a dialect' do

      let(:dialect){
        WLang::dialect{ tag('$') do |buf,fn| instantiate(fn, buf).upcase end }.new
      }

      let(:hello_dollar){[
        [:wlang, '$', hello_fn.first],
        [:dispatch, :static, :_dtag_36, hello_fn.last]
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

      it 'applies dynamic dispatching on high-order wlang' do
        source   = [:wlang, '$', [:fn, hello_dollar.first]]
        expected = [:dispatch, :static, :_dtag_36, [:fn, [:dispatch, :dynamic, '$', hello_fn.last]]]
        optimize(source).should eq(expected)
      end

    end

  end # describe Dispatcher
end # module WLang
