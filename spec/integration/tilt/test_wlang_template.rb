require 'tilt'
require 'wlang/tilt'
describe 'WLang integration with tilt' do

  it 'allows invoking tilt directly' do
    Tilt.new(hello_path.to_s).render(:who => "world").should eq("Hello world!")
  end

  it 'allows specifying the dialect' do
    Tilt.new(hello_path.to_s, :dialect => Upcasing).render.should eq("Hello WHO!")
  end

end