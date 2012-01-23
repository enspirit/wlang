---
people:
  - name: Bernard Lambeau
    hobbies:
    - name: Programming
    - name: Guitar
  - name: Louis Lambeau
    hobbies:
    - name: Programming
    - name: Bass
---
<html>
<body>
  <ul>
    *{people}{
      <li>${name}</li>
      <ul>
        *{hobbies}{
          <li>${name}</li>
        }
      </ul>
    }
  </ul>
</body>
</html>
