require 'spec_helper'
require 'wlang/command'
module WLang
  describe Command, 'install' do

    class Command
      public :install
    end

    let(:cmd){ Command.new }

    subject{
      cmd.install(argv)
    }
    
    context 'with empty ARGV' do
      let(:argv){ [] }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error
      end
    end

    context 'with a single unexisting file' do
      let(:argv){ [ "foo" ] }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error
      end
    end

    context 'with a single existing file' do
      let(:argv){ [ __FILE__ ] }

      it 'sets the file correctly' do
        subject
        cmd.tpl_file.should eq(Path(__FILE__))
      end
    end

    context 'with an existing file and key/value pairs' do
      let(:argv){ [ __FILE__, "foo", "bar", "name", "wlang" ] }

      it 'sets the file correctly' do
        subject
        cmd.tpl_file.should eq(Path(__FILE__))
      end

      it 'sets the context correctly' do
        subject
        cmd.context.should eq("foo" => "bar", "name" => "wlang")
      end
    end

  end
end