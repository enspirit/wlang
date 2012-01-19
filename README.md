# WLang

WLang is a powerful code generation and templating engine.

This is the README of wlang2, a new implementation of the wlang templating language 
based on [temple](https://github.com/judofyr/temple). **It is a work in progress so
far**.

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
tpl = WLang::Mustang.compile("Hello ${who} !")
# => #<WLang::Template:0x007fbc6302f720@<main>:0 (lambda)>

tpl.call(:who => "WLang & World")
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
    buf << instantiate(fn).upcase
  end

end
Upcasing.instantiate("Hello ${world}")
# => "Hello WORLD !"
```
