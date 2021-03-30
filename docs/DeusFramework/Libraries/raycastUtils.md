# RaycastUtils

## from

Creates a `RaycastParam` from a dictionary

```lua
local raycastParam = RaycastUtils.from(
    {
        FilterDescendantsInstances = {},
        FilterType = Enum.RaycastFilterType.Blacklist,
        IgnoreWater = false,
        CollisionGroup = "Default"
    }
)
```

## copy

Returns a clone of a provided `RaycastParam`

```lua
local raycastParam = RaycastUtils.copy(raycastParams)
```

## cast

Performs a raycast, if `raycastParams` is not provided it will default to a global `RaycastParam`.

```lua
local raycastResult = RaycastUtils.cast(origin, direction, raycastParams)
```

## castCollideOnly

Repeats a raycast adding instances that have CanCollide off to its IgnoreList until the raycast does not hit an instance or the instance is CanCollide on. If `raycastParams` is not provided it will default to a global `RaycastParam`.

```lua
local raycastResult = RaycastUtils.castCollideOnly(origin, direction, raycastParams)
```