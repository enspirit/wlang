here = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(here, '..', '..', 'lib'))
require 'wlang'
require 'test/unit'
module WLang
  class StandardDialectsTest < Test::Unit::TestCase
    
    def test_standard_dialects
      Dir["#{File.dirname(__FILE__)}/*"].each do |folder|
        dialect_name = File.basename(folder)
        Dir["#{folder}/*.tpl"].each do |template_file|
          begin
            basename = File.basename(template_file, ".tpl")
            expected = File.read(File.join(folder, "#{basename}.exp"))
            template = WLang::file_template(template_file, "wlang/#{dialect_name}")
            assert_equal(expected, template.instantiate, "Standard dialect test failed wlang/#{basename}")
          rescue WLang::Error => ex
            puts "Standard dialect test failed: #{template_file}\n#{ex.message}"
            puts ex.wlang_backtrace.join("\n")
          rescue Exception => ex
            puts "Standard dialect test failed: #{template_file}\n#{ex.message}"
            puts ex.backtrace.join("\n")
          end
        end
      end
    end
    
  end # class StandardDialectsTest
end # module WLang