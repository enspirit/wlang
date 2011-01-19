here = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(here, '..', '..', 'lib'))
require 'wlang'
require 'test/unit'
module WLang
  class BackBoxTest < Test::Unit::TestCase
    
    def test_on_examples 
      # Dialect used here
      dialect = WLang::dialect("blackbox") do
        dialect("basic") { 
          ruby_require "wlang/rulesets/basic_ruleset"
          rules WLang::RuleSet::Basic
        }
        dialect("context") {
          ruby_require "wlang/rulesets/basic_ruleset"
          ruby_require "wlang/rulesets/context_ruleset"
          rules WLang::RuleSet::Basic
          rules WLang::RuleSet::Context
        }
        dialect("buffering") {
          ruby_require "wlang/rulesets/basic_ruleset"
          ruby_require "wlang/rulesets/buffering_ruleset"
          rules WLang::RuleSet::Basic
          rules WLang::RuleSet::Buffering
        }
        dialect("postblock", ".pre") {
          post_transform{|txt| "<pre>#{txt}</pre>"}
          rules WLang::RuleSet::Basic
          rules WLang::RuleSet::Buffering
          rules WLang::RuleSet::Imperative
        }
        dialect("poststring") {
          post_transform "plain-text/upcase"
          rules WLang::RuleSet::Basic
        }
      end
      hosted = ::WLang::HostedLanguage.new
      def hosted.variable_missing(name)
        ""
      end
      WLang::file_extension_map('.tpl', 'blackbox/buffering')

      # Context used here
      context = {
        'who'         => 'wlang',
        'whowho'      => 'who',
        'input_file'  => 'text_1.txt',
        'data_file_1' => 'data_1.rb',
        'authors'     => ['blambeau', 'llambeau', 'acailliau']
      }

      Dir["#{File.dirname(__FILE__)}/*"].each do |folder|
        dialect_name = File.basename(folder)
        Dir["#{folder}/*.tpl"].each do |template_file|
          begin
            basename = File.basename(template_file, ".tpl")
            expected = File.read(File.join(folder, "#{basename}.exp"))
            template = WLang::file_template(template_file, "blackbox/#{dialect_name}")
            assert_equal(expected, template.instantiate(context.dup, hosted), "Blackbox test failed #{basename}")
          rescue Exception => ex
            puts "Blackbox test failed: #{template_file}\n#{ex.message}"
            puts ex.backtrace.join("\n")
          end
        end
      end
    end
    
  end # class BackBoxTest
end # module WLang