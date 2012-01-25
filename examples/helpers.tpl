---
hobbies:
  - Programming
  - Guitar
ulli: |-
  <ul>
    *{self}{
      <li>${self}</li>
    }
  </ul>
---
#{hobbies}{
  >{ulli}
}
