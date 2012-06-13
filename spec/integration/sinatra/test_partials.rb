require 'spec_helper'
require 'rack/test'
describe 'Integration with Sinatra for partials' do
  include Rack::Test::Methods

  let(:app){ 
    sinatra_app do
      set :accessible, "world"
      set :views, fixtures_folder/'templates'
      helpers do
        def accessible; settings.accessible; end
      end
      get '/' do
        wlang :hello_from_sinatra, :locals => {:who => "sinatra"}
      end
    end
  }

  it 'renders partials correcty' do
    get '/'
    last_response.body.should eq("Hello Hello sinatra!!\n")
  end

end
