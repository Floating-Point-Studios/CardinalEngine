# NetworkService

Easy management of [RemoteEvents](../../DeusFramework/Classes/Events/remoteEvent.md) and [RemoteFunctions](../../DeusFramework/Classes/Events/remoteFunction.md) between the server and client.

## Connect

!!! info
    When `Connect` is used on the Server the first argument will always be the player.

```lua
NetworkService:Connect("RemoteEventName", function(...)

end)
```

## Fire
```lua
NetworkService:Fire("RemoteEventName", ...)
```

## OnInvoke

!!! info
    When `OnInvoke` is used on the Server the first argument will always be the player.

```lua
NetworkService:OnInvoke("RemoteFunctionName", function(...)
    return ...
end
```

## Invoke
```lua
NetworkService:Invoke("RemoteFunctionName", ...)
```