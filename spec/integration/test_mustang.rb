require 'spec_helper'
require 'wlang/mustang'
module WLang
  describe Mustang do
  
    def m(tpl, scope = {}, buffer = "")
      Mustang.render(tpl, scope, buffer)
    end
  
    context '+{...} mimicing {{{ ... }}}' do
      it "renders nothing on nil" do
        m('Hello +{who}', :who => nil).should eq("Hello ")
      end
      it "renders nothing on unknown" do
        m('Hello +{who}', {}).should eq("Hello ")
      end
      it "renders the variable if known" do
        m('Hello +{who}', :who => "World").should eq("Hello World")
      end
      it "calls to_s on such variable" do
        m('Hello +{who}', :who => 12).should eq("Hello 12")
      end
      it "does not escape html" do
        m('Hello +{who}', :who => "<script>").should eq("Hello <script>")
      end
    end
  
    context "${...} mimicing {{ ... }}" do
      it "renders nothing on nil" do
        m('Hello ${who}', :who => nil).should eq("Hello ")
      end
      it "renders nothing on unknown" do
        m('Hello ${who}', {}).should eq("Hello ")
      end
      it "renders the variable if known" do
        m('Hello ${who}', :who => "World").should eq("Hello World")
      end
      it "calls to_s on such variable" do
        m('Hello ${who}', :who => 12).should eq("Hello 12")
      end
      it "does escape html" do
        m('Hello ${who}', :who => "<script>").should eq("Hello &lt;script&gt;")
      end
    end
  
    context "&{...} mimicing {{ ... }}" do
      it "does escape html" do
        m('Hello &{who}', :who => "<script>").should eq("Hello &lt;script&gt;")
      end
    end
  
    context '#{..1..}{..2..} mimicing {{#..1..}}..2..{{/..1..}} ' do
      it 'skips the section on false' do
        m('Hello #{present}{World}', :present => false).should eq("Hello ")
      end
      it 'skips the section on nil' do
        m('Hello #{present}{World}', :present => nil).should eq("Hello ")
      end
      it 'skips the section on missing' do
        m('Hello #{present}{World}').should eq("Hello ")
      end
      it 'skips the section on empty lists' do
        m('Hello #{present}{World}', :present => []).should eq("Hello ")
      end
      it 'iterates on non-empty lists' do
        repo = [{:name => "resque"},{:name => "hub"},{:name => "rip"}]
        m('Hello #{repo}{<b>${name}</b>}', :repo => repo).should eq("Hello <b>resque</b><b>hub</b><b>rip</b>")
      end
      it 'iterates on ranges' do
        m('Hello #{range}{.}', :range => 1..10).should eq("Hello ..........")
      end
      it 'passes the block to a lambda' do
        wrapped = lambda{|fn| "<b>#{fn.call}</b>"}
        scope   = {:wrapped => wrapped, :name => "World"}
        m('#{wrapped}{Hello ${name}}', scope).should eq("<b>Hello World</b>")
      end
      it 'use a Hash a a new scope' do
        m('Hello #{person}{${name}}', :person => {:name => "World"}).should eq("Hello World")
      end
      it 'use a Struct a a new scope' do
        person = Struct.new(:name).new("World")
        m('Hello #{person}{${name}}', :person => person).should eq("Hello World")
      end
      it 'outputs frequently when iterating' do
        m('#{range}{.}', {:range => 1..10}, []).should eq(Array.new(10, '.'))
      end
    end
  
    context "^{..1..}{..2..} mimicing {{^..1..}}..2..{{/..1..}}" do
      it 'renders the section on false' do
        m('Hello ^{missing}{World}', :missing => false).should eq("Hello World")
      end
      it 'renders the section on nil' do
        m('Hello ^{missing}{World}', :missing => nil).should eq("Hello World")
      end
      it 'renders the section on missing' do
        m('Hello ^{missing}{World}').should eq("Hello World")
      end
      it 'renders the section on empty lists' do
        m('Hello ^{missing}{World}', :missing => []).should eq("Hello World")
      end
      it 'does not iterate lists' do
        repo = [{:name => "resque"},{:name => "hub"},{:name => "rip"}]
        m('Hello ^{repo}{<b>${name}</b>}', :repo => repo).should eq("Hello ")
      end
    end
  
    context "!{...} mimicing {{!...}}" do
      it 'skips the section altogether' do
        m('Hello !{this is a comment} world').should eq("Hello  world")
      end
    end
  
    context '>{...} mimicing {{>...}}' do
      it 'renders the partial' do
        scope = {:who => "<b>${name}</b>", :name => "World"}
        m("Hello >{who}", scope).should eq("Hello <b>World</b>")
      end
      it 'supports a pre-compiled partial' do
        scope = {:who => Mustang.compile("<b>${name}</b>"), :name => "World"}
        m("Hello >{who}", scope).should eq("Hello <b>World</b>")
      end
    end
  
  end # describe Mustang
end # module WLang