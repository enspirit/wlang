require 'spec_helper'
module WLang
  describe Source, "template_content" do

    let(:source){ Source.new("Hello world") }
    subject{ source.with_front_matter(enabled) }

    context 'when enabled' do
      let(:enabled){ true }
      it { should be_a(Source::FrontMatter) }
    end

    context 'when disabled' do
      let(:enabled){ false }
      it { should eq(source) }
    end

  end
end