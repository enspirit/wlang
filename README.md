# WLang

[![Run Tests](https://github.com/enspirit/wlang/actions/workflows/integration.yml/badge.svg?branch=master)](https://github.com/enspirit/wlang/actions/workflows/integration.yml)

WLang is a powerful code generation and templating engine, implemented on top o
[temple](https://github.com/judofyr/temple) and much inspired by the excellent
[mustache](http://mustache.github.com/).

## Links

* http://github.com/blambeau/wlang
* http://rubygems.org/gems/wlang
* http://revision-zero.org/wlang

## Features

* Tunable templating engine. You can define your own tags, and their behavior.
* Powerful logic-less HTML concretization to render web pages à la Mustache
  with extra.
* Compiled templates for speedy generation.

WLang 3.0 also has a few remaining issues.

* It has some issues with spacing; not a big issue for HTML rendering but might
  prevent certain generation tasks.

## Tunable templating engine

WLang is a templating engine, written in ruby. In that, it is similar to ERB,
Mustache and the like:

```ruby
WLang::Html.render 'Hello to ${who}!', who: 'you & the world'
# => "Hello to you &amp; the world!"
```

To output HTML pages, WLang does not provides you with killer features or
extraordinary shortcus. It supports escaping, as shown above, but many other
templating engines do. For such HTML tasks, WLang does a pretty good job but
many other engines perform faster and have nicer features. See the examples
folder that documents WLang::Html.

WLang is designed to help you for other uses cases, user-defined ones in
particular, such as generating code or whatever text generation task for
which other engines quickly become inappropriate. WLang helps there because
it allows you to create your own _dialect_, that is, you can define your own
tags and their behavior. For instance,

```ruby
class Highlighter < WLang::Dialect

  def highlight(buf, fn)
    var_name  = render(fn)
    var_value = evaluate(var_name)
    buf << var_value.to_s.upcase
  end

  tag '$', :highlight
end
Highlighter.render('Hello ${who}!', who: 'you & the world')
# => "Hello YOU & THE WORLD !"
```

WLang already provides a few useful dialects, such as WLang::Html
(inspired by Mustache but a bit more powerful in my opinion). If they don't
match your needs, it is up to you to define you own dialect for making your
generation task easy. Have a look at the implementation of WLang's ones, it's
pretty simple to get started!

# Tilt integration

WLang has built-in support for [Tilt](https://github.com/rtomayko/tilt) facade to templating engines. In order to use that API:

```ruby
require 'tilt'         # needed in your bundle, not a wlang dependency
require 'wlang'        # loads Tilt support provided Tilt has already been required

template = Tilt.new("path/to/a/template.wlang")   # suppose 'Hello ${who}!'
template.render(:who => "world")
# => Hello world!

template = Tilt.new("path/to/a/template.wlang", :dialect => Highlighter)
template.render(:who => "world")
# => Hello WORLD!
```

Please note that you should require tilt first, then wlang. Otherwise, you'll have to require `wlang/tilt` explicitely.

# Sinatra integration

WLang comes bundled with built-in support for [Sinatra](https://github.com/sinatra/sinatra) >= 1.4 (release still in progress). As usual in Sinatra, you can simply invoke wlang as follows:

```ruby
get '/' do
  wlang :index, :locals => { ... }
end
```

As wlang encourages logic-less templates, you should always use locals. However, there is specific support for layouts and partials, as the following example demonstrates:

```ruby
get '/' do
  wlang :index, :locals => {:who => "world"}
end

__END__

@@layout
  <html>
    >{yield}
  </html>

@@index
  Hello from a partial: >{partial}

@@partial
  yeah, a partial saying hello to '${who}'!

Returned body will be (ignoring carriage returns):

<html>Hello from a partial: yeah, a partial saying hello to 'world'!</html>
```
