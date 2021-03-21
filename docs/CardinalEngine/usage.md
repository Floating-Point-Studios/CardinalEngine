# Usage

## Getting Loader

Cardinal by default provides only one way of getting the module loader when not loading from Cardinal's designated folder for modules

!!! example "Loading from Shared"

    This method works when it is known that Cardinal is done loading and the script does not need to yield.

    ```lua
    local Cardinal = shared.Cardinal
    ```

## Getting & Registering Packages

!!! info
    Refer to [DeusFramework Usage](../DeusFramework/usage.md#getting-modules) for details on how to register packages on your own or to write your own loader

Packages are Scripts, LocalScripts, ModuleScripts, or folders that are registered by Cardinal. Cardinal will load packages in a folder parented to `ServerStorage` named `CardinalPackages`.

### File Extensions

ModuleScripts and folders can have file extensions. If no extension is found the package will be distrubted to the Server and Client.

* The extension `.shared` will be loaded by both the Client and Server.
* The extension `.client` will be loaded by only the Client
* The extension `.server` will be loaded by only the Server

### LocalScripts

LocalScripts directly parented to `CardinalPackages` will be loaded in `ReplicatedFirst`

### Scripts

Scripts directly parented to `CardinalPackages` will be loaded in `ServerScriptService`