require 'wlang/ext/string'
require 'stringio'
require 'wlang/rule'
require 'wlang/rule_set'
require 'wlang/encoder_set'
require 'wlang/dialect'
require 'wlang/dialect_dsl'
require 'wlang/dialect_loader'
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
  VERSION = "0.10.0".freeze

  ######################################################################## About files and extensions
  
  # Regular expression for file extensions
  FILE_EXTENSION_REGEXP = /^\.[a-zA-Z0-9]+$/
  
  # Checks that _ext_ is a valid file extension or raises an ArgumentError
  def self.check_file_extension(ext)
    raise ArgumentError, "Invalid file extension #{ext} (/^\.[a-zA-Z-0-9]+$/ expected)", caller\
      unless FILE_EXTENSION_REGEXP =~ ext
  end
  
  # Raises an ArgumentError unless file is a real readable file
  def self.check_readable_file(file)
    raise ArgumentError, "File #{file} is not readable or not a file"\
      unless File.exists?(file) and File.file?(file) and File.readable?(file)
  end
  
  ######################################################################## About dialects
  
  # Reusable string for building dialect name based regexps  
  DIALECT_NAME_REGEXP_STR = "[-a-z]+"
  
  # Regular expression for dialect names.
  DIALECT_NAME_REGEXP = /^([-a-z]+)*$/
  
  # Reusable string for building dialect name based regexps  
  QUALIFIED_DIALECT_NAME_REGEXP_STR = "[-a-z]+([\/][-a-z]+)*"
  
  # Regular expression for dialect qualified names. Dialect qualified names are 
  # '/' seperated names, where a name is [-a-z]+. 
  #
  # Examples: wlang/xhtml/uri, wlang/plain-text, ...
  QUALIFIED_DIALECT_NAME_REGEXP = /^[-a-z]+([\/][-a-z]+)*$/

  # Checks that _name_ is a valid qualified dialect name or raises an ArgumentError
  def self.check_qualified_dialect_name(name)
    raise ArgumentError, "Invalid dialect qualified name #{name} (/^[-a-z]+([\/][-a-z]+)*$/ expected)", caller\
      unless QUALIFIED_DIALECT_NAME_REGEXP =~ name
  end

  #
  # Provides installed {file extension => dialect} mappings. File extensions 
  # (keys) contain the first dot (like .wtpl, .whtml, ...). Dialects (values) are 
  # qualified names, not Dialect instances.
  #
  FILE_EXTENSIONS = {}

  #  
  # Main anonymous dialect. All installed dialects are children of this one, 
  # which is anonymous because it does not appear in qualified names.
  #
  @dialect = Dialect.new("", nil)

  # Returns the root of the dialect tree
  def self.dialect_tree
    @dialect
  end
  
  #
  # Maps a file extension to a dialect qualified name.
  #
  # Example:
  #
  #   # We create an 'example' dialect
  #   WLang::dialect('example') do
  #     # see WLang::dialect about creating a dialect
  #   end
  #
  #   # We map .wex file extensions to our new dialect
  #   WLang::file_extension_map('.wex', 'example')
  #
  # This method raises an ArgumentError if the extension or dialect qualified
  # name is not valid.
  #
  def self.file_extension_map(extension, dialect_qname)
    check_file_extension(extension)
    check_qualified_dialect_name(dialect_qname)
    WLang::FILE_EXTENSIONS[extension] = dialect_qname
  end

  #
  # Infers a dialect from a file extension. Returns nil if no dialect is currently
  # mapped to the given extension (see file_extension_map)
  #
  # This method never raises errors.
  #
  def self.infer_dialect(uri)
    WLang::FILE_EXTENSIONS[File.extname(uri)]
  end
  
  #
  # Ensures, installs or query a dialect.
  #
  # <b>When name is a Dialect</b>, returns it immediately. This helper is provided
  # for methods that accept both qualified dialect name and dialect instance 
  # arguments. Calling <code>WLang::dialect(arg)</code> ensures that the result will
  # be a Dialect instance in all cases (if the arg is valid).
  #
  # Example:
  #    
  #   # This methods does something with a wlang dialect. _dialect_ argument may
  #   # be a Dialect instance or a qualified dialect name.
  #   def my_method(dialect = 'wlang/active-string')
  #     # ensures the Dialect instance or raises an ArgumentError if the dialect
  #     # qualified name is invalid (returns nil otherwise !)
  #     dialect = WLang::dialect(dialect) 
  #   end
  #
  # <b>When called with a block</b>, this method installs a _wlang_ dialect under 
  # _name_ (which cannot be qualified). Extensions can be provided to let _wlang_
  # automatically recognize files that are expressed in this dialect. The block
  # is interpreted as code in the dialect DSL (domain specific language, see 
  # WLang::Dialect::DSL). Returns nil in this case.
  #
  # Example:
  #
  #   # New dialect with 'my_dialect' qualified name and automatically installed
  #   # to recognize '.wmyd' file extensions
  #   WLang::dialect("my_dialect", '.wmyd') do
  #     # see WLang::Dialect::DSL for this part of the code
  #   end
  #
  # <b>When called without a block</b> this method returns a Dialect instance 
  # installed under name (which can be a qualified name). Extensions are ignored
  # in this case. Returns nil if not found, a Dialect instance otherwise.
  #
  # Example:
  #
  #   # Lookup for the 'wlang/xhtml' dialect
  #   wxhtml = WLang::dialect('wlang/xhtml')
  #
  # This method raises an ArgumentError if
  # * _name_ is not a valid dialect qualified name
  # * any of the file extension in _extensions_ is invalid
  #
  def self.dialect(name, *extensions, &block)
    # first case, already a dialect
    return name if Dialect===name
    
    # other cases, argument validations
    check_qualified_dialect_name(name)
    extensions.each {|ext| check_file_extension(ext)}
    
    if block_given?
      # first case, dialect installation
      raise "Unsupported qualified names in dialect installation"\
        unless name.index('/').nil?
      Dialect::DSL.new(@dialect).dialect(name, *extensions, &block)
    else
      # second case, dialect lookup
      @dialect.dialect(name)
    end
  end
  
  ######################################################################## About encoders
  
  # Reusable string for building encoder name based regexps  
  ENCODER_NAME_REGEXP_STR = "[-a-z]+"
  
  # Regular expression for encoder names.
  ENCODER_NAME_REGEXP = /^([-a-z]+)*$/
  
  # Reusable string for building qualified encoder name based regexps  
  QUALIFIED_ENCODER_NAME_REGEXP_STR = "[-a-z]+([\/][-a-z]+)*"
  
  # Regular expression for encoder qualified names. Encoder qualified names are 
  # '/' seperated names, where a name is [-a-z]+. 
  #
  # Examples: xhtml/entities-encoding, sql/single-quoting, ...
  QUALIFIED_ENCODER_NAME_REGEXP = /^([-a-z]+)([\/][-a-z]+)*$/
  
  # Checks that _name_ is a valid qualified encoder name or raises an ArgumentError
  def self.check_qualified_encoder_name(name)
    raise ArgumentError, "Invalid encoder qualified name #{name} (/^[-a-z]+([\/][-a-z]+)*$/ expected)", caller\
      unless QUALIFIED_ENCODER_NAME_REGEXP =~ name
  end
  
  #
  # Returns an encoder installed under a qualified name. Returns nil if not 
  # found. If name is already an Encoder instance, returns it immediately.
  #
  # Example:
  #
  #   encoder = WLang::encoder('xhtml/entities-encoding')
  #   encoder.encode('something that needs html entities escaping')
  #
  # This method raises an ArgumentError if _name_ is not a valid encoder qualified 
  # name.
  #
  def self.encoder(name)
    check_qualified_encoder_name(name)
    @dialect.encoder(name)
  end
  
  # 
  # Shortcut for
  #
  #   WLang::encoder(encoder_qname).encode(source, options)
  #
  # This method raises an ArgumentError 
  # * if _source_ is not a String
  # * if the encoder qualified name is invalid
  # 
  # It raises a WLang::Error if the encoder cannot be found
  #
  def self.encode(source, encoder_qname, options = {})
    raise ArgumentError, "String expected for source" unless String===source
    check_qualified_encoder_name(encoder_qname)
    encoder = WLang::encoder(encoder_qname)
    raise WLang::Error, "Unable to find encoder #{encoder_qname}" if encoder.nil?
    encoder.encode(source, options)
  end

  ######################################################################## About data loading
  
  #
  # Provides installed {file extension => data loader} mapping. File extensions 
  # (keys) contain the first dot (like .wtpl, .whtml, ...). Data loades are 
  # Proc instances that take a single |uri| argument.
  #
  DATA_EXTENSIONS = {}
  
  #
  # Adds a data loader for file extensions. A data loader is a block of arity 1, 
  # taking a file as parameter and returning data decoded from the file.
  #
  # Example:
  #
  #   # We have some MyXMLDataLoader class that is able to create a ruby object
  #   # from things expressed .xml files
  #   WLang::data_loader('.xml') {|file|
  #     MyXMLDataLaoder.parse_file(file)
  #   }
  #
  #   # Later in a template (see the buffering ruleset that gives you <<={...})
  #   <<={resources.xml as resources}
  #   <html>
  #     *{resources as r}{
  #       ...
  #     }
  #   </html>
  #
  # This method raises an ArgumentError if 
  # * no block is given or if the block is not of arity 1
  # * any of the file extensions in _exts_ is invalid
  #
  def self.data_loader(*exts, &block)
    raise(ArgumentError, "WLang::data_loader expects a block") unless block_given?
    raise(ArgumentError, "WLang::data_loader expects a block of arity 1") unless block.arity==1
    exts.each {|ext| check_file_extension(ext)   }
    exts.each {|ext| DATA_EXTENSIONS[ext] = block}
  end
  
  #
  # Loads data from a given URI. If _extension_ is omitted, tries to infer it
  # from the uri, otherwise use it directly. Returns loaded data. 
  #
  # This method raises a WLang::Error if no data loader is installed for the found 
  # extension. It raises an ArgumentError if the file extension is invalid.
  #
  def self.load_data(uri, extension=nil)
    check_file_extension(extension = extension.nil? ? File.extname(uri) : extension)
    loader = DATA_EXTENSIONS[extension]
    raise ::WLang::Error("No data loader for #{extension}") if loader.nil?
    loader.call(uri) 
  end
  
  ######################################################################## About templates and instantiations
  
  #
  # Factors a template instance for a given string source, dialect (default to
  # 'wlang/active-string') and block symbols (default to :braces)
  #
  # Example:
  #
  #   # The template source code must be interpreted as wlang/xhtml
  #   template = WLang::template('<p>Hello ${who}!</p>', 'wlang/xhtml')
  #   str = template.instantiate(:hello => 'world')
  #
  #   # We may also use other block symbols...
  #   template = WLang::template('<p>Hello $(who)!</p>', 'wlang/xhtml', :parentheses)
  #   str = template.instantiate(:hello => 'world')
  #
  # This method raises an ArgumentError if 
  # * _source_ is not a String
  # * _dialect_ is not a valid dialect qualified name or Dialect instance
  # * _block_symbols_ is not in [:braces, :brackets, :parentheses]
  #
  def self.template(source, dialect = 'wlang/active-string', block_symbols = :braces)
    raise ArgumentError, "String expected for source" unless String===source
    raise ArgumentError, "Invalid symbols for block #{block_symbols}"\
      unless ::WLang::Template::BLOCK_SYMBOLS.keys.include?(block_symbols)
    template = Template.new(source, WLang::dialect(dialect), block_symbols)
  end

  # 
  # Factors a template instance for a given file, optional dialect (if nil is 
  # passed, the dialect is infered from the extension) and block symbols 
  # (default to :braces)
  #
  # Example:
  #
  #   # the file index.wtpl is a wlang source code in 'wlang/xhtml' dialect 
  #   # (automatically infered from file extension)
  #   template = WLang::template('index.wtpl')
  #   puts template.instantiate(:who => 'world') # puts 'Hello world!'
  #
  # This method raises an ArgumentError
  # * if _file_ does not exists, is not a file or is not readable
  # * if _dialect_ is not a valid qualified dialect name, Dialect instance, or nil
  # * _block_symbols_ is not in [:braces, :brackets, :parentheses]
  #
  # It raises a WLang::Error
  # * if no dialect can be infered from the file extension (if _dialect_ was nil)
  #
  def self.file_template(file, dialect = nil, block_symbols = :braces)
    check_readable_file(file)
    
    # Check the dialect
    dialect = self.infer_dialect(file) if dialect.nil?
    raise WLang::Error, "No known dialect for file extension '#{File.extname(file)}'\n"\
                      "Known extensions are: " << WLang::FILE_EXTENSIONS.keys.join(", ") if dialect.nil?
          
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
  # This method raises an ArgumentError if 
  # * _source_ is not a String
  # * _context_ is not nil or a Hash
  # * _dialect_ is not a valid dialect qualified name or Dialect instance
  # * _block_symbols_ is not in [:braces, :brackets, :parentheses]
  #
  # It raises a WLang::Error
  # * something goes wrong during instantiation (see WLang::Error and subclasses)
  #
  def self.instantiate(source, context = {}, dialect="wlang/active-string", block_symbols = :braces)
    raise ArgumentError, "Hash expected for context argument" unless (context.nil? or Hash===context)
    template(source, dialect, block_symbols).instantiate(context || {}).to_s
  end
  
  #
  # Instantiates a file written in some _wlang_ dialect, using a given _context_
  # (providing instantiation data). If _dialect_ is nil, tries to infer it from the file 
  # extension; otherwise _dialect_ is expected to be a qualified dialect name or a Dialect
  # instance. See instantiate about <tt>block_symbols</tt>.
  #
  # Examples:
  #   Wlang.file_instantiate "template.wtpl", {"who" => "Mr. Jones"}
  #   Wlang.file_instantiate "template.xxx", {"who" => "Mr. Jones"}, "wlang/xhtml"
  #
  # This method raises an ArgumentError if 
  # * _file_ is not a readable file
  # * _context_ is not nil or a Hash
  # * _dialect_ is not a valid dialect qualified name, Dialect instance or nil
  # * _block_symbols_ is not in [:braces, :brackets, :parentheses]
  #
  # It raises a WLang::Error
  # * if no dialect can be infered from the file extension (if _dialect_ was nil)
  # * something goes wrong during instantiation (see WLang::Error and subclasses)
  #
  def self.file_instantiate(file, context = nil, dialect = nil, block_symbols = :braces)
    raise ArgumentError, "Hash expected for context argument" unless (context.nil? or Hash===context)
    file_template(file, dialect, block_symbols).instantiate(context || {}).to_s
  end
  
end
require 'wlang/dialects/standard_dialects'
