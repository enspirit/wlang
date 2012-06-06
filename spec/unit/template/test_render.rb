require 'spec_helper'
module WLang
  describe Template, 'render' do

    def template
      Template.new(source, options)
    end

    let(:options){ {} }

    subject{ template.render }

    context 'with a single source String and no options' do
      let(:source){ "Hello world!" }
      it{ should eq("Hello world!") }
    end

    context 'with a yaml front matter and default options' do
      let(:source){ hello_with_data_path }
      it{ should eq("Hello world!") }
    end

    context 'with a yaml front matter and front matter disabled' do
      let(:source){ hello_with_data_path }
      let(:options){ {:yaml_front_matter => false} }
      it 'should fail' do
        lambda{
          subject
        }.should raise_error(NameError)
      end
    end

    context 'with explicit locals' do
      let(:source){ hello_with_explicit_locals_path }
      it{ should eq("Hello world and wlang!") }
    end

    context 'with partials' do
      let(:source){ hello_with_partials_path }
      it{ should eq("Hello world and wlang!") }
    end

  end
end