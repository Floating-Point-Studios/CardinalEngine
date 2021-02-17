# BindableEvent

!!! info "Inherited from [BaseObject](../Classes/baseObject.md)"
    The event `Changed` is not inherited as a special exception due to `BindableEvent` being the event

An event object that behaves more similar to a Roblox object's event. This implementation also allows `userdata` types often made from `newproxy()` to be sent as arguments.

## Creating

```lua
local bindableEvent = Deus:Load("Deus.BindableEvent").new()
```

## Methods

|               | Name      | Arguments             | Returns           |
|               |           |                       |                   |
| `Internal`    | Fire      | `tuple` Arguments     | `void`            |
|               | Connect   | `function` Callback   | `tuple` Arguments |
|               | Wait      | `void`                | `tuple` Arguments |

## Properties

| Permission    | Type          | Name          | Description                       |
|               |               |               |                                   |
| `Private`     | `Instance`    | RBXEvent      | BindableEvent used to wrap        |
| `ReadOnly`    | `Number`      | LastFiredTick | Time the event was last fired     |