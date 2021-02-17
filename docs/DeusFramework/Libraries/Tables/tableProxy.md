# TableProxy

Creates a table that allows key-values to be set as `Internal`, `ExternalReadOnly`, `ExternalReadAndWrite`. This module serves as the basis of [BaseObject](../../Classes/baseObject.md).

## Creating a TableProxy

!!! example ""

    ```lua
    local TableProxy = Deus:Load("Deus.TableProxy")

    local tableProxy = TableProxy.new(
        {
            Internal = {
                a = "this value can only be edited internally"
            },
            ExternalReadOnly = {
                b = "this value can be read externally, but only edited internally"
            },
            ExternalReadAndWrite = {
                c = "this value can be edited from externally and internally"
            }
        }
    )
    ```

## Returning the external TableProxy

!!! example ""

    ```lua
    return tableProxy.Proxy
    ```