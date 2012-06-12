require 'spec_helper'
module WLang
  describe Source, "raw_text" do

    subject{ Source.new(source).raw_text }

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
      Source.new("raw text").to_s.should eq("raw text")
    end

    it 'is aliased as to_str' do
      Source.new("raw text").to_str.should eq("raw text")
    end

  end
end