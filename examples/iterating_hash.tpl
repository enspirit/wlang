---
name:  Bernard Lambeau
hobby: Programming
---
One way to iterate a Hash is as follows:

<table>
  *{self}{
    <tr>
      <td>${first}</td>
      <td>${last}</td>
    </tr>
  }
</table>

Another way would use wlang higher-level constructions:

<table>
  *{keys}{
    <tr>
      <td>${self}</td>
      <td>${!{self}}</td>
    </tr>
  }
</table>
