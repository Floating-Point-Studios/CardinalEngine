# Output

Custom implementations of `print`, `warn`, `error`, and `assert` to make formatting error messages easier.

## print

```lua
Output.print(
    "This script's name is %s and its path is %s",  -- String Pattern
    {script.Name, script:GetFullName()}             -- List or anything that can be represented as a string
)
```

## warn

```lua
Output.warn(
    "This is a warning without any formatting", -- String Pattern
    nil                                         -- Nil in this case due to the pattern not needing any replacements
)
```

## error

```lua
Output.error(
    "Expected table, instead got %s",   -- String Pattern
    typeof(x),                          -- List or anything that can be represented as a string
    1                                   -- Level (defaults to 0 if nil)
)
```

## assert

```lua
Output.assert(
    typeof(x) == "table",               -- Boolean, if true no error will be thrown
    "Expected table, instead got %s",   -- String Pattern
    typeof(x),                          -- List or anything that can be represented as a string
    1                                   -- Level (defaults to 0 if nil)
)
```