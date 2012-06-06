require 'spec_helper'
module WLang
  describe Template, 'source_text' do

    let(:raw){ "Hello ${who}!" }

    before do
      class Template; public :source_text; end
    end

    subject{ Template.new(source).source_text }

    context 'with a string ' do
      let(:source){ raw }
      it{ should eq(raw) }
    end

    context 'when based on a file' do
      let(:path){ Path.dir/"test.wang" }
      before do
        path.write(raw)
      end
      after do
        path.unlink rescue nil
      end
      context 'with a Path' do
        let(:source){ path }
        it{ should eq(raw) }
      end
      context 'with an IO' do
        let(:source){ File.open(path.to_s) }
        it{ should eq(raw) }
      end
    end

  end
end