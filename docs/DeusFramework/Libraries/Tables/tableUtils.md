# TableUtils

Libray to expand Luau's `table` methods

## Loading

```lua
local TableUtils = Deus:Load("Deus.TableUtils").new()
```

## Methods

| Name                  | Arguments                                             | Returns                                                                       |
|                       |                                                       |                                                                               |
| shallowCopy           | `table` Table                                         | Copy of all key-values stored with a numbered key                             |
| deepCopy              | `table` Table                                         | Copy of all key-values                                                        |
| getKeys               | `table` Table                                         | Array of keys                                                                 |
| getValues             | `table` Table                                         | Array of values                                                               |
| merge                 | `tuple` Tables                                        | Combines all tables into a new table                                          |
| unpack                | `tuple` Tables                                        | Unpacks multiple tables in order                                              |
| remove                | `variant` Value                                       | Removes the given value in a table                                            |
| sub                   | `table` Table, `number` IndexStart, `number` IndexEnd | Returns key-values stored with a numbered key between IndexStart and IndexEnd |
| sum                   | `table` Table                                         | Returns the sum of an array of `number`, `Vector2`, or `Vector3` values       |
| average               | `table` Table                                         | Returns the average of an array of `number`, `Vector2`, or `Vector3` values   |
| instanceAsIndex       | `Instance`Instance                                    | Allows an instance to behave like the __index of a table                      |
| instanceAsNewIndex    | `Instance`Instance                                    | Allows an instance to behave like the __newindex ofa table                    |