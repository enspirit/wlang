require 'spec_helper'
require 'rack/test'
describe 'Integration with Sinatra for partials' do
  include Rack::Test::Methods

  let(:app){ 
    sinatra_app do
      set :accessible, "world"
      set :views, fixtures_folder/'templates'
      template :internal_partial do
        "Hello ${who}!"
      end
      helpers do
        def accessible; settings.accessible; end
      end
      get '/external' do
        wlang ">{hello}", :locals => {:who => "sinatra"}
      end
      get '/internal' do
        wlang ">{internal_partial}", :locals => {:who => "sinatra"}
      end
      get '/front-matter' do
        wlang ">{front_matter}", :locals => {:who => "sinatra"}
      end
    end
  }

  it 'renders external partials correcty' do
    get '/external'
    last_response.body.should eq("Hello sinatra!")
  end

  it 'renders internal partials correcty' do
    get '/internal'
    last_response.body.should eq("Hello sinatra!")
  end

  it 'renders with front matters correcty' do
    get '/front-matter'
    last_response.body.should eq("Hello sinatra bar!")
  end
end
