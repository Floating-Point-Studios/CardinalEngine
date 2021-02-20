local Enumeration
local RaycastUtils

local StepSpring = require(script.Parent.StepSpring)
local NPCState = Enumeration.NPCState

local FRAMERATE = 1 / 240
local STIFFNESS = 170
local DAMPING = 26
local PRECISION = 0.001
local POP_TIME = 0.05

function update(self, dt)
    local PrivateProperties = self.Internal.DEUSOBJECT_Properties
    local ReadOnlyProperties = self.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties
    local ReadAndWriteProperties = self.Internal.DEUSOBJECT_LockedTables.ReadAndWriteProperties

    local character = ReadOnlyProperties.Character
    local humanoidRootPart = character.HumanoidRootPart
    local vectorForce = PrivateProperties.VectorForce

    local mass = humanoidRootPart.AssemblyMass
    local velocity = humanoidRootPart.AssemblyLinearVelocity

    local currentVelocityX = velocity.X
    local currentVelocityY = velocity.Y
    local currentVelocityZ = velocity.Z

    local curState = ReadOnlyProperties.State
    local jumping = ReadAndWriteProperties.Jump
    local moveDir = ReadAndWriteProperties.MoveDir
    local hipHeight = ReadAndWriteProperties.HipHeight
    local walkSpeed = ReadAndWriteProperties.WalkSpeed
    local jumpPower = ReadAndWriteProperties.JumpPower

    -- Raycasting
    local raycastParams = PrivateProperties.UpdateRaycastParams
    if not raycastParams then
        raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.IgnoreWater = true
        PrivateProperties.UpdateRaycastParams = raycastParams
    end

    local hipCF = humanoidRootPart.CFrame * CFrame.new(0, -humanoidRootPart.Size.Y / 2, 0)

    local raycastDownResult = RaycastUtils.castCollideOnly(
        hipCF.p + Vector3.new(0, 0.1, 0),
        Vector3.new(0, -hipHeight - 1, 0), -- 1 stud fudge factor
        raycastParams
    )
    local raycastForwardResult = RaycastUtils.castCollideOnly(
        humanoidRootPart.Position,
        humanoidRootPart.CFrame.LookVector * (humanoidRootPart.Size.Z / 2 + 1),
        raycastParams
    )

    -- Remove infinite values
    if mass == math.huge then
        mass = 0
    end

    -- State Handling
    if raycastDownResult then
        -- Grounded
        if curState == NPCState.Jumping and currentVelocityY < 0 then
            -- Falling from jump
            vectorForce.Force = Vector3.new()
            return NPCState.Falling
        end

        if jumping and (curState == NPCState.Idle or curState == NPCState.Walking) then
            -- Begin jump
            vectorForce.Force = Vector3.new()
            humanoidRootPart:ApplyImpulse(Vector3.new(0, jumpPower * mass, 0))
            ReadAndWriteProperties.Jump = false
            return NPCState.Jumping
        else
            -- Luanoid calculations used for idle/walking state
            local groundPos = raycastDownResult.Position
            local targetVelocity = Vector3.new()

            moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            if moveDir.Magnitude > 0 then
                targetVelocity = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * walkSpeed
            end

            PrivateProperties.AccumulatedTime = (PrivateProperties.AccumulatedTime or 0) + dt

            while PrivateProperties.AccumulatedTime >= FRAMERATE do
                PrivateProperties.AccumulatedTime = PrivateProperties.AccumulatedTime - FRAMERATE

                currentVelocityX, PrivateProperties.CurrentAccelerationX = StepSpring(
                    FRAMERATE,
                    currentVelocityX,
                    PrivateProperties.CurrentAccelerationX or 0,
                    targetVelocity.X,
                    STIFFNESS,
                    DAMPING,
                    PRECISION
                )

                currentVelocityZ, PrivateProperties.CurrentAccelerationZ = StepSpring(
                    FRAMERATE,
                    currentVelocityZ,
                    PrivateProperties.CurrentAccelerationZ or 0,
                    targetVelocity.Z,
                    STIFFNESS,
                    DAMPING,
                    PRECISION
                )
            end

            local targetHeight = groundPos.Y + hipHeight + humanoidRootPart.Size.Y / 2
            local currentHeight = humanoidRootPart.Position.Y

            local aUp

            -- counter gravity and then solve constant acceleration eq
            -- (x1 = x0 + v*t + 0.5*a*t*t) for a to aproach target height over time
            local t = POP_TIME
            aUp = workspace.Gravity + 2*((targetHeight - currentHeight) - currentVelocityY*t)/(t*t)

            -- Don't go past a maxmium velocity or we'll overshoot our target height.
            -- Calculate the intitial velocity that under constant acceleration would crest at the target height.
            -- Humans can't really thrust downward, just allow gravity to pull us down. So if we go over this 
            -- velocity we'll overshoot the target height and "jump." This is the physical limit for responsiveness.
            local deltaHeight = math.max((targetHeight - currentHeight)*1.01, 0) -- 1% fudge factor to prevent jitter while idle
            deltaHeight = math.min(deltaHeight, hipHeight)
            local maxUpVelocity = math.sqrt(2.0*workspace.Gravity*deltaHeight)
            -- Upward acceleration that would cause us to achieve this velocity in one step
            -- Would /dt, but not using dt here. Our dt jumps is weird due to throttling and the physics solver using a 240Hz 
            -- step rate internally, not always the right thing for us here. Having to deal with not having a proper step event...
            local maxUpImpulse = math.max((maxUpVelocity - currentVelocityY)*60, 0)
            aUp = math.min(aUp, maxUpImpulse)
            -- downward acceleration cuttoff (limited ability to push yourself down)
            aUp = math.max(-1, aUp)

            local aX = PrivateProperties.CurrentAccelerationX
            local aZ = PrivateProperties.CurrentAccelerationZ
            --[[
            if normal and steepness > 0 then
                -- deflect control acceleration off slope normal, discarding the parallell component
                local aControl = Vector3.new(aX, 0, aY)
                local dot = math.min(0, normal:Dot(aControl)) -- clamp below 0, don't subtract forces away from normal
                local aInto = normal*dot
                local aPerp = aControl - aInto
                local aNew = aPerp
                aNew = aControl:Lerp(aNew, steepness)
                aX, aY = aNew.X, aNew.Z

                -- mass on a frictionless incline: net acceleration = g * sin(incline angle)
                local aGravity = Vector3.new(0, -Workspace.Gravity, 0)
                dot = math.min(0, normal:Dot(aGravity))
                aInto = normal*dot
                aPerp = aGravity - aInto
                aNew = aPerp
                aX, aY = aX + aNew.X*steepness, aY + aNew.Z*steepness
                aUp = aUp + aNew.Y*steepness

                aUp = math.max(0, aUp)
            end
            ]]

            vectorForce.Force = Vector3.new(aX, aUp, aZ) * mass
            if moveDir.Magnitude > 0 then
                return NPCState.Walking
            else
                return NPCState.Idle
            end
        end
    else
        -- Falling
        vectorForce.Force = Vector3.new()
        return NPCState.Falling
    end
end

local UpdateHandler = {}

function UpdateHandler:start()
    Enumeration = self:Load("Deus.Enumeration")
    RaycastUtils = self:Load("Deus.RaycastUtils")

    return update
end

return UpdateHandler