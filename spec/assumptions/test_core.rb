require 'spec_helper'
describe "Core assumptions" do

  specify 'Hash does not respond to #<<' do
    {}.should_not respond_to(:<<)
  end

end