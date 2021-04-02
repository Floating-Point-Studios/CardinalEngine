# Cardinoid
*Inherited from [BaseObject](/DeusFramework/Classes/baseObject)*

!!! warning
    At this time the Swimming and Climbing state of Cardinoid are not yet implemented

Modern implementation of [Luanoid](https://github.com/LPGhatguy/luanoid){target=blank} in the CardinalEngine. Throughout this documentation `Agent` refers to the Cardinoid object while `Character` refers to `Agent.Character`. Many situations may require a custom `StateController` to write one it is recommended to view the default [StateController](https://github.com/Floating-Point-Studios/Cardinoid/blob/main/src/StateController/init.lua){target=blank}.

## Constructors

Cardinoid's constructor expects either a dictionary or `Character` created by Cardinoid.

!!! example
    === "Server"

        This script creates a Cardinoid for when a Player first joins

        ```lua
        local Cardinoid = Cardinal:Load("Cardinal.Cardinoid")

        game:GetService("Players").PlayerAdded:Connect(function(player)
            local agent = Cardinoid.new(
                {
                    -- Most these settings are optional and will default to these values if not set
                    Name = player.Name, -- Defaults to a randomly generated string
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

            -- SetNetworkOwner() can be called on Cardinoids without being a descendant of Workspace due to it actually not setting the NetworkOwner until it is a descendant of Workspace
            agent.Character:SetNetworkOwner(player)

            agent.Parent = workspace

            player.Character = agent.Character
        end)
        ```

    === "Client"

        This script creates the **Cardinoid Object not the character** for the player

        ```lua
        local Cardinoid = Cardinal:Load("Cardinal.Cardinoid")

        local LocalPlayer = game:GetService("Players").LocalPlayer

        local Agent

        LocalPlayer.CharacterAdded:Connect(function(character)
            if Agent then
                Agent:Destroy()
            end

            Agent = Cardinoid.new(character)
        end)

        if LocalPlayer.Character then
            Agent = Cardinoid.new(LocalPlayer.Character)
        end
        ```

## MountRig

!!! tip
    This method should only be used on the Client to avoid the Server streaming the rig to the Clients

Accepts any rigged character including those made by "Rig Builder" in the plugins tab of Roblox Studio. The only requirement is for the rig to have a HumanoidRootPart.

```lua
agent:MountRig(rig)
```

## UnmountRig

Destroys the agent's current rig.

```lua
agent:UnmountRig()
```

## LoadAnimation

Expects an [Animation](https://developer.roblox.com/en-us/api-reference/class/Animation){target=blank} as the first argument, the second argument is a optional `string` which will default to the name of the `Animation` if not provided. Multiple animations can be loaded under the same name. When `PlayAnimation()` is called one `Animation` will be selected at random.

```lua
agent:LoadAnimation(animation, name?)
```

## PlayAnimation

Randomly selects an `Animation` loaded under name.

```lua
agent:PlayAnimation(name)
```

## StopAnimation

Stops all animations loaded under name.

```lua
agent:StopAnimation(name)
```

## StopAllAnimations

Stops all animations.

```lua
agent:StopAllAnimations()
```

## Jump

Queues the `StateController` to jump.

```lua
agent:Jump()
```

## Sit

!!! warning
    This method has not been implemented yet and only exists in name

Queues the `StateController` to sit.

```lua
agent:Sit(seat?, offset?)
```

## MoveTo

!!! tip
    Setting the `target` to a moving `BasePart` with an infinite timeout will have the agent follow the `BasePart`

Has the `StateController` move to the requested `Vector3` or `Instance`

```lua
agent:MoveTo(vector3)

agent:MoveTo(basePart)
```

## CancelMoveTo

Cancels the current `MoveTo`

```lua
agent:CancelMoveTo()
```

## SetNetworkOwner

Sets who the character's NetworkOwner **should be** as a result this method can be used even when the character is not a descendant of `Workspace`. If the character becomes a descendant of `Workspace` Cardinoid will immediately run `SetNetworkOwner()` on the HumanoidRootPart.

!!! example
    === "Setting NetworkOwner to server"

        ```lua
        agent:SetNetworkOwner()
        ```

    === "Setting NetworkOwner to player"

        ```lua
        local players = game:GetService("Players")
        agent:SetNetworkOwner(players:FindFirstChildWhichIsA("Player"))
        ```

## PauseSimulation

Pauses updates from the `StateController`

```lua
agent:PauseSimulation()
```

## ResumeSimulation

Resumes updates from the `StateController`

```lua
agent:ResumeSimulation()
```

## Events

### StateChanged

```lua
agent.StateChanged:Connect(function(newState, lastState)
    print(newState, lastState)
end)
```

### MoveToFinished

```lua
agent.StateChanged:Connect(function(success)
    if success then
        print("MoveTo succeeded!")
    else
        print("MoveTo failed!")
    end
end)
```

## Read-only Properties

| Name              | Description                                                   |
|                   |                                                               |
| Character         | `Model` that contains HumanoidRootPart and the `Rig` if set   |
| LastState         | Previous state of the agent                                   |
| State             | Current state of the agent                                    |
| PlayingAnimations | Currently playing `AnimationTracks`                           |
| AnimationTracks   | Dictionary of `AnimationTracks`                               |
| RigParts          | List of parts that make up the `Rig` if set                   |

## Read-write Properties

| Name              | Description                                                                               |
|                   |                                                                                           |
| Health            | Current health                                                                            |
| MaxHealth         | Maximum health                                                                            |
| WalkSpeed         | Walking speed                                                                             |
| JumpPower         | Applied as an impulse to the HumanoidRootPart multiplied by the `AssemblyMass`            |
| HipHeight         | Height the middle of the HumanoidRootPart will levitate at off the ground                 |
| LookInMoveDir     | `Boolean` if the character should be facing the same direction it is walking              |
| CanJump           | If `agent:Jump()` does anything                                                           |
| CanClimb          | If the agent is able to enter the `Climb` state                                           |
| MoveDir           | Direction of movement expressed as a `Vector3` unit                                       |
| LookDir           | Direction to look expressed as a `Vector3` unit, disabled if `LookInMoveDir` is `true`    |
| StateController   | Anything with an `Update()` method                                                        |