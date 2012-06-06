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

menu_partial: |-
  <ul>
    *{self}{
      <li>${label}</li>
      #{menu}{
        >{menu_partial}
      }
    }
  </ul>
---
Now that we know how to use partials, one might ask how to render a menu in a recursive way. For this, we only need another tag for explicitely manipulating the scope.

* sharp (#) renders its second block, in the scope of the value evaluated in first block

For the example above, our menu rendering is initiated as follows:

    #{menu}{
      >{menu_partial}
    }

Note that it is important to keep empty menus in the source data to avoid infinite recursions due the parent scope that already binds a value under `menu`.
