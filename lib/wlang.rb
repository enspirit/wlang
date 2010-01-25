require 'wlang/ext/string'
require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/encoder_set'
require 'wlang/dialect'
require 'wlang/dialect_dsl'
require 'wlang/dialect_loader'
require 'wlang/basic_object'
require 'wlang/hosted_language'
require 'wlang/hash_scope'
require 'wlang/parser'
require 'wlang/parser_state'
require 'wlang/intelligent_buffer'

#
# Main module of the _wlang_ code generator/template engine, providing a facade 
# on _wlang_ tools. See also the Roadmap section of {README}[link://files/README.html] 
# to enter the library.
#
module WLang
  
  # Current version of WLang
  VERSION = "0.9.0".freeze
  
  # Reusable string for building dialect name based regexps  
  DIALECT_NAME_REGEXP_STR = "[-a-z]+"
  
  #
  # Regular expression for dialect names.
  #
  DIALECT_NAME_REGEXP = /^([-a-z]+)*$/
  
  # Reusable string for building dialect name based regexps  
  QUALIFIED_DIALECT_NAME_REGEXP_STR = "[-a-z]+([\/][-a-z]+)*"
  
  #
  # Regular expression for dialect qualified names. Dialect qualified names are 
  # '/' seperated names, where a name is [-a-z]+. 
  # Examples: wlang/xhtml/uri, wlang/plain-text, ...
  #
  QUALIFIED_DIALECT_NAME_REGEXP = /^[-a-z]+([\/][-a-z]+)*$/

  # Reusable string for building encoder name based regexps  
  ENCODER_NAME_REGEXP_STR = "[-a-z]+"
  
  #
  # Regular expression for encoder names.
  #
  ENCODER_NAME_REGEXP = /^([-a-z]+)*$/
  
  #  
  # Regular expression for encoder qualified names. Encoder qualified names are 
  # '/' seperated names, where a name is [-a-z]+. 
  # Examples: xhtml/entities-encoding, sql/single-quoting, ...
  #
  QUALIFIED_ENCODER_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Reusable string for building qualified encoder name based regexps  
  QUALIFIED_ENCODER_NAME_REGEXP_STR = "[-a-z]+([\/][-a-z]+)*"
  
  #
  # Provides installed {file extension => dialect} mappings. File extensions 
  # (keys) contain the first dot (like .wtpl, .whtml, ...). Dialects (values) are 
  # qualified names, not Dialect instances.
  #
  FILE_EXTENSIONS = {}

  #
  # Provides installed {file extension => data loader} mapping. File extensions 
  # (keys) contain the first dot (like .wtpl, .whtml, ...). Data loades are 
  # Proc instances that take a single |uri| argument.
  #
  DATA_EXTENSIONS = {}
  
  #  
  # Main anonymous dialect. All installed dialects are children of this one, 
  # which is anonymous because it does not appear in qualified names.
  #
  @dialect = Dialect.new("", nil)
  
  #
  # Installs or query a dialect.
  #
  # <b>When called with a block</b>, this method installs a _wlang_ dialect under 
  # _name_ (which cannot be qualified). Extensions can be provided to let _wlang_
  # automatically recognize files that are expressed in this dialect. The block
  # is interpreted as code in the dialect DSL (domain specific language, see 
  # WLang::Dialect::DSL). Returns nil in this case.
  #
  # <b>When called without a block</b> this method returns a Dialect instance 
  # installed under name (which can be a qualified name). Extensions are ignored
  # in this case. Returns nil if not found, a Dialect instance otherwise.
  #
  def self.dialect(name, *extensions, &block)
    if block_given?
      raise "Unsupported qualified names in dialect installation"\
        unless name.index('/').nil?
      Dialect::DSL.new(@dialect).dialect(name, *extensions, &block).build!
    elsif Dialect===name
      name
    else
      @dialect.dialect(name)
    end
  end
  
  #
  # Adds a data loader for file extensions.
  #
  def self.data_loader(*exts, &block)
    raise(ArgumentError, "Block expected") unless block_given?
    raise(ArgumentError, "Block of arity 1 expected") unless block.arity==1
    exts.each do |ext|
      DATA_EXTENSIONS[ext] = block
    end
  end
  
  #
  # Loads data from a given URI. If _extension_ is omitted, tries to infer it
  # from the uri, otherwise use it directly. Returns loaded data. 
  #
  def self.load_data(uri, extension=nil)
    if extension.nil?
      extension = File.extname(uri)
      raise("Unable to infer data loader from #{uri}") if extension.nil?
    end
    loader = DATA_EXTENSIONS[extension]
    raise("No data loader for #{extension}") if loader.nil?
    loader.call(uri) 
  end
  
  # Maps a file extension to a dialect qualified name
  def self.file_extension_map(extension, dialect_qname) 
    WLang::FILE_EXTENSIONS[extension] = dialect_qname
  end

  # Infers a dialect from a file extension
  def self.infer_dialect(uri)
    WLang::FILE_EXTENSIONS[File.extname(uri)]
  end
  
  #
  # Returns an encoder installed under a qualified name. Returns nil if not 
  # found.
  #
  def self.encoder(name)
    @dialect.encoder(name)
  end

  # Factors a template instance for a given string source, dialect (default to
  # 'wlang/active-string') and block symbols (default to :braces)
  def self.template(source, dialect = 'wlang/active-string', block_symbols = :braces)
    template = Template.new(source, WLang::dialect(dialect), block_symbols)
  end

  # Factors a template instance for a given file, optional dialect (if nil is 
  # passed, the dialect is infered from the extension) and block symbols 
  # (default to :braces)
  def self.file_template(file, dialect = nil, block_symbols = :braces)
    # Check the file
    file = File.expand_path(file)
    raise "File '#{file}' does not exists or is unreadable" unless File.exists?(file) and File.readable?(file)
    
    # Check the dialect
    dialect = self.infer_dialect(file) if dialect.nil?
    raise("No known dialect for file extension '#{File.extname(file)}'\n"\
          "Known extensions are: " << WLang::FILE_EXTENSIONS.keys.join(", ")) if dialect.nil?
          
    # Build the template now
    template = template(File.read(file), dialect, block_symbols)
    template.source_file = file
    template
  end

  #
  # Instantiates a template written in some _wlang_ dialect, using a given _context_
  # (providing instantiation data). Returns instantiatiation as a String. If you want 
  # to instantiate the template in a specific buffer (a file or console for example), 
  # use Template. _template_ is expected to be a String and _context_ a Hash. To 
  # know available dialects, see WLang::StandardDialects. <em>block_symbols</em> 
  # can be <tt>:braces</tt> ('{' and '}' pairs), <tt>:brackets</tt> ('[' and ']' 
  # pairs) or <tt>:parentheses</tt> ('(' and ')' pairs). 
  #
  # Examples:
  #   WLang.instantiate "Hello ${who} !", {"who" => "Mr. Jones"}
  #   WLang.instantiate "SELECT * FROM people WHERE name='{name}'", {"who" => "Mr. O'Neil"}, "wlang/sql"
  #   WLang.instantiate "Hello $(who) !", {"who" => "Mr. Jones"}, "wlang/active-string", :parentheses
  #
  def self.instantiate(source, context = {}, dialect="wlang/active-string", block_symbols = :braces)
    template(source, dialect, block_symbols).instantiate(context || {})
  end
  
  #
  # Instantiates a file written in some _wlang_ dialect, using a given _context_
  # (providing instantiation data). If _dialect_ is nil, tries to infer it from the file 
  # extension; otherwise _dialect_ is expected to be a qualified dialect name or a Dialect
  # instance. See instantiate about <tt>block_symbols</tt>.
  #
  # Examples:
  #   Wlang.file_instantiate "template.wtpl", {"who" => "Mr. Jones"}
  #   Wlang.file_instantiate "template.wtpl", {"who" => "Mr. Jones"}, STDOUT
  #   Wlang.file_instantiate "template.xxx", {"who" => "Mr. Jones"}, STDOUT, "wlang/xhtml"
  #
  def self.file_instantiate(file, context = nil, dialect = nil, block_symbols = :braces)
    t = file_template(file, dialect, block_symbols).instantiate(context || {})
  end
  
end
require 'wlang/dialects/standard_dialects'
