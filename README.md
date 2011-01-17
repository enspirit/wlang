# What is _wlang_ ?

WLang is a general-purpose *code generation*/*templating engine*. It's main aim is to help you generating
web pages, sql queries, ruby code (that is, generating code in general) without having to worry too much 
about html entities encoding, sql back quoting, string escaping and the like. WLang proposes a generic 
engine that you can extend to fit your needs. It also proposes standard instantiations of this engine 
for common tasks such as creating SQL queries, instantiating web pages, and so on.

Basic concepts and usage is illustrated below. Also have a look at the [detailed specification](http://blambeau.github.com/wlang).

## A collection of typical encoders

The first basic usage of WLang is to provide a collection of text encoders:

    WLang::encode('&',      'xhtml/entities-encoding')      # &amp;
    WLang::encode("O'Neil", 'sql/single-quoting')           # O\'Neil   
    WLang::encode("O'Neil", 'sql/sybase/single-quoting')    # O''Neil   
    ...
    WLang::encode("hello world",  'plain-text/camel')        # HelloWorld  
    WLang::encode("hello world",  'plain-text/lower-camel')  # helloWorld  
    ...
    WLang::encode("helloWorld",   'ruby/method-case')        # hello_world
  
## A powerful alternative to ruby string interpolation

The second usage is to have shortcuts for using these encoders in typical 
situations:

    # Hello world!
    "Hello ${who}!".wlang(:who => 'world')                          

    # Hello cruel &amp; world!
    "Hello ${who}!".wlang({:who => 'cruel & world'}, 'wlang/xhtml') 
  
    # Hello blambeau, llambeau
    "Hello *{authors as a}{${a}}{, }".wlang(:authors => ['blambeau', 'llambeau'])
  
    # INSERT INTO people VALUES ('O\'Neil')
    INSERT INTO people VALUES ('{who}')".wlang(:who => "O'Neil")

## A powerful templating engine

But the main usage of _wlang_ is as follows (for bold words, see terminology later): 
you have a *template* file (written in a given _wlang_ *dialect*), you have some 
instantiation *context* (data provided through a Ruby Hash or a yaml file for 
example) and you would like to instantiate the template with that data.

Example: a template.whtml as follows
    <html>
      <head>
        <title>${title}</title>
      </head>
      <body>
        <h1>Hello ${who} !</h1>
      </body>
    </html>
  
Instantiation data is a hash containing values for _title_ and _who_. Instantiating 
the template is straightforward:

    require 'wlang'
    context = {"title" => "Hello world in WLang", "who" => "Alice"}
    STDOUT << WLang.file_instantiate("template.whtml", context)
  
## Behind the scene

- WLang helps you avoiding SQL injection and XSS attacks through the same tags reacting differently
  in different contexts.
- WLang understands your context (and its dialect) from the template file extension
- WLang provides a rich collection of pre-defined tags and dialects
- WLang allows you to create your own encoders, tags and dialects while reusing existing ones
- WLang may change the current dialect during the template instantiation itself (generating
  html with embedded javascript is easy and natural)
- WLang is able to generate wlang code without any perturabation

## Additional examples (availability of the tags may depend on the dialect)

* Include text files on the fly

      <<{my_file.html}

* Instantiate sub-templates on the fly, passing data as arguments

      <<+{my_sub_template.whtml using who: 'wlang'}

* Load data from yaml or ruby files on the fly

      <<={resources.yaml as resources}{
        *{resources as r}{ ${r} }
      }

* WLang instrospection (basic example)

      context = {:varname => 'who', :who => 'wlang'}
      "Hello ${${varname}}!".wlang(context)                     # => Hello wlang!

* Generate a wlang template and instantiate it after that
    
      dialect = 'wlang/active-string'
      tpl = "Hello $(${varname})!"                              # => Hello $(${varname})
      tpl = tpl.wlang(:varname => 'who')                        # => Hello $(who)!
      tpl = tpl.wlang({:who => 'wlang'}, dialect, :parentheses) # => Hello wlang!

## Roadmap

- For terminology and a quick overview of _wlang_ for generating code, read on.
- For the current cheatsheet/specification see the file doc/specification/specification.html
- If you want to learn _wlang_ quickly, see the example directory or read examples
  in the specification file (if you understand all examples in the specification file, then you 
  probably master wlang.
- If you want a killer example (but simple) see the way the specification.html file
  is generated in doc/specification directory
- If you want to know which dialects are available (that is, in which target languages 
  you can generate code), see the specification as well or read the file 
  lib/wlang/dialects/standard_dialects.rb in the source distribution.
- If you want to create your own wlang dialect, see WLang::Dialect::DSL
- If you think that your own dialect is of generic purpose and well-designed, if
  you have any question or want to contribute join us on {github}[http://github.com/blambeau/wlang].
  
## Terminology

_wlang_ comes with a well-defined terminology for the underlying abstractions. As 
the documentation uses it, you'll probably be happy to learn about the main abstractions
and associated terms.

_template_ : Source code respecting the wlang grammar, and attached to a given <em>wlang 
dialect</em>. Asbtraction implemented by WLang::Template.

_dialect_ : Basically, <em>dialect</em> is used as a synonym for (programming) <em>language</em>.
However _wlang_ uses a tree of dialects, allowing specializations: <tt>sql/sybase</tt>
for example is the qualified name of a sub-dialect 'sybase' of the 'sql' dialect. 
Dialects come with associated _encoders_. Abstraction implemented by WLang::Dialect. 

_wlang dialect_ : When we talk about a <em>wlang dialect</em>, we are actually refering to some 
specialization of the wlang tag-based grammar: <tt>wlang/xhtml</tt> for example
is the templating language _wlang_ proposes to generate xhtml pages. An 
example of source code in that dialect has been shown before.
In addition to its encoders a <em>wlang dialect</em> comes with its sets of _tags_ 
and associated _rules_. Abstraction implemented by WLang::Dialect as well as
WLang::EncoderSet and WLang::RuleSet. 

_encoder set_ : Reusable set of <em>encoders</em>, attached to a dialect. Abstraction
implemented by WLang::EncoderSet.

_encoder_ : Text transformation (algorithm) applying some encoding conventions of a portion
of a the target language generated by a dialect. HTML entities-encoding, SQL's back-quoting 
are examples of encoders. Encoders are accessible through their qualified name: 
xhtml/entities-encoding and sql/back-quoting in the examples. Abstraction implemented by 
WLang::Encoder.

_ruleset_ : Reusable set of <em>tags</em> associated to <em>rule</em>s. Abstraction
implemented by WLang::RuleSet.

_wlang tag_ : Special tags in the template, starting with wlang symbols and a number of wlang 
blocks. A tag is associated with a wlang rule. Examples: <tt>${...}</tt> is a 
tag with only one block, while <tt>?{...}{...}{...}</tt> is another tag but with 
three blocks.  

_rule_ : Transformation semantics of a given <em>tag</em>. When wlang instantiates a
template it simply replaces <em>wlang tags</em> by some <em>replacement value</em>
(which is always a string). This value is computed by the rule attached to 
the tag. Rule definition explicitly describes the number of blocks it expects, in which dialect they 
are parsed and instantiated and the way the replacement value is computed.
Example: <tt>^{wlang/active-string}{...}</tt> (also known as 'encoding') 
instantiates #1, looking for an encoder qualified name. Instantiates #2 in 
the current dialect. Encode #2's instantiation using encoder found in (#1)

_context_ : Some rules allow code to be executed in the <em>hosting language</em> (the 
definition explicitly announce it by putting <tt>wlang/hosted</tt> in the corresponding
block). When doing so, this code is in fact executed in a given context that 
provides the execution semantics. Abstraction implemented in WLang::Parser::Context.

_hosting language_ : language (or framework) that executes wlang. In this case, it will be
<tt>ruby</tt>.