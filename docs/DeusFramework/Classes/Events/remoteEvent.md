# RemoteEvent
*Inherited from [BaseObject](/DeusFramework/Classes/baseObject)*

## new

When used on the Server the 1st argument should be the RemoteEvent's name, the 2nd argument is the parent

```lua
local remoteEvent = RemoteEvent.new("RemoteEventName", workspace)
```

When used on the Client the only argument should be a Roblox RemoteEvent instance

```lua
local remoteEvent = RemoteEvent.new(workspace.RemoteEventName)
```

## Connect

When used on the Server this behaves like `OnServerEvent:Connect()` and when used on the Client it behaves like `OnClientEvent:Connect()`

```lua
local connection = remoteEvent:Connect(function(...)
    -- On the server this would print the Player
    print({...}[1])
end)

connection:Disconnect()
```

## Fire

!!! warning "Internal Access Required"
    When used on the Server this behaves like `FireClient()` and when used on the Client it behaves like `FireServer()`

    ```lua
    -- Server
    remoteEvent:Fire(player, ...)
    ```

    ```lua
    -- Client
    remoteEvent:Fire(...)
    ```

## FireAllClients

!!! warning "Internal Access Required"
    This method can only be used on the Server and behaves like `FireAllClients()`

    ```lua
    remoteEvent:FireAllClients(...)
    ```

### FireWhitelistedClients

!!! warning "Internal Access Required"
    This method can only be used on the Server and fires the event for all players in a list

    ```lua
    remoteEvent:FireWhitelistedClients({player1, player2, player3}, ...)
    ```