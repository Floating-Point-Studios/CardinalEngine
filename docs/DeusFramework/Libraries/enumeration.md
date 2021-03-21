# Enumeration

Behaves like `Enum` and can be indexed for `EnumItems`

 ## addEnumItem

 ```lua
Enumeration.addEnumItem("EnumName", "EnumItemName", number)
```

 ## addEnum

```lua
Enumeration.addEnum("EnumName", {
    EnumItemName = number
})
```

 ## waitForEnum

Yields for 3 seconds before erroring

 ```lua
local enum = Enumeration.waitForEnum("EnumName")
 ```