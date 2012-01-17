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

## What is wlang?

WLang is a templating engine with a powerful semantics in terms of concatenation
of strings and high-order functions (i.e. functions that take other functions as
parameters). Let take the following template as an example:

```
Hello ${who} !
```

The functional semantics of this template is as follows:

```
(fn (concat "Hello", ($ (fn "who")), " !"))
```

That is, the compilation of this template yields a function that concatenates the
string `"Hello"` with the result of the higher-order function `($ )` and then the
string `" !"`.

```
tpl = WLang::Html.compile("Hello ${who}")
# => #<Proc:0x8865d64@(irb):4 (lambda)>

tpl.call(:who => "WLang & World")
# => "Hello WLang &amp; World !"
```

### High-order functions and Dialects

High-order functions provide the semantics of the template tags. In the Html example 
above:

* the high-order function `($ )` is of arity 1 (it takes a single argument, which 
  is another function)
* `($ )` calls its first argument, and receives the string `"who"`
* it evaluates `who` in the current scope and receives the string `"WLang & World"`
* it escapes that string for HTML and returns the result

A set of high-order functions mapped to tags is called a _Dialect_, such as 
`WLang::Html`. One of the nice features of WLang is that creating you own dialect is
very simple. Let take an example:

```
class Upcasing < WLang::Dialect

  tag '$' do |fn|
    fn.call(self, "").upcase
  end

end
tpl = Upcasing.compile("Hello ${who}")
tpl.call(:who => "WLang & World")
# => "Hello WLANG & WORLD !"
```

