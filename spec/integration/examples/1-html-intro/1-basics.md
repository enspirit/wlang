# Three basic tags: bang, plus and dollar

Three special tags, bounded to the !, +, $ symbols allow injecting dynamic content. The difference between them is:

* bang   (!) renders the result of invoking `to_s` on the evaluated expression (see later),
* plus   (+) first tries to render the value through a `to_html` method and falls back to `to_s`
* dollar ($) escapes html entities of the content that would be returned by +.

We do not illustrate the difference between ! and + here, as it is only only useful for already advanced scenarios. The idiomatic way of using WLang::Html is to avoid ! unless strictly needed, to consider + as unsafe but useful, and $ as safe and to use it by default.

Users that know Mustache can remember that $ corresponds to {{ ... }} whereas + corresponds to {{{ ... }}}, which some powerful extras (not shown here). For example,

    Hello &lt;script&gt;injected code&lt;&#47;script&gt; !

is clearly safe (instantiate the example to convince yourself), but the following one:

    Hello <script>injected code</script> !

is not safe, unless the `who` variable contains content that you can trust and which must not be escaped.

The WLang::Html dialect encourages logic-less templates, but is not as strict as Mustache.  Indeed, all tags that rely on some form of variable evaluation (the three above in particular), actually allow simple expressions, restricted to argument-less getters however:

    Hello wlang, released in 2012!

# Ampersand as an introduction to high-level constructs

A fourth basic tag is sometimes useful, and allows me to introduce higher-level wlang constructs.

* ampersand (&) escapes raw html content. It does not evaluate any expression.

For example, the following expression

    &lt;script&gt;some attacker attempt to inject code&lt;&#47;script&gt;

will simply escape its html content.

Given the WLang functional semantics and the & and ! tags, one can see + and $ as shortcuts for longer expressions. For instance,

    &lt;script&gt;injected code&lt;&#47;script&gt; is a shortcut for the equivalent expression &lt;script&gt;injected code&lt;&#47;script&gt;

We'll come back to higher-level constructs in other examples later. For now, let just introduce some additional bacic tags.

# Slash for comments

The slash tag is used for comments. It simply renders nothing at all.

* slash (/) can be used for comments.

For instance,

    

And,

# Modulo to disengage wlang

The last useful tag allows you to simply disable wlang rendering in specific template portions. For this, use the modulo tag:

* modulo (%) disables wlang inside its block.

For instance, the following template renders the block text unchanged, even if it contains wlang tags:

     Hello ${struct.name}, how are you? 

This is especially useful for writing blog posts explaining wlang, using wlang itself. Therefore, it is a feature mostly needed by me ;-)
