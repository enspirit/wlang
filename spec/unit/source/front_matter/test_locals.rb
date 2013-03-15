require 'spec_helper'
module WLang
  class Source
    describe FrontMatter, "locals" do

      let(:template){ nil }

      subject{ FrontMatter.new(source, template).locals }

      context 'without front matter' do
        let(:source){ "Hello world!" }
        it{ should eq({}) }
      end

      context 'with an empty front matter' do
        let(:source){ "---\n---\nHello world!" }
        it{ should eq({}) }
      end

      describe 'with a front matter' do
        let(:source){ "---\nlocals:\n  x: 2\n---\nHello world!" }
        specify 'it decode the YAML data' do
          subject.should eq({"x" => 2})
        end
      end

      describe 'with a front matter containing partials' do
        let(:template){
          tpl_class = Struct.new(:compiler)
          tpl_class.new(Object.new.extend(Module.new{
            def to_ruby_proc(tpl)
              tpl.upcase
            end
          }))
        }
        let(:source){ "---\npartials:\n  x: abc\n---\nHello world!" }
        specify 'it should have correct locals' do
          subject.should eq({"x" => 'ABC'})
        end
      end

    end
  end
end