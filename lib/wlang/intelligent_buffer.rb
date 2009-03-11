module WLang
  
  # Provides an intelligent output buffer
  class IntelligentBuffer < String
    
    # Some string utilities
    module Methods

      # Aligns _str_ at left offset _n_
      # Credits: Treetop and Facets 2.0.2
      def tabto(str, n)
        if str =~ /^( *)\S/
          indent(str, n - $1.length)
        else
          str
        end
      end

      # Positive or negative indentation of _str_
      # Credits: Treetop and Facets 2.0.2
      def indent(str, n)
        if n >= 0
          str.gsub(/^/, ' ' * n)
        else
          str.gsub(/^ {0,#{-n}}/, "")
        end
      end

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
        match = str.match(/\A[\t ]*\n?/)
        str = match.post_match if match
        match = str.match(/\n[\t ]*\Z/)
        str = (match.pre_match << "\n") if match
        str
      end
      
      # Returns column number of a specific offset
      # Credits: Treetop and Facets 2.0.2
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
    
      # Pushes a string, aligning it first
      def <<(str, block=false)
        if block and is_multiline?(str) and stripped = strip_block(str)
          str = tabto(stripped, last_column(self)-1)
          str = str.match(/\A[\t ]*/).post_match
        end
        super(str)
      end
    
      # WLang explicit appending
      def wlang_append(str, block)
        self.<<(str, block)
      end
    
    end
    
    # Include utilities
    include Methods
    
  end
  
end