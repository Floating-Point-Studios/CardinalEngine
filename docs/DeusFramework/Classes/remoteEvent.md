# RemoteEvent

!!! info "Inherited from [BaseObject](../Classes/baseObject.md)"

Provides easier control over sending data to clients. Should primarily be accessed from [NetworkService](..//Services/networkService.md).

## Creating

```lua
local remoteEvent = Deus:Load("Deus.RemoteEvent").new()
```

## Methods

Certain methods only exist on the client or server.

!!! info "Server Methods"

    |               | Name                  | Arguments                                                 | Returns               |
    |               |                       |                                                           |                       |
    | `internal`    | FireClient            | `Player` Player, `tuple` Arguments                        | `void`                |
    | `internal`    | FireClients           | `array` Players, `tuple` Arguments                        | `void`                |
    | `internal`    | FireAllClients        | `tuple` Arguments                                         | `void`                |
    | `internal`    | FireNearbyClients     | `Vector3` Position, `Number` Radius, `tuple` Arguments    | `void`                |
    |               | Listen                | `function` Callback                                       | `RBXScriptConnection` |

!!! info "Client Methods"

    |               | Name                  | Arguments             | Returns               |
    |               |                       |                       |                       |
    | `internal`    | FireServer            | `tuple` Arguments     | `void`                |
    |               | Listen                | `function` Callback   | `RBXScriptConnection` |

## Properties

| Permission    | Type          | Name              | Description                   |
|               |               |                   |                               |
| `ReadOnly`    | `Number`      | LastSendTick      | Last time event was fired     |
| `ReadOnly`    | `Number`      | LastReceiveTick   | Last time event received data |