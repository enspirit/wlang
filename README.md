# WLang

[![Build Status](https://secure.travis-ci.org/blambeau/wlang.png?branch=wlang2)](http://travis-ci.org/blambeau/wlang)

WLang is a powerful code generation and templating engine.

This is the README of wlang2, a fresh new implementation of the [wlang templating language concept](http://revision-zero.org/wlang), this one implemented on top of [temple](https://github.com/judofyr/temple) and much inspired by the excellent [mustache](http://mustache.github.com/). (For users of wlang 1.0 (formaly 0.10.2), this rewrite cleans most concepts as well as the abstract wlang semantics; it also uses a simple compiler architecture to gain huge perfomance gains in comparison to early wlang days).

**WLang2 is work in progress**. It does not support rubinius so far, due to an incompatibility with the Citrus parser generator. It also have some issues with spacing; not a big issue for HTML rendering but might prevent certain generation tasks.

## Links

* http://github.com/blambeau/wlang
* http://blambeau.github.com/wlang
* http://rubygems.org/gems/wlang
* http://revision-zero.org/wlang

## A user-defined templating engine

WLang is a templating engine, written in ruby. In that, it is similar to ERB, Mustache and the like:

```ruby
WLang::Html.render 'Hello to ${who}!', who: 'you & the world'
# => "Hello you &amp; the world!"
```

To output HTML pages, WLang does not provides you with killer features or extraordinary shortcus. It supports escaping, as shown above, but many other templating engines do. For such HTML tasks, WLang does a pretty good job but many other engines perform faster and have nicer features. See the examples folder that documents WLang::Html.

WLang is designed to help you for other uses cases, user-defined ones in particular, such as generating code or whatever text generation task for which other engines quickly become inappropriate. WLang helps there because it allows you to create your own _dialect_, that is, you can define your own tags and their behavior. For instance,

```ruby
class Highlighter < WLang::Dialect

  def highlight(buf, fn)
    var_name  = render(fn)
    var_value = evaluate(var_name)
    buf << var_value.to_s.upcase
  end

  tag '$', :highlight
end
Highlighter.render('Hello ${who}!'), who: 'you & the world'
# => "Hello YOU & THE WORLD !"
```

WLang already provides a few useful dialects, such as WLang::Html (inspired by Mustache but a bit more powerful in my opinion). If they don't match your needs, it is up to you to define you own dialect for making your generation task easy. Have a look at the implementation of WLang's ones, it's pretty simple to get started!

## Abstract semantics

WLang has a powerful semantics in terms of concatenation of strings and high-order functions (i.e. functions that take other functions as parameters). Let take the following template as an example:

```
Hello ${who} !
```

The functional semantics of this template is as follows:

```clojure
(fn (concat "Hello", ($ (fn "who")), " !"))
```

That is, the compilation of this template yields a function that concatenates the
string `"Hello"` with the result of the higher-order function `($ )` (that itself takes another function as a parameter, corresponding to the sub-template in its brackets delimited blocks) and then the string `" !"`. Providing a concrete semantics to those high-order functions yields so called WLang _dialects_, as we've seen before.

Having a well-defined semantics allows wlang to properly compile your user-defined dialect and its instantiation engine so as to preserve decent performances. The WLang architecture is a typical compiler chain. This means that, provided some additional coding, you could even define your own language/syntax and reuse the compilation mechanism, provided that you preserve the semantics above.

## Higher-order constructs

A feature that distinguishes WLang from most templating engines is the fact that higher-level constructions are permitted. In addition to tag functions that accept multiple arguments, thus multiple blocks in the source text, those blocks may be complex templates themselves.

For instance, the following behavior is perfectly implementable:

```ruby
HighLevel.render 'Hello *{ ${collection} }{ ${self} }{ and } !',
                 collection: 'whos', whos: [ "you", "wlang", "world" ]
# => "Hello you and wlang and world"
```

An implementation of `HighLevel` might be as follows:

```ruby
class HighLevel < WLang::Dialect

  def join(buf, expr, main, between)
    evaluate(expr).each_with_index do |val,i|
      buf << render(between, val) unless i==0
      buf << render(main, val).strip
    end
  end

  def print(buf, fn)
    buf << evaluate(fn).to_s
  end

  tag '*', :join
  tag '$', :print
end
```

Use at your own risk, though, as it might lead to dialects that are difficult to understand and/or use and present serious injections risks! Otherwise, higher-order constructions provides you with very powerful tools.

# Tilt integration

WLang 2.0 has built-in support for [Tilt](https://github.com/rtomayko/tilt) facade to templating engines. In order to use that API:

```ruby
require 'tilt'         # needed in your bundle, not a wlang dependency
require 'wlang/tilt'   # load wlang integration specifycally

template = Tilt.new("path/to/a/template.wlang")   # suppose 'Hello ${who}!'
template.render(:who => "world")
# => Hello world!

template = Tilt.new(hello_path.to_s, :dialect => Highlighter)
template.render(:who => "world")
# => Hello WORLD!
```