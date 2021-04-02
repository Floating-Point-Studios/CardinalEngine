# BaseObject

Objects that require permissions, replication across client-server boundary, change detection, or inheritance are inherited from the BaseObject.
If an object does not require these it is reccomended to use a simple metatable as a object.

!!! info "Permissions"
    === "Internal Access"
        Internal access refers to direct access to the object's metatable which provides the ability to read and write to all properties.

    === "External Access"
        External access refers to access only to the object's proxy which provides limited access.

## Usage

!!! example "Creating a new class"
    * All arguments are optional
    * If a ClassName is not provided a randomly generated ClassName will be assigned
    * Certain method and event names are reserved and will be overwritten if used
    * If "Changed" is included in the `Events` table then the BaseObject will fire the event when a property change is detected

    | Type      | Property                      | Description                                                       |
    |           |                               |                                                                   |
    | `string`  | ClassName                     | Name of class                                                     |
    | `boolean` | Extendable                    | If object can be inherited from                                   |
    | `function`| Constructor                   | Function ran after object is made and before object is returned   |
    | `function`| Deconstructor                 | Function ran after before object is destroyed                     |
    | `table`   | Events                        | List of class events                                              |
    | `table`   | PrivateProperties             | List of properties only accessible with internal access           |
    | `table`   | PublicReadOnlyProperties      | List of properties only readable with external access             |
    | `table`   | PublicReadAndWriteProperties  | List of properties read and writable with external access         |

    !!! info "Snippets"
    === "Regular"

        ```lua
        local myClass = {
            ClassName = "myClass",
            Events = {}
        }

        function myClass:Constructor(part)
            self.foo = part
        end

        function myClass:Deconstructor()
            self.foo:Destroy()
        end

        function myClass.start()
            local None = myClass:Load("Deus.Symbol").get("None")

            myClass.PrivateProperties = {
                foo = None
            }

            myClass.PublicReadOnlyProperties = {}

            myClass.PublicReadAndWriteProperties = {}

            return myClass:Load("Deus.BaseObject").new(myClass)
        end

        return myClass
        ```

    === "Simple"

        ```lua
        local myClass = {
            ClassName = "myClass"
        }

        function myClass:Constructor()
            
        end

        function myClass:Deconstructor()
            
        end

        function myClass.start()
            local None = myClass:Load("Deus.Symbol").get("None")

            -- Property assignment should occur here
            myClass.foo = None

            return myClass:Load("Deus.BaseObject").newSimple(myClass)
        end

        return myClass
        ```

## Creating a new object

!!! example ""

    ```lua
    local myObject = myClass.new(Instance.new("Part"))
    ```

## Representing nil

!!! example ""
    To represet `nil` in object properties use the [Symbol](../Libraries/symbol.md) `None`

    ```lua
    function myClass.start()
        local None = myClass:Load("Deus.Symbol").get("None")

        myClass.PrivateProperties = {
            foo = None
        }

        myClass.PublicReadOnlyProperties = {}

        myClass.PublicReadAndWriteProperties = {}

        return myClass:Load("Deus.BaseObject").new(myClass)
    end
    ```

## Using superclasses

!!! example ""
    Objects with a superclass inherit the methods of its superclass. Be sure to have all the properties the inherited functions need to run as properties are not automatically inherited.

    ```lua
    local myClass = {}

    myClass.ClassName = "myClass"

    function myClass.start()
        -- New class inherited from Deus.RemoteEvent
        myClass.Superclass = myClass:Load("Deus.RemoteEvent")

        return myClass:Load("Deus.BaseObject").newSimple(myClass)
    end

    return myClass
    ```

## Inherited methods

### FireEvent
{internal}

```lua
myObject:FireEvent("myEvent", ...)
```

### GetPropertyChangedSignal

!!! info
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

## Properties

| Permission    | Type          | Name              | Description                                                                                                   |
|               |               |                   |                                                                                                               |
| `ReadOnly`    | `String`      | ClassName         | Name of class                                                                                                 |
| `ReadOnly`    | `String`      | Superclass        | Class object is extended from                                                                                 |
| `ReadOnly`    | `Boolean`     | Extendable        | If object can be inherited from                                                                               |
| `ReadOnly`    | `String`      | ObjectId          | UUID of object                                                                                                |
| `ReadOnly`    | `Number`      | TickCreated       | Time object was created (On objects replicated across server/client boundary the time will be in server time) |
| `ReadOnly`    | `userdata`    | Proxy             | Object's proxy limited to external access (Inherited from `TableProxy`)                                       |