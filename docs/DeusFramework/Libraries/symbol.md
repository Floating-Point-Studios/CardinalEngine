# Symbol

Symbols are `userdata` represented by a name. Global symbols are created or obtained through `Symbol.get()` while Nonglobal symbols are created through `Symbol.new()`. Global and nonglobal symbols will not return the same if compared even if they have the same name.

## new

Creates a symbol for a given string.

```lua
local None = Symbol.new("None")
```

!!! example

    === "Script"

        ```lua
        print(Symbol.new("None") == Symbol.new("None"))

        local None = Symbol.new("None")
        print(None == None)
        ```

    === "Output"

        ```
        false
        true
        ```

## get

Creates a symbol for a given string or returns the symbol for that string if one already exists.

```lua
local None = Symbol.get("None")
```

!!! example

    === "Script"

        ```lua
        print(Symbol.get("None") == Symbol.get("None"))

        print(Symbol.get("None") == Symbol.new("None"))
        ```

    === "Output"

        ```
        true
        false
        ```