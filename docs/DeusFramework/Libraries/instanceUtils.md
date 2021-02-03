# InstanceUtils

## Loading

```lua
local Deus = require(game:GetService("ReplicatedStorage"):WaitForChild("Deus"))
local InstanceUtils = Deus:Load("Deus.InstanceUtils")
```

## anchor

Recursive anchor function.

```lua
-- This anchors everything in the workspace
InstanceUtils.anchor(workspace, true)

-- This unanchors everything in the workspace
InstanceUtils.anchor(workspace, false)
```

## getAncestors

Returns all ancestors.

!!! example
    === "Script"

        ```lua
        print(InstanceUtils.getAncestors(workspace.Baseplate))
        ```

    === "Output"

        Depending on the name of your studio file it may not appear as "Baseplate"

        ```
        {
            Workspace,
            Baseplate
        }
        ```

## findFirstAncestorWithName

Returns first ancestor with matching name.

!!! example
    === "Script"

        ```lua
        print(InstanceUtils.findFirstAncestorWithName(workspace.Baseplate, "Workspace") == workspace)
        ```

    === "Output"

        ```
        true
        ```

## findFirstChildNoCase

Similar to `FindFirstChild` but disregards case sensitivity.

```lua
InstanceUtils.findFirstChildNoCase(instance, name, recursive)
```

## findFirstChildWithAttribute

Similar to `FindFirstChild` but checks for [attributes](https://devforum.roblox.com/t/new-studio-beta-attributes/984141).

```lua
InstanceUtils.findFirstChildWithAttribute(instance, attributeName, recursive)
```

## findFirstAncestorWithAttribute

Similar to `findFirstChildWithAttribute` but checks for ancestors.

```lua
InstanceUtils.findFirstAncestorWithAttribute(instance, attributeName)
```

## setAttributes

Sets multiple attributes at once.

```lua
InstanceUtils.setAttributes(
    workspace.Baseplate,
    {
        attribute1 = true,
        attribute2 = 2,
        attribute3 = "foobar"
    }
)
```

## isTypeAttributeSupported

Returns if a data type can be set as an attribute.

!!! example
    === "Script"

        ```lua
        print(InstanceUtils.isTypeAttributeSupported("nil"))
        print(InstanceUtils.isTypeAttributeSupported("string"))
        print(InstanceUtils.isTypeAttributeSupported("boolean"))
        print(InstanceUtils.isTypeAttributeSupported("number"))
        print(InstanceUtils.isTypeAttributeSupported("table"))
        ```

    === "Output"

        ```
        true
        true
        true
        true
        false
        ```

## make

Useful for creating lots of instances at once, for only a few instances it is reccomended to use `Instance.new()`

```lua
-- Creates a model in workspace named "Container" with a 1x1x1 anchored part inside
InstanceUtils.make(
    {
        "Model",
        {
            Name = "Container"
        },
        workspace,
        {
            "Part",
            {
                Anchored = true,
                Size = Vector3.new(1, 1, 1)
            }
        }
    }
)
```