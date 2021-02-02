# BaseObject

Objects that require permissions, replication across client-server boundary, change detection, or inheritance are inherited from the BaseObject.
If an object does not require these it is reccomended to use a simple metatable as a object.

!!! note "Permissions"
    === "Internal Access"
        Internal access refers to direct access to the object's metatable which provides the ability to read and write to all properties.

    === "External Access"
        External access refers to access only to the object's proxy which provides limited access.

## Usage

!!! example "Creating a new class"
    1. All arguments are optional
    2. If a ClassName is not provided a randomly generated ClassName will be assigned
    3. Certain method and event names are reserved and will be overwritten if used

    | Type      | Property                      | Description                                                       |
    | --------- | ----------------------------- | ----------------------------------------------------------------- |
    | `string`  | ClassName                     | Name of class                                                     |
    | `boolean` | Extendable                    | If object can be inherited from                                   |
    | `boolean` | Replicable                    | If object can be replicated from                                  |
    | `function`| Constructor                   | Function ran after object is made and before object is returned   |
    | `table`   | Methods                       | List of class methods                                             |
    | `table`   | Events                        | List of class events                                              |
    | `table`   | PrivateProperties             | List of properties only accessible with internal access           |
    | `table`   | PublicReadOnlyProperties      | List of properties only readable with external access             |
    | `table`   | PublicReadAndWriteProperties  | List of properties read and writable with external access         |

    ```lua
    local myClass = BaseObject.new(
        {
            ClassName = "myClassName",

            Extendable = true,

            Replicable = true,

            Constructor = function(self, ...)
                -- 1st argument is object
                -- 2nd argument onwards are arguments called with myClass.new()
                self.foo = {...}[1]
            end,

            Methods = {},

            Events = {"myEvent"},

            PrivateProperties = {},

            PublicReadOnlyProperties = {
                foo = "bar"
            },

            PublicReadAndWriteProperties = {}
        }
    )
    ```

!!! example "Creating a new object"

    ```lua
    local myObject = myClass.new("bar2")
    ```

## Reading and writing with internal access

!!! warning
    This is not guaranteed to work in future versions as this is reading and writing directly to the object's `TableProxy` which is subject to internal change.

To optimize reading and writing properties with internal access the object's `TableProxy` can be accessed directly to avoid invoking any metatable methods.
Due to this not invoking any metatable methods the `Changed` event will not fire with changes made via this method.

```lua
local ClassName = myObject.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties.ClassName
local Extendable = myObject.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties.Extendable
local Replicable = myObject.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties.Replicable
local Methods = myObject.Internal.DEUSOBJECT_LockedTables.Methods
local Events = myObject.Internal.DEUSOBJECT_LockedTables.Events
local PrivateProperties = myObject.Internal.DEUSOBJECT_Properties
local PublicReadOnlyProperties = myObject.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties
local PublicReadAndWriteProperties = myObject.Internal.DEUSOBJECT_LockedTables.ReadAndWriteProperties

PublicReadOnlyProperties.foo = "bar3"
```

## Inherited methods

### FireEvent

!!! warning "Internal Access Required"

```lua
myObject:FireEvent("myEvent", ...)
```

### GetPropertyChangedSignal

!!! note
    Cannot hook to properties of `PrivateProperties`

```lua
myObject:GetPropertyChangedSignal("foo"):Connect(function(newProperty, oldProperty)

end)
```

### GetMethods

```lua
myObject:GetMethods()
```

### GetEvents

```lua
myObject:Events()
```

### GetReadableProperties

Returns `PublicReadOnlyProperties` and `PublicReadAndWriteProperties`

```lua
myObject:GetReadableProperties()
```

### GetWritableProperties

Returns `PublicReadAndWriteProperties`

```lua
myObject:GetWritableProperties()
```

### Serialize

```lua
myObject:Serialize()
```

### Hash

```lua
myObject:Hash()
```

### Replicate

!!! warning "Internal Access Required"

```lua
myObject:Replicate(workspace.Baseplate)
```

## Inherited events

### Changed

!!! note
    Cannot hook to properties of `PrivateProperties`

```lua
myObject.Changed:Connect(function(oldProperty, newProperty)

end)
```

## Properties