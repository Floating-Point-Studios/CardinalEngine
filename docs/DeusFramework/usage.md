# Usage

## Getting Loader

Deus by default provides 2 ways of getting the module loader.

!!! example "Loading from Shared"

    This method works when it is known that Deus is done loading and the script does not need to yield.

    ```lua
    local Deus = shared.Deus
    ```

!!! example "Loading from ReplicatedStorage"
    This method is reccomended when a script needs to access Deus at the start of the game.

    ```lua
    local Deus = require(game:GetService("ReplicatedStorage"):WaitForChild("Deus"))
    ```

## Getting modules

Deus provides 2 ways of getting modules. The first is to use the loader obtained from the steps above, the second is accessible only from a ModuleScript loaded by Deus.
Both use the `Load()` method.

!!! example "Loading modules from Shared or ReplicatedStorage"

    This should only be used in `Scripts` or `LocalScripts`

    ```lua
    local BaseObject = Deus:Load("Deus.BaseObject")
    ```

!!! example "Loading modules from ModuleScript"

    This should be the primary method in loading modules

    ```lua
    local BaseObject
    local Output
    local StringUtils

    local Module = {}

    function Module.start()
        BaseObject = Module:Load("Deus.BaseObject")
        Output = Module:Load("Deus.Output")
        StringUtils = Module:Load("Deus.StringUtils")
    end

    return Module
    ```

## Registering modules

To register or add your own modules to Deus that can be loaded globally later use the `Register()` method. Here's an example of a module tree.

```
script
 - module1
  - submodule1
 - module2
 - module3
```

```lua
Deus:Register(script, "myModuleName")
```

To load your modules you would use the path with the module name specified earlier.

!!! info
    By default Deus will not be able to load submodule1 in the tree as it will ignore submodules.

```lua
local module1 = Deus:Load("myModuleName.module1")
local module2 = Deus:Load("myModuleName.module2")
local module3 = Deus:Load("myModuleName.module3")

-- These will not work!
local submodule1 = Deus:Load("myModuleName.submodule1")
local submodule1 = Deus:Load("myModuleName.module1.submodule1")
local submodule1 = Deus:Load("myModuleName.module1").submodule1
```