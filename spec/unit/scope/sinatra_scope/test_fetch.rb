require 'spec_helper'
module WLang
  class Scope
    describe SinatraScope, 'fetch' do

      let(:app){ 
        sinatra_app do
          set :accessible, "world"
          set :views, fixtures_folder/'templates'
          helpers do
            def accessible; settings.accessible; end
          end
        end
      }

      let(:scope){ Scope::SinatraScope.new(app) }

      it 'delegates to helpers correctly' do
        scope.fetch(:accessible).should eq("world")
      end

      it 'returns Tilt templates on existing views' do
        scope.fetch('hello', app).should be_a(Tilt::Template)
      end

    end
  end
end
