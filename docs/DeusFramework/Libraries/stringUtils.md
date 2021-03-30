# StringUtils

## countMatches

Returns count of pattern matches.

!!! example
    === "Script"

        ```lua
        print(StringUtils.countMatches("the quick brown fox jumps over the lazy dog", "the"))
        ```

    === "Output"

        ```
        2
        ```

## matches

Returns matches in a table with where the match starts and ends.

!!! example
    === "Script"

        ```lua
        print(StringUtils.matches("the quick brown fox jumps over the lazy dog", "the"))
        ```

    === "Output"

        ```
        {
            {
                End = 3,
                Match = "the",
                Start = 1
            },
            {
                End = 34,
                Match = "the",
                Start = 32
            }
        }
        ```

## replace

Splices a new string into an existing string.

!!! example
    === "Script"

        ```lua
        print(StringUtils.replace("the quick brown fox jumps over the lazy dog", "red cat", 11, 19))
        ```

    === "Output"

        ```
        the quick red cat jumps over the lazy dog
        ```

## collapse

Replaces sequential pattern occurances with a single occurance. This is useful to remove double spaces in chat messages.

!!! example
    === "Script"

        ```lua
        print(StringUtils.collapse("   i    am    spamming  chat", " "))
        ```

    === "Output"

        There is still a space at the start of the string.

        ```
         i am spamming chat
        ```

## hash

Uses the bytes in a string to generate a hash.

!!! example
    === "Script"

        ```lua
        print(StringUtils.hash("the quick brown fox jumps over the lazy dog"))
        ```

    === "Output"

        ```
        67114530
        ```

## reverseSub

Similar to `string.sub()` but instead starts at the end of a string instead of the front.

!!! example
    === "Script"

        ```lua
        print(StringUtils.reverseSub("the quick brown fox jumps over the lazy dog", 1, 8))
        ```

    === "Output"

        ```
        lazy dog
        ```