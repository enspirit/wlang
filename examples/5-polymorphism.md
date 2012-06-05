---
data:
  - {shape: square, width: 10}
  - {shape: circle, diameter: 25}
partials:
  square: |-
    Hello [] of width ${width}cm
  circle: |-
    Hello () of diameter ${diameter}cm
---
Sometimes, you want to apply polymorphism to your templates; this it is really easy to do in wlang thanks to its high-order constructions.

For example, assume that you iterate some data and want render a partial in a polymorphism way, that is, selecting the partial according to some type, here the shape of the current iterated component. This is really simple:

    <ul>
      *{data}{
        <li> >{partials.!{shape}} </li>
      }
    </ul>

Which gives the following result:

    <ul>
      <li> Hello [] of width 10cm </li>
      <li> Hello () of diameter 25cm <li>
    </ul>

Great, isn't?