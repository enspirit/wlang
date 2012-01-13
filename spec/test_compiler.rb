require 'spec_helper'
module WLang
  describe Compiler do
    
    let(:compiler){ WLang::Compiler.new }
    
    subject{ compiler.call(source) }

    describe '[:static, ...]' do
      let(:source)  { [:static, "Hello world"] }
      let(:expected){ [:static, "Hello world"] }
      it{ should eq(expected) }
    end

    describe '[:strconcat, ...] should transform [:strconcat, ...] as [:multi, ...]' do
      let(:source)  { [:strconcat, [:static, "Hello "], [:static, "world"]] }
      let(:expected){ [:multi,     [:static, "Hello "], [:static, "world"]] }
      it{ should eq(expected) }
    end

    
    describe '[:strconcat, ...] should recurse one children' do
      let(:source)  { [:strconcat, [:strconcat, [:static, "Hello "], [:static, "world"]], [:static, "!"]] }
      let(:expected){ [:multi,     [:multi,     [:static, "Hello "], [:static, "world"]], [:static, "!"]] }
      it{ should eq(expected) }
    end
    
    describe "[:template, ...] should compile the inner function" do
      let(:source)  { [:template, [:fn, [:static, "Hello world!"]]]          }
      let(:expected){ [:proc, "_wlang_compiler1", [:static, "Hello world!"]] }
      it{ should eq(expected) }
    end

  end
end