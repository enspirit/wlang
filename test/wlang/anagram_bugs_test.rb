require 'test/unit'
require 'wlang'
module WLang

  # Tests the IntelligentBuffer class
  class AnagramBugsTest < Test::Unit::TestCase
    include IntelligentBuffer::Methods
   
    def test_on_anagram_spacing_policy
      WLang::dialect("anagram") do
        rule '=~' do |parser,offset|
          match, reached = parser.parse(offset, "wlang/dummy")
          block, reached = parser.parse_block(reached, "wlang/dummy")

          # puts "Here is the block ==="
          # puts "#{block.gsub(/ /, '.').gsub(/\n/, "\\n\n")}"
          # puts "=== Here is the block"

          [block, reached]
        end
      end
      template = %q{
        =~{String}{
          this is an anagram template
        }
      }.gsub(/^ {8}/, '').strip
      result = template.wlang_instantiate({}, "anagram")
      assert IntelligentBuffer===result
#      assert_equal("this is an anagram template", result)

      template = %q{
        =~{String}{
          module MyModule
          end
        }
      }.gsub(/^ {8}/, '').strip
      result = template.wlang_instantiate({}, "anagram")
      assert IntelligentBuffer===result
#      assert_equal("module MyModule\nend", result)
    end
    
    def test_missing_end_bug
      WLang::dialect("anagram") do
        rules WLang::RuleSet::Basic
        rules WLang::RuleSet::Imperative
        rule '=~' do |parser,offset|
          match, reached = parser.parse(offset, "wlang/dummy")
          match = parser.evaluate(match)
          block, reached = parser.parse_block(reached, "wlang/dummy")
          block = block.strip_block(block)
          block = block.tabto(block,0)
          parser.evaluate("matching_rules") << [match, block]
    
          puts "Here is the block ==="
          puts "#{block.gsub(/ /, '.').gsub(/\n/, "\\n\n")}"
          puts "=== Here is the block"
    
          ["", reached]
        end
        rule '+~' do |parser,offset|
          what, reached = parser.parse(offset, "wlang/dummy")
          evaluated = parser.evaluate(what)
          raise "Unexpected case, #{what} leads to nil" unless evaluated
    
          rules = parser.evaluate("matching_rules")
          found = rules.find {|r| r[0]===evaluated}
          raise "Unexpected case: no match for #{what.class}" unless found
    
          context = {"n" => evaluated, "matching_rules" => rules}
          inst = found[1].wlang_instantiate(context, "anagram")
          
          inst2 = inst.gsub(/ /, '.').gsub(/\n/, "\\n\n")
          puts "Here is the inst ==="
          puts "#{inst2}"
          puts "=== Here is the inst"
          
          found = [inst, reached]
        end
      end
      template = %Q{
        =~{Array}{
          module MyModule
            *{n as c}{
              +~{c}
            }
          end
        }
        =~{Integer}{
          +{n}
        }
        +~{n}
      }.gsub(/ {8}/,'').strip
      context = {'n' => [10, 20, 30], 'matching_rules' => []}
      result = template.wlang_instantiate(context, "anagram")
    
      template = template.gsub(/ /, '.').gsub(/\n/, "\\n\n")
      puts "Here is the template ==="
      puts "#{template}"
      puts "=== Here is the template"
    
      result = result.gsub(/ /, '.').gsub(/\n/, "\\n\n")
      puts "Here is the result ==="
      puts "#{result}"
      puts "=== Here is the result"
    end
    
  end
end