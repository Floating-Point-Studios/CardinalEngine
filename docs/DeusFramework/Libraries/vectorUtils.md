# VectorUtils

## clamp

Equivalent to `math.clamp()` but for `Vector3`

!!! example
    === "Script"

        ```lua
        print(VectorUtils.clamp(Vector3.new(-100, 100, 20), 0, 50))
        print(VectorUtils.clamp(Vector3.new(-100, 100, 20), nil, 50))
        print(VectorUtils.clamp(Vector3.new(-100, 100, 20), 0))
        ```

    === "Output"

        ```
        0, 50, 20
        -100, 50, 20
        0, 100, 20
        ```

## llarToWorld

Converts latitude, longitude, altitude (defaults to 0) into a unit and scales it by the radius (defaults to 1)

!!! example
    === "Script"

        ```lua
        print(VectorUtils.llarToWorld(35.6762, 139.6503))
        ```

    === "Output"

        ```
        0.0655324981, 0.431926399, 0.899524927
        ```

## abs

Equivalent to `math.abs()` but for `Vector3`

!!! example
    === "Script"

        ```lua
        print(VectorUtils.abs(Vector3.new(-1, 10, -100)))
        ```

    === "Output"

        ```
        1, 10, 100
        ```

## angle

Returns the angle between 2 vectors in radians

!!! example
    === "Script"

        ```lua
        -- Converted to degrees
        print(math.deg(VectorUtils.angle(Vector3.new(1, 0, 0), Vector3.new(0, 0, 1))))
        ```

    === "Output"

        ```
        90
        ```