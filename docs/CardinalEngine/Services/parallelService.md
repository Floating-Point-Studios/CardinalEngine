# ParallelService

Manages [Actors](https://developer.roblox.com/en-us/api-reference/class/Actor){target=blank} in a pool

## Run

Runs a function in a given module in a separate thread, returns the results when complete. This example runs the function `print` in ModuleScript with the arguments `foo` and `bar`

```lua
local results = {ParallelService:Run(script.ModuleScript, "print", "foo", "bar")}
```