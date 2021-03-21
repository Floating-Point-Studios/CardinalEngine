# MouseUtils

## Loading

```lua
local MouseUtils = Deus:Load("Deus.MouseUtils").new()
```

## getTargetAtPosition

Returns `Instance` at screen `x` and `y` coordinates or `nil` if raycast fails. Uses `Enum.FilterType` and a `table` for filterDescendantsInstances to control raycast.

```lua
local target = MouseUtils.getTargetAtPosition(x, y, filterType, filterDescendantsInstances)
```

## getGuiObjectsAtPositionWithWhitelist

Returns `GuiObjects` in `filter` if `GuiObjects` are at screen `x` and `y` coordinates. If `recursive` is enabled will count descendants of `filter` as part of whitelist.

```lua
local guiObjects = MouseUtils.getGuiObjectsAtPositionWithWhitelist(x, y, filter, recursive)
```