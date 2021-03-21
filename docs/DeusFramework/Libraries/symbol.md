# Symbol

All symbols of the same name return the same userdata. Symbol is most often used to represent `nil` in tables.

## new

Creates a symbol for a given string or returns the symbol for that string if one already exists.

```lua
local None = Symbol.new("None")
```

!!! example

    === "Script"

        ```lua
        print(Symbol.new("None") == Symbol.new("None"))

        print(Symbol.new("None") == Symbol.new("none"))
        ```

    === "Output"

        ```
        true
        false
        ```