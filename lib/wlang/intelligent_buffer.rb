module WLang
  
  # Provides an intelligent output buffer
  class IntelligentBuffer < String
    
    # Some string utilities
    module Utils

      # Regular expression for stripping block (see strip_block)
      STRIP_BLOCK_REGEXP =  /^([\t ]*\n)?(([\t ]*\n)*([\t ]*).*\n)([\t ]*)$/m
      #                       1          23          4            5
      
      # Checks if _str_ contains multiple lines
      def is_multiline?(str)
        str =~ /\n/ ? true : false
      end
    
      #
      # Strips a multiline block.
      #
      # Example:
      #   ([\t ]*\n)?
      #   ([\t ]\n)*
      #   [\t ]*some text here\n
      #   [\t ]*  indented also\n?
      #   [\t ]*
      #
      # becomes:
      #   some text here\n
      #     indented also\n
      #
      def strip_block(str)
        return str unless is_multiline?(str)
        match = str.match(STRIP_BLOCK_REGEXP)
        return str unless match
        space_count = match[4].length
        match[2].gsub(Regexp.new("^[ \t]{#{space_count}}"), '')
      end
      
      # Realigns a multiline string to a specific offset
      def realign(str, offset)
        return str unless is_multiline?(str)
        indent = ' '*(offset)
        str.gsub(/^/, indent)
      end
    
      # Returns column number of a specific offset
      def column_of(str, index)
        return 1 if index == 0
        newline_index = str.rindex("\n", index - 1)
        if newline_index
          index - newline_index
        else
          index + 1
        end
      end
      
      # Returns the column of the last character
      def last_column(str)
        column_of(str, str.length)
      end
    
    end
    
    # Include utilities
    include Utils
    
    # Pushes a string, aligning it first
    def <<(str, block)
      if block and is_multiline?(str) and stripped = strip_block(str)
        str = realign(stripped, last_column(self)-1)
        str = str.match(/^[\t ]*/).post_match
      end
      super(str)
    end
    
  end
  
end