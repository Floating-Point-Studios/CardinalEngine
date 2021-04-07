local RaycastUtils

local CharacterState

local StepSpring = require(script.StepSpring)

local FRAMERATE         = 1 / 240
local STIFFNESS         = 170
local DAMPING           = 26
local PRECISION         = 0.001
local POP_TIME          = 0.05

local StateController = {
    ClassName = "StateController",
    Events = {}
}

function StateController:Constructor(agent)
    self.Agent = agent

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {agent.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = false

    self.RaycastParams = raycastParams
end

function StateController:Update(dt)
    local agent = self.Agent
    local character = agent.Character
    local agentSize = character:GetExtentsSize()
    local humanoidRootPart = character.HumanoidRootPart
    local hrpSize = humanoidRootPart.Size
    local hrpPos = humanoidRootPart.Position
    local moveDir = agent.MoveDir
    local lookDir = agent.LookDir

    -- MoveTo Logic
    local moveToPosition = agent.MoveToPosition
    if moveToPosition then
        if tick() - agent.MoveToTick < agent.MoveToTimeout then
            if typeof(moveToPosition) == "Instance" then
                moveToPosition = moveToPosition.Position
            end

            if math.abs(moveToPosition.X - hrpPos.X) < agentSize.X / 2 and math.abs(moveToPosition.Y - hrpPos.Y) < agentSize.Y and math.abs(moveToPosition.Z - hrpPos.Z) < agentSize.Z / 2 then
                agent:CancelMoveTo()
                agent:FireEvent("MoveToFinished", true)
            else
                moveDir = (moveToPosition - hrpPos).Unit
            end
        else
            agent:CancelMoveTo()
            agent:FireEvent("MoveToFinished", false)
        end
    end

    -- Calculating state logic
    local hipHeight = agent.HipHeight
    local groundDistanceGoal = hipHeight + hrpSize.Y / 2
    local raycastResult = RaycastUtils.castCollideOnly(hrpPos, Vector3.new(0, -groundDistanceGoal, 0), self.RaycastParams)
    local velocity = humanoidRootPart.AssemblyLinearVelocity

    local currentVelocityX = velocity.X
    local currentVelocityY = velocity.Y
    local currentVelocityZ = velocity.Z

    local curState = agent.State
    local newState = curState

    if curState == CharacterState.Jumping then
        if currentVelocityY < 0 then
            -- We passed the peak of the jump and are now falling downward
            newState = CharacterState.Falling
        end
    elseif curState ~= CharacterState.Sitting and curState ~= CharacterState.Climbing then
        if raycastResult and (hrpPos - raycastResult.Position).Magnitude < groundDistanceGoal then
            -- We are grounded
            if agent.JumpInput then
                agent.JumpInput = false
                newState = CharacterState.Jumping
            else
                if moveDir.Magnitude > 0 then
                    newState = CharacterState.Walking
                else
                    newState = CharacterState.Idling
                end
            end
        else
            newState = CharacterState.Falling
        end
    end

    -- State handling logic
    local mover = agent.Mover
    local aligner = agent.Aligner

    if (newState == CharacterState.Idling or newState == CharacterState.Walking) then

        -- Luanoid calculations used for idle/walking state
        local groundPos = raycastResult.Position
        local targetVelocity = Vector3.new()

        moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
        if moveDir.Magnitude > 0 then
            targetVelocity = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * agent.WalkSpeed
        end

        self.AccumulatedTime = (self.AccumulatedTime or 0) + dt

        while self.AccumulatedTime >= FRAMERATE do
            self.AccumulatedTime = self.AccumulatedTime - FRAMERATE

            currentVelocityX, self.CurrentAccelerationX = StepSpring(
                FRAMERATE,
                currentVelocityX,
                self.CurrentAccelerationX or 0,
                targetVelocity.X,
                STIFFNESS,
                DAMPING,
                PRECISION
            )

            currentVelocityZ, self.CurrentAccelerationZ = StepSpring(
                FRAMERATE,
                currentVelocityZ,
                self.CurrentAccelerationZ or 0,
                targetVelocity.Z,
                STIFFNESS,
                DAMPING,
                PRECISION
            )
        end

        local targetHeight = groundPos.Y + hipHeight + hrpSize.Y / 2
        local currentHeight = hrpPos.Y

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

        local aX = self.CurrentAccelerationX
        local aZ = self.CurrentAccelerationZ
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

        mover.Force = Vector3.new(aX, aUp, aZ) * humanoidRootPart.AssemblyMass

        -- Look direction stuff
        if moveDir.Magnitude > 0 and agent.LookInMoveDir then
            lookDir = moveDir
        end

        if lookDir.Magnitude > 0 then
            aligner.Attachment1.CFrame = CFrame.lookAt(Vector3.new(), lookDir)
        end

    elseif newState == CharacterState.Jumping then

        mover.Force = Vector3.new()
        if curState ~= CharacterState.Jumping then
            humanoidRootPart:ApplyImpulse(Vector3.new(0, agent.JumpPower * humanoidRootPart.AssemblyMass, 0))
        end

        if lookDir.Magnitude > 0 then
            aligner.Attachment1.CFrame = CFrame.lookAt(Vector3.new(), lookDir)
        end

    elseif (newState == CharacterState.Sitting or newState == CharacterState.Falling) then

        mover.Force = Vector3.new()

    elseif newState == CharacterState.Swimming then

        -- TODO: Add Swimming

    elseif newState == CharacterState.Climbing then

        -- TODO: Add climbing

    end

    return newState
end

function StateController:start()
    RaycastUtils = self:Load("Deus.RaycastUtils")

    CharacterState = self:Load("Deus.Enumeration").CharacterState

    local None = self:Load("Deus.Symbol").get("None")

    self.Private = {
        Agent = None,

        RaycastParams = None,

        AccumulatedTime = 0,
        CurrentAccelerationX = 0,
        CurrentAccelerationZ = 0
    }

    self.Readable = {}

    self.Writable = {}

    return self:Load("Deus.BaseObject").new(self)
end

return StateController