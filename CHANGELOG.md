# 2.1.0 / FIX ME

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

# 2.0.1 / 2012-06-12

* Fix support for 1.8.7 and jruby (undefined method `ord' for String)

# 2.0.0 / 2012-06-12

* Enhancements

  * Birthday!
