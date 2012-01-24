---
menu:
  - label: About
    menu: []
  - label: Products
    menu: 
    - label: WLang
      menu: []
    - label: Alf
      menu: []
    - label: Viiite
      menu: []
menu_view: |-
  <ul>
    *{self}{
      <li>${label}</li>
      #{menu}{
        >{menu_view}
      }
    }
  </ul>
---
#{menu}{
  >{menu_view}
}
