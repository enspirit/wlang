# The WLang::Html dialect

This folder contains annotated examples of wlang templates. All examples use the WLang::Html dialect in particular, providing its basic documentation.

The example files contain a YAML front-matter which is needed to understand the explanations and to render the templates (I say so because the .md files do not render very properly on github due to the front matter).

The various example files are intended to be read *and* instantiated with the wlang command line tool:

    wlang --auto-spacing examples/1-basics.md

WLang 2.0.0.beta has some remaining issues about the way it handles spacing. For HTML rendering, this is not necessarily a big issue but it might slightly complicate your learning. Please apologize.
