# WLang

WLang is a powerful code generation and templating engine.

This is the README of wlang2, a fresh new implementation of the [wlang templating language concept](http://revision-zero.org/wlang), this one implemented on top of [temple](https://github.com/judofyr/temple) and much inspired by the excellent [mustache](http://mustache.github.com/). (For users of wlang 1.0 (formaly 0.10.2), this rewrite cleans most concepts as well as the abstract wlang semantics; it also uses a simple compiler architecture to gain huge perfomance gains in comparison to early wlang days).

**WLang2 is a work in progress so far**.

## Links

* http://github.com/blambeau/wlang
* http://blambeau.github.com/wlang
* http://rubygems.org/gems/wlang
* http://revision-zero.org/wlang

## Abstract semantics

WLang is a templating engine with a powerful semantics in terms of concatenation
of strings and high-order functions (i.e. functions that take other functions as
parameters). Let take the following template as an example:

```
Hello ${who} !
```

The functional semantics of this template is as follows:

```clojure
(fn (concat "Hello", ($ (fn "who")), " !"))
```

That is, the compilation of this template yields a function that concatenates the
string `"Hello"` with the result of the higher-order function `($ )` and then the
string `" !"`. Providing a concrete semantics to those high-order functions yields 
so called WLang _dialects_.

## Example: the Mustang dialect

The `WLang::Mustang` dialect mimics the excellent [Mustache](http://mustache.github.com/) 
templating language by providing similar tags, such as `$`, `+`, `#`, `^`, etc.

Mustache's `{{...}}` is available as `${...}` as illustrated below:

```ruby
WLang::Mustang.render("Hello ${who} !", :who => "WLang & World")
# => "Hello WLang &amp; World !"
```

In this example,

* the high-order function `($ )` is of arity 1 (it takes a single argument, which 
  is another function)
* `($ )` calls its first argument, and receives the string `"who"`
* it evaluates `who` in the current scope and receives the string `"WLang & World"`
* it escapes that string for HTML and returns the result

See the documentation of the WLang::Mustang class for more information about this powerful
dialect.

## Creating your own dialect

One of the most powerful features of WLang is that creating you own dialect is very simple. 
Let take an example:

```ruby
class Upcasing < WLang::Dialect

  tag '$' do |buf, fn|
    buf << render(fn).upcase
  end

end
Upcasing.render("Hello ${world}")
# => "Hello WORLD !"
```
