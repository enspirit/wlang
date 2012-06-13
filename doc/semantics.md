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

