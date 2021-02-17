# AdornmentUtils

## Valid Classes

AdornmentUtils only supports these classes

| ClassName                 |
|                           |
| BoxHandleAdornment        |
| ConeHandleAdornment       |
| CylinderHandleAdornment   |
| LineHandleAdornment       |
| SphereHandleAdornment     |
| ImageHandleAdornment      |

## Usage

| Argument              | Description                                                                                       |
|                       |                                                                                                   |
| `string` ClassName    | ClassName of adornment                                                                            |
| `Instance` Parent     | Parent                                                                                            |
| `CFrame` CFrame       | CFrame                                                                                            |
| `bool` IsWorldSpace   | If CFrame is WorldSpace, if false and Parent is provided `ToObjectSpace()` will be used on CFrame |
| `table` Properties    | Table of properties                                                                               |

!!! example

    ```lua
    AdornmentUtils.make("BoxHandleAdornment", workspace, CFrame.new(), true, {})
    ```