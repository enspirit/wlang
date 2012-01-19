require 'spec_helper'
module WLang
  describe ToRubyAbstraction do

    def optimize(source)
      WLang::ToRubyAbstraction.new.call(source)
    end

    let(:hello){[
      [:static, "Hello world"],
      [:static, "Hello world"]
    ]}
    let(:strconcat){[
      [:strconcat, [:static, "Hello "], [:static, "world"]],
      [:multi,     [:static, "Hello "], [:static, "world"]]
    ]}

    it 'let [:static, ...] unchanged' do
      optimize(hello.first).should eq(hello.last)
    end

    it 'transforms :strconcat to :mutli' do
      optimize(strconcat.first).should eq(strconcat.last)
    end

    it 'recurses on :strconcat' do
      source   = [:strconcat, strconcat.first]
      expected = [:multi,     strconcat.last]
      optimize(source).should eq(expected)
    end

    it 'transforms :fn to :proc' do
      source   = [:fn, hello.first]
      expected = [:proc, hello.last]
      optimize(source).should eq(expected)
    end

    it 'recurses on :fn' do
      source   = [:fn, strconcat.first]
      expected = [:proc, strconcat.last]
      optimize(source).should eq(expected)
    end

    it "recurses on :template" do
      source   = [:template, strconcat.first]
      expected = [:template, strconcat.last]
      optimize(source).should eq(expected)
    end

    it 'recurses on :dispatch' do
      source   = [:dispatch, :static, :meth, [:fn, strconcat.first]]
      expected = [:dispatch, :static, :meth, [:proc, strconcat.last]]
      optimize(source).should eq(expected)
    end

  end # describe ToRubyAbstraction
end # module WLang
