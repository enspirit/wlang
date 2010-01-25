require 'wlang/template'

#
# Provides some test utilities
#
module WLang::TestUtils
  
  # Returns a relative file
  def relative_file(name, from=__FILE__)
    File.join(File.dirname(from), name)
  end
  
  # Returns a relative file
  def read_relative_file(name, from=__FILE__)
    File.read(File.join(File.dirname(from), name))
  end
  
  # Factors a template and fakes its source-file as from
  def relative_template(src, dialect, from=__FILE__)
    template = WLang::template(src, dialect)
    template.source_file = from
    template
  end
  
end