require 'spec_helper'
module WLang
  describe Source, "path" do
    
    subject{ Source.new(source).path }

    context 'on a pure string' do
      let(:source){ "Hello world!" }
      it{ should be_nil }
    end

    context 'on a Path' do
      let(:source){ Path.here }
      it{ should eq(source.to_s) }
    end

    context 'on a File' do
      let(:source){ File.open(Path.here.to_s) }
      it{ should eq(__FILE__) }
    end

    it 'is aliased as to_path' do
      Source.new(Path.here).to_path.should eq(__FILE__)
    end

  end
end