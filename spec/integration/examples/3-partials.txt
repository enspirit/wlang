# Partials

Partials allows defining templating sections in external variables, such as the `hobby_entry_partial` variable above. The greater tag allows you to instantiate those partials:

* greater (>) renders the partial denotes by an expression in the current scope

For instance,

    <ul>
      <li><a href="http:&#47;&#47;reddit.com&#47;r&#47;programming">Programming</a></li>
      <li><a href="http:&#47;&#47;www.music.me&#47;">Music</a></li>
    </ul>

will generate the hobby list with a link for each of my hobbies. As the scope inside the iteration is based on the currently iterated element, the hobby label and url are accessible inside the partial itself.

# Advanced scoping example

Suppose that, in the example above, you dont statically know what are the keys of an hobby hash. For instance, for each hobby you want to display an HTML table with every (key,value) pair. You could try something like this:

    <ul>
      <table>
  <tr>
    <th>key</th>
    <th>value</th>
  </tr>
  <tr>
    <td>label</td>
    <td>Programming</td>
  </tr>
  <tr>
    <td>url</td>
    <td>http:&#47;&#47;reddit.com&#47;r&#47;programming</td>
  </tr>
</table>
      <table>
  <tr>
    <th>key</th>
    <th>value</th>
  </tr>
  <tr>
    <td>label</td>
    <td>Music</td>
  </tr>
  <tr>
    <td>url</td>
    <td>http:&#47;&#47;www.music.me&#47;</td>
  </tr>
</table>
    </ul>

The `hobby_entry_table` partial above iterates the hobby hash through `self`. Following ruby's `Hash#each` The scope inside that iteration is therefore an array of two elements, accessible under `first` and `last`.

Another way, that uses wlang higher-level constructions, could be as follows:

    <ul>
      <table>
  <tr>
    <td>label</td>
    <td>Programming</td>
  </tr>
  <tr>
    <td>url</td>
    <td>http:&#47;&#47;reddit.com&#47;r&#47;programming</td>
  </tr>
</table>
      <table>
  <tr>
    <td>label</td>
    <td>Music</td>
  </tr>
  <tr>
    <td>url</td>
    <td>http:&#47;&#47;www.music.me&#47;</td>
  </tr>
</table>
    </ul>
