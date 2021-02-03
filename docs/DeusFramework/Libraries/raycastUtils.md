# RaycastUtils

All `raycastParams` arguments are optional, if one is not provided the cast will default to one.

## Loading

```lua
local Deus = require(game:GetService("ReplicatedStorage"):WaitForChild("Deus"))
local RaycastUtils = Deus:Load("Deus.RaycastUtils")
```

## cast

```lua
local raycastResult = RaycastUtils.cast(origin, direction, raycastParams)
```

## castCollideOnly

Repeats a raycast adding instances that have CanCollide off to its IgnoreList until the raycast does not hit an instance or the instance is CanCollide on.

```lua
local raycastResult = RaycastUtils.castCollideOnly(origin, direction, raycastParams)
```