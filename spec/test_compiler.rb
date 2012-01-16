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
    
    describe '[:fn, ...]' do
      let(:source)  { [:fn,   [:static, "Hello world"]] }
      let(:expected){ [:proc, [:static, "Hello world"]] }
      it{ should eq(expected) }
    end
    
    describe "[:template, ...] should compile the inner function" do
      let(:source)  { [:template, [:fn, [:static, "Hello world!"]]]          }
      let(:expected){ [:proc, [:static, "Hello world!"]] }
      it{ should eq(expected) }
    end
    
    describe '[:wlang, ...]' do
      
      context "without dialect" do
        let(:source)  { [:wlang, "$", [:fn, [:static, "Hello world"]]] }
        let(:expected){ [:dispatch, :dynamic, "$", [:proc, [:static, "Hello world"]]] }
        it{ should eq(expected) }
      end
      
      context "with a dialect" do
        def braces
          [ '{', '}' ]
        end
        def dispatch_name(symbols) 
          symbols == "!" ? :execution : nil
        end
        let(:compiler){ WLang::Compiler.new(:dialect => self) }
        context "on an existing rule" do
          let(:source)  { [:wlang, "!", [:fn, [:static, "Hello world"]]] }
          let(:expected){ [:dispatch, :static, :execution, [:proc, [:static, "Hello world"]]] }
          it{ should eq(expected) }
        end
        context "on an missing rule" do
          let(:source)  { [:wlang, "$", [:fn, [:static, "Hello world"]]] }
          let(:expected){ [:multi, [:static, "$"], 
                            [:static, "{"], [:static, "Hello world"], [:static, "}"] ]}
          it{ should eq(expected) }
        end
        context "on an missing rule with two blocks" do
          let(:source)  { [:wlang, "$", [:fn, [:static, "Hello "]], [:fn, [:static, "world"]] ] }
          let(:expected){ [:multi, [:static, "$"], 
                            [:static, "{"], [:static, "Hello "], [:static, "}"], 
                            [:static, "{"], [:static, "world"],  [:static, "}"] ] }
          it{ should eq(expected) }
        end
        context 'on high-order template' do
          let(:source){ 
            [:wlang, "!", [:fn, [:wlang, "!", [:static, "who"]] ] ]
          }
          let(:expected){ 
            [ :dispatch, :static, :execution, 
                [:proc, 
                  [:dispatch, :dynamic, "!", 
                    [:static, "who"] ] ] ]
          }
          it{ should eq(expected) }
        end
      end # with a dialect
      
    end # [:wlang, ...]
    
  end # describe Compile
end # module WLang