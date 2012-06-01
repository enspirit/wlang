---
true_value: true
false_value: false
nil_value: ~
string_value: 'hello'
vart: 'true'
varf: 'false'
authors:
  - name: Bernard
  - name: Louis
---
# Introduction

WLang inspires from Mustache and encourages you to write logic-less templates. It does not mean that imperative constructions are not needed. Iterations and conditional sections, in particular are definitely something required.

## Conditional and inverted sections

* question (?) provides a if-then-else section, with optional else
* caret    (^) provides a if-else-then section, with optional then

The boolean evaluation is based on Ruby's conditions and has the same semantics: nil and false are FALSE, all other values are TRUE. For instance,

    'Hello ?{true_value}{TRUE}{FALSE}'   renders as 'Hello TRUE'
    'Hello ?{string_value}{TRUE}{FALSE}' renders as 'Hello TRUE'
    'Hello ?{false_value}{TRUE}{FALSE}'  renders as 'Hello FALSE'
    'Hello ?{nil_value}{TRUE}{FALSE}'    renders as 'Hello FALSE'

For inverted sections,

    'Hello ^{true_value}{TRUE}{FALSE}'   renders as 'Hello FALSE'
    'Hello ^{string_value}{TRUE}{FALSE}' renders as 'Hello FALSE'
    'Hello ^{false_value}{TRUE}{FALSE}'  renders as 'Hello TRUE'
    'Hello ^{nil_value}{TRUE}{FALSE}'    renders as 'Hello TRUE'

In both cases, the first block relies on an expression evaluation and therefore allows dotted expressions (see 1-basics.md), while also recognizing high-level constructs. Also, the third block is optional. As an example,

    'Hello ?{!{vart}_value}{world}' renders as 'Hello world' if `vart` contains 'true'

whereas,

    'Hello ?{!{varf}_value}{world}' renders as 'Hello ' if `varf` contains 'false'

As usual, use it with parcimony and care but enjoy its powerfulness.

## Iterations

A special tag allows you to perform simple iterations. More accurately, the star allows you to render a block for each value of a sequence, joining the results with an optional separator:

* star (*) joins the rendering of its second block for each element of a sequence

For instance,

    <ul>
      *{authors}{
        <li>${name}</li>
      }
    </ul>

Renders an HTML list with the authors names. A separator can be specified through the third optional block:

    *{authors}{${name}}{, }

Will render 'Bernard, Louis'.
