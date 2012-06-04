require 'tilt'
require 'wlang/tilt'
describe Tilt::WLangTemplate do

  it 'is registered for .wlang files' do
    Tilt.mappings['wlang'].should include(Tilt::WLangTemplate)
  end

  it 'supports basic rendering with no scope no locals' do
    template = Tilt::WLangTemplate.new{ "Hello" }
    template.render.should eq("Hello")
  end

  it 'supports a binding scope' do
    template = Tilt::WLangTemplate.new{ "Hello ${who}" }
    who = "world"
    template.render(binding).should eq("Hello world")
  end

  it 'supports a Hash scope' do
    template = Tilt::WLangTemplate.new{ "Hello ${who}" }
    scope = {:who => "world"}
    template.render(scope).should eq("Hello world")
  end

  it 'supports both a scope and locals' do
    template = Tilt::WLangTemplate.new{ "Hello ${who} and ${who_else}" }
    who = "world"
    template.render(binding, :who_else => 'wlang').should eq("Hello world and wlang")
  end

  it 'supports being rendered multiple times' do
    template = Tilt::WLangTemplate.new{ "Hello ${i}" }
    3.times{|i| template.render(binding).should eq("Hello #{i}") }
  end

  it 'supports passing a dialect as options' do
    template = Tilt::WLangTemplate.new(:dialect => Upcasing){ "Hello ${who}" }
    template.render.should eq("Hello WHO")
  end

end