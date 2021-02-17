# Usage

## Getting Loader

Cardinal by default provides only one way of getting the module loader when not loading from Cardinal's designated folder for modules

!!! example "Loading from Shared"

    This method works when it is known that Cardinal is done loading and the script does not need to yield.

    ```lua
    local Cardinal = shared.Cardinal
    ```

## Getting & Registering Modules

Refer to [DeusFramework Usage](../DeusFramework/usage.md#getting-modules)