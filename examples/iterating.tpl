---
people:
  - name: Bernard Lambeau
    hobbies:
    - Programming
    - Guitar
  - name: Louis Lambeau
    hobbies:
    - Programming
    - Bass
---
<ul>
  *{people}{
    <li>${name}</li>
    <ul>
      *{hobbies}{
        <li>${self}</li>
      }
    </ul>
  }
</ul>
