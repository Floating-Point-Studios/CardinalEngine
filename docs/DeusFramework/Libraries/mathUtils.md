# MathUtils

## phi

The golden ratio

!!! example
    === "Script"

        ```lua
        print(MathUtils.phi)
        ```

    === "Output"

        ```
        1.6180339887499
        ```

## ga

The golden angle in radians

!!! example
    === "Script"

        ```lua
        -- Converted to degrees
        print(math.deg(MathUtils.ga))
        ```

    === "Output"

        ```
        137.50776405004
        ```

## isNaN

Checks if a number is a number

!!! example
    === "Script"

        ```lua
        print(MathUtils.isNaN(tonumber("NaN")))
        print(MathUtils.isNaN(10))
        ```

    === "Output"

        ```
        true
        false
        ```

## round

Similar to `math.round()` but allows you to decide nearest multiple to round to

!!! example
    === "Script"

        ```lua
        print(MathUtils.round(3, 5))
        print(MathUtils.round(2, 5))
        ```

    === "Output"

        ```
        5
        0
        ```

## ceil

Similar to `math.ceil()` but allows you to decide nearest multiple to round up to

!!! example
    === "Script"

        ```lua
        print(MathUtils.ceil(3, 5))
        print(MathUtils.ceil(2, 5))
        ```

    === "Output"

        ```
        5
        5
        ```

## floor

Similar to `math.floor()` but allows you to decide nearest multiple to round down to

!!! example
    === "Script"

        ```lua
        print(MathUtils.floor(3, 5))
        print(MathUtils.floor(2, 5))
        ```

    === "Output"

        ```
        0
        0
        ```

## lerp

Interpolates between `number`, `Vector3`, and `CFrame`

!!! example
    === "Script"

        ```lua
        print(MathUtils.lerp(0, 100, 0.5))
        print(MathUtils.lerp(Vector3.new(), Vector3.new(100, 100, 100), 0.5))
        print(MathUtils.lerp(CFrame.new(), CFrame.new(100, 100, 100), 0.5).Position)
        ```

    === "Output"

        ```
        50
        50, 50, 50
        50, 50, 50
        ```

## factors

Returns all factors of a number including 1 and itself

!!! example
    === "Script"

    ```lua
    print(MathUtils.factors(21))
    ```

    === "Output"

    ```
    1, 3, 7, 21
    ```

## isPrime

Returns if a number is prime

!!! example
    === "Script"

        ```lua
        print(MathUtils.isPrime(7))
        print(MathUtils.isPrime(10))
        ```

    === "Output"

        ```
        true
        false
        ```

## snap

Returns the nearest number in a list

!!! example
    === "Script"

        ```lua
        print(MathUtils.snap(35, {5, 10, 20, 40, 80}))
        ```

    === "Output"

        ```
        40
        ```