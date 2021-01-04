# 3.0.0 / 2020-12-29

* Clean project to use a standard ruby-2.7 stack
* Upgrade citrus to 3.x

# 2.2.4 / 2014-07-29

* Birthday of 2.2.3 :-)
* Under sinatra all partials now use the app.settings base options. Specified
  dialect is in particular reused accross partials.

# 2.2.3 / 2013-07-29

* Bump Temple dependency to "~> 0.6"

# 2.2.2 / 2013-05-10

* Avoid creating empty scopes if not necessary (sinatra/tilt integration)

# 2.2.1 / 2013-04-29

* Enhanced Scope#to_s for readability of error messages.
* Fix >{...} where the Html dialect is subclassed, the partial is not
  correctly compiled with the subclass.
* Fixed a bug when YAML front matter is empty in templates.

# 2.2.0 / 2013-03-05

* Added ATTR/VALUE pairs to the wlang command line tool, for passing data to templates
  in an easy way.

# 2.1.2 / 2012-01-15

* Add backquote as supported tag symbol

# 2.1.1 / 2012-11-29

* Bump epath to path 1.3.1 (same gem but renamed + bump)
* Moved awesome_print to extra dependencies (not a proper dependency then!)

# 2.1.0 / 2012-11-28

## Enhancements

* The scoping mechanism has been clarified and enhanced (mostly private APIs).
  In particular,
  * Template#render and Dialect#render now accepts multiple scoping objects and chain them
    as a unique scope. The latter is branched with template locals, which are always the
    most-specific and therefore have highest priority.
  * RootScope as been renamed to NullScope, Scope.root to Scope.null accordingly
  * ProxyScope has been removed to keep scopes linear chains.

* Added Dialect#context, which allows knowing the subject of the less specific scope, that
  is the first argument of Dialect#render and Template#render. In Sinatra/Tilt situation,
  this simply correspond to the `scope`, typically the Sinatra app.

* Dialect#evaluate (through Scope#evaluate) now accepts an optional block for specifying
  a computed default value instead of failing.

* WLang::Html partial tag >{...} now recognizes a Proc and simply renders the result of
  calling it. This allows to use >{yield} in layouts instead of the less idomatic +{yield}.

## Bug fixes

* Fixed a bug when parsing "hello {  ${wlang} }" constructs (typically javascript or java)
  (wlang inner constructions was not properly parsed)

# 2.0.1 / 2012-06-12

* Fix support for 1.8.7 and jruby (undefined method `ord' for String)

# 2.0.0 / 2012-06-12

* Enhancements

  * Birthday!
