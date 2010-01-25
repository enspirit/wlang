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
      end

      # Context used here
      context = {
        'who'      => 'wlang',
        'whowho'   => 'who'
      }

      Dir["#{File.dirname(__FILE__)}/*"].each do |folder|
        dialect_name = File.basename(folder)
        Dir["#{folder}/*.tpl"].each do |template_file|
          begin
            basename = File.basename(template_file, ".tpl")
            template = File.read(File.join(folder, "#{basename}.tpl"))
            expected = File.read(File.join(folder, "#{basename}.exp"))
            assert_equal(expected, template.wlang(context.dup, "blackbox/#{dialect_name}"), "Blackbox test failed #{basename}")
          rescue Exception => ex
            puts "Blackbox test failed: #{template_file}\n#{ex.message}"
            puts ex.backtrace.join("\n")
          end
        end
      end
    end
    
  end # class BackBoxTest
end # module WLang