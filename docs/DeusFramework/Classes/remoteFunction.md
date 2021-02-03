# RemoteFunction

!!! info "Inherited from [BaseObject](../Classes/baseObject.md)"

Serves primarily as a wrapper for [NetworkService](..//Services/networkService.md) as this object provides no real advantages over Roblox's RemoteFunction.

## Creating

```lua
local remoteFunction = Deus:Load("Deus.RemoteFunction").new()
```

## Methods

Certain methods only exist on the client or server.

!!! info "Server Methods"

    |               | Name          | Arguments                             | Returns               |
    |               |               |                                       |                       |
    | `internal`    | InvokeClient  | `Player` Player, `tuple` Arguments    | `tuple` Arguments     |
    |               | Listen        | `function` Callback                   | `RBXScriptConnection` |

!!! info "Client Methods"

    |               | Name          | Arguments                             | Returns               |
    |               |               |                                       |                       |
    | `internal`    | InvokeServer  | `Player` Player, `tuple` Arguments    | `tuple` Arguments     |
    |               | Listen        | `function` Callback                   | `RBXScriptConnection` |