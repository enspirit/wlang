require 'spec_helper'
module WLang
  class Source
    describe FrontMatter, "template_content" do

      subject{ FrontMatter.new(source).template_content }

      context 'without front matter' do
        let(:source){ "Hello world!" }
        it{ should eq(source) }
      end

      describe 'with a front matter' do
        let(:source){ "---\nlocals:\n  x: 2\n---\nHello world!" }
        specify 'it should not return the front matter itself' do
          subject.should eq("Hello world!")
        end
      end

    end
  end
end