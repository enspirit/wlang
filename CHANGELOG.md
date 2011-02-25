# Version 0.10.2 / 2011-02-25

* Bug fixes

  * Fixed a bug that led to applying dialect post-transformation too many times in multi 
    block syntaxes. Post-transformation rules related strategies are now:
      - Parser#instantiate now takes an optional boolean argument to set/unset dialect
        post transformation (defaults to true, for backward compatibility). 
      - Invoking Template.instantiate always invoke Parser#instantiate(true)
      - Buffering's <<+{...} always apply post-transformation as well
      - Otherwise, post-transformation is only applied when the dialect explicitely changes
        when invoking Parser#parse and Parser#parse_block

* Other enhancements

  * Added a bluecloth/xhtml dialect and encoder.

# Version 0.10.1 / 2011-01-17

* Bug fixes

  * Fixed a bug when using multi-block syntaxes with another delimiter than braces.

* Other enhancements

  * WLang source code follows the ruby.noe template that comes bundled with Noe

# Version 0.10.0 / 2011-01-14

* New features

  * Introduced a wlang/hosted language which parses blocks as actually described in the specification
  * Introduced a semantics +{...} in wlang/ruby that prints literals.
  * wlang/ruby now includes the Buffering ruleset
  * Introduced a wlang/active-text dialect which includes Basic, Imperative, Buffering and Context rulesets.
  * Introduced a wlang/yaml dialect with special inclusion +{...} operator 

* Broken features and APIs

  * Due to the wlang/ruby <-> wlang/hosted changes and the fact that wlang/ruby now includes the 
    Buffering ruleset, users that generate ruby (a few) may have broken templates and should probably
    be pessimist and require wlang 0.9.x
  * For the same reason, users that make complex wlang meta-constructions ala +{+{...}} could observe
    problems due to the change of +{...} in wlang/ruby. The wlang/hosted dialect is introduced to limit
    such problems, but not encountering them is not guaranteed.

* Other enhancements

  * Moved to rspec 2.4.0
  * Moved from rdoc to yard for generating the documentation
  * README, CHANGELOG and LICENCE are now in Mardown instead of rdoc

# Version 0.9.2

* New features (by order of importance)

  * Implements main transformer on dialects
  * Makes coderay encoders available without options using a bit of meta programming
  * System-local absolute paths (i.e. starting with '/') are recognized by buffer rulesets

# Version 0.9.1

* Bug fixes

  * #307, about HashScope.has_key? which returned nil instead of false in some situations

* Broken features and APIs (by order of importance)

  * HostedLanguage::DSL is strictly private and should be reopened. Methods added to this class
    will never be available in templates. Use HostedLanguage.variable_missing instead. 
  * ::WLang::BasicObject has been removed. HostedLanguage::DSL implements its own strategy, which
    is spec tested in test/spec/basic_object.spec

* New features (by order of importance)

  * WLang does not requires the rdoc gem by default
  * A new encoder redcloth/xhtml allows using Textile markups easily
  * The wlang/xhtml dialect provides a tag helper for links @{...}{...}
  * The parser class returns friendly messages when a rule is ill-implemented

# Version 0.9.0

* Broken features and APIs (by order of importance)

  * Major broken API in WLang.instantiate and WLang.file_instantiate which do not allow passing
    buffers anymore
  * Hash are not methodized by default anymore (major broken feature with 0.8.x versions)
  * Expressions 'a la' PHP w@w (sections/.../.../id) are not supported anymore
  * The default hosted language raises a WLang::UndefinedVariableError when a variable cannot be
    found in the current template scope (0.8.x versions returned nil in this case)
  * Template.initialize does not take a default context anymore
  * WLang::Parser.context_xxx do not exist anymore. Use branch(...) instead
  * WLang::Parser::Context removed, and WLang::HashScope introduced
  * WLang::Parser instance variables are all made protected

* New features (by order of importance)

  * WLang::HostingLanguage introduced, with a default one for Ruby. The hosting language
    is the way to provide a main scope, accessible to all templates at once.
  * WLang::HostingLanguage is not sensitive to the difference between symbol keys and strings
  * Buffering and Context rulesets now branch the current parser instead of creating a new one
  * WLang::Error and subclasses propose a backtrace information
  * WLang::Parser refactored to encapsulate the whole state in another class (WLang::Parser::State)
  * WLang facade has been made much more robust as it now checks all its arguments.
  * WLang::dialect may now be used to ensure dialect instances from both Dialect args and qualified names.
  * Introduction of WLang.template and WLang.file_template
  * plain-text dialect proposes new camel-based encoders
  * wlang/active-string dialect has the imperative rule set included
  * sql dialect has been added
  * ruby dialect proposes a method-case encoder

# Version 0.8.5

* Enhances error messages a lot
* Some bug fixes for ruby 0.8.7

# Version 0.8.4

* Migration from svn.chefbe.net to github.com

# Version 0.8.0

* First public version