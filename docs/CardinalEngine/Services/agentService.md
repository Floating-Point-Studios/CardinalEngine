# AgentService

Service for spawning agents through [Cardinoid](/CardinalEngine/Libraries/cardinoid) and moving them to targets from [PathfindingService](https://developer.roblox.com/en-us/api-reference/class/PathfindingService){target=blank}.

## Spawn

Wrapper for `Cardinoid.new()` with a few additional dictionary keys.

!!! example
    === "Creating a new agent"

        ```lua
        AgentService:Spawn(
            {
                -- New settings
                Rig = RIG,
                Parent = workspace,
                NetworkOwner = PLAYER,

                -- Original settings
                Name = "",
                Health = 100,
                MaxHealth = 100,
                WalkSpeed = 16,
                JumpPower = 50,
                HipHeight = 2,
                LookInMoveDir = true,
                CanJump = true,
                CanClimb = true
            }
        )
        ```

    === "Creating an agent from a character"

        ```lua
        AgentService:Spawn(character)
        ```

## MoveTo

Similar to `agent:MoveTo()` except uses `PathfindingService` and automatically takes into account of the character's radius, height, and ability to jump. Excepts the first argument to be an agent, and the second argument to either be a `Vector3` or `Instance`. Yields and returns a `boolean` for if the agent successfully or failed in reaching the target.

```lua
AgentService:MoveTo(agent, target)
```