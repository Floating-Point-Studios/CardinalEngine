# JSON

Library to expand HttpService's JSON capabilities. Provides support for these data types.

* `Vector2`
* `Vector3`
* `CFrame`
* `Color3`
* `BrickColor`

## Loading

```lua
local Deus = require(game:GetService("ReplicatedStorage"):WaitForChild("Deus"))
local JSON = Deus:Load("Deus.JSON")
```

## serialize

!!! example
    === "Script"

        ```lua
        print(JSON.serialize(
            {
                a = Vector2.new(3, 5),
                b = Vector3.new(3, 5, 7),
                c = CFrame.new(3, 5, 7),
                d = Color3.new(1, 1, 1),
                e = BrickColor.new("Bright red")
            }
        ))
        ```

    === "Output"

        ```
        {"d":{"_TYPE":4,"_DATA":[1,1,1]},"e":{"_TYPE":5,"_DATA":"Bright red"},"b":{"_TYPE":2,"_DATA":[3,5,7]},"c":{"_TYPE":3,"_DATA":[3,5,7,1,0,0,0,1,0,0,0,1]},"a":{"_TYPE":1,"_DATA":[3,5]}}
        ```

## deserialize

!!! example
    === "Script"

        ```lua
        print(JSON.deserialize('{"d":{"_TYPE":4,"_DATA":[1,1,1]},"e":{"_TYPE":5,"_DATA":"Bright red"},"b":{"_TYPE":2,"_DATA":[3,5,7]},"c":{"_TYPE":3,"_DATA":[3,5,7,1,0,0,0,1,0,0,0,1]},"a":{"_TYPE":1,"_DATA":[3,5]}}'))
        ```

    === "Output"

        ```
        {
            a = 3, 5,
            b = 3, 5, 7,
            c = 3, 5, 7,
            d = 1, 1, 1,
            e = Bright red
        }
        ```

## isJSON

!!! example
    === "Script"

        ```lua
        print(JSON.isJSON('{"d":{"_TYPE":4,"_DATA":[1,1,1]},"e":{"_TYPE":5,"_DATA":"Bright red"},"b":{"_TYPE":2,"_DATA":[3,5,7]},"c":{"_TYPE":3,"_DATA":[3,5,7,1,0,0,0,1,0,0,0,1]},"a":{"_TYPE":1,"_DATA":[3,5]}}'))
        ```

    === "Output"

        ```
        true
        ```