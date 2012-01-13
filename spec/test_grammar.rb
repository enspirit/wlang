require 'spec_helper'
module WLang
  describe Grammar do
    
    let(:grammar){ WLang::Grammar }

    it 'fn_start' do
      match = grammar.parse("{", :root => :fn_start)
      match.should_not be_nil
      match.should eq("{")
    end
    
    it 'fn_stop' do
      match = grammar.parse("}", :root => :fn_stop)
      match.should_not be_nil
      match.should eq("}")
    end
    
    it 'symbols' do
      WLang::SYMBOLS.each do |sym|
        match = grammar.parse(sym, :root => :symbols)
        match.should_not_be_nil
        match.should eq(sym)
      end
      match = grammar.parse(WLang::SYMBOLS.join, :root => :symbols)
      match.should_not_be_nil
    end
    
    it 'stop_char' do
      grammar.parse("{", :root => :stop_char).should eq("{")
      grammar.parse("}", :root => :stop_char).should eq("}")
      grammar.parse("${", :root => :stop_char).should eq("${")
      grammar.parse("<<+{", :root => :stop_char).should eq("<<+{")
      lambda{ grammar.parse("$", :root => :stop_char) }.should raise_error(Citrus::ParseError)
    end
    
    it 'block' do
      grammar.parse("{ hello }", :root => :block).should eq("{ hello }")
    end
    
    it 'wlang' do
      grammar.parse("${who}", :root => :wlang).should eq("${who}")
    end

    it 'static' do
      grammar.parse("Hello world",  :root => :static).should eq("Hello world")
      grammar.parse("Hello ${who}", :root => :static, :consume => false).should eq("Hello ")
    end
    
    it 'non_static' do
      grammar.parse("{ hello }", :root => :non_static).should eq("{ hello }")
      grammar.parse("${who}",    :root => :non_static).should eq("${who}")
    end
    
    it 'concat' do
      grammar.parse("Hello ${who}", :root => :concat).should eq("Hello ${who}")
    end
    
    it 'template' do
      grammar.parse("Hello").should eq("Hello")
      grammar.parse("Hello!").should eq("Hello!")
      grammar.parse("Hello ${who}!").should eq("Hello ${who}!")
    end
    
  end
end