require 'spec_helper'
module WLang
  describe Source, "template_content" do
    
    subject{ Source.new(source).template_content }

    context 'on a pure string' do
      let(:source){ "Hello world!" }
      it{ should eq(source) }
    end

    context 'on a Path' do
      let(:source){ hello_path }
      it{ should eq(hello_path.read) }
    end

    context 'on a File' do
      let(:source){ File.open(Path.file.to_s) }
      it{ should eq(File.read(__FILE__)) }
    end

    it 'also works on an IO' do
      hello_io do |io|
        Source.new(io).template_content.should eq(hello_path.read)
      end
    end

    it 'is aliased as to_s' do
      Source.new("raw text").to_s.should eq("raw text")
    end

    it 'is aliased as to_str' do
      Source.new("raw text").to_str.should eq("raw text")
    end

  end
end