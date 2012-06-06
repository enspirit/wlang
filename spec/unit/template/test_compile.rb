require 'spec_helper'
module WLang
  describe Template, 'compile' do

    before do
      class Template; public :compile; end
    end

    def template
      Template.new(source, options)
    end

    let(:options){ {} }

    context 'with a single source String and no options' do
      let(:source){ "Hello world!" }
      specify{
        template.locals.should eq({})
      }
    end

    context 'with a yaml front matter and default options' do
      let(:source){ hello_with_data_path }
      specify{
        template.locals.should eq({"who" => "world"})
      }
    end

    context 'with a yaml front matter and front matter disabled' do
      let(:source){ hello_with_data_path }
      let(:options){ {:yaml_front_matter => false} }
      specify{
        template.locals.should eq({})
      }
    end

    context 'with explicit locals' do
      let(:source){ hello_with_explicit_locals_path }
      specify{
        template.locals.should eq({"who" => "world", "who_else" => "wlang"})
      }
    end

    context 'with partials' do
      let(:source){ hello_with_partials_path }
      specify{
        template.locals.should_not be_empty
        template.locals["who"].should be_a(Proc)
      }
    end

  end
end