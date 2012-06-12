require 'spec_helper'
module WLang
  class Source
    describe Raw, "template_content" do
      
      subject{ Raw.new(source).template_content }

      context 'on a pure string' do
        let(:source){ "Hello world!" }
        it{ should eq(source) }
      end

      context 'on a Path' do
        let(:source){ Path.here }
        it{ should eq(File.read(__FILE__)) }
      end

      context 'on a File' do
        let(:source){ File.open(Path.here.to_s) }
        it{ should eq(File.read(__FILE__)) }
      end

      it 'is aliased as to_s' do
        Raw.new("raw text").to_s.should eq("raw text")
      end

      it 'is aliased as to_str' do
        Raw.new("raw text").to_str.should eq("raw text")
      end

    end
  end
end