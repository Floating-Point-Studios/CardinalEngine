local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Output

local StateController
local CharacterState

local HUMANOIDROOTPART_SIZE         = Vector3.new(1, 1, 1)
local HUMANOIDROOTPART_ROOTPRIORITY = 127
local ALIGNER_RESPONSIVENESS        = 20
local MOVETO_TIMEOUT                = 8

local function updateCardinoid(self)
    return function(dt)
        if not self.Character.HumanoidRootPart:IsGrounded() then
            local newState = self.StateController:Update(dt)
            local curState = self.State

            if newState ~= curState then
                self.LastState = curState
                self.State = newState
                self:FireEvent("StateChanged", newState, curState)

                self:StopAnimation(curState.Name)
                self:PlayAnimation(newState.Name)
            end
        end
    end
end

local Cardinoid = {
    ClassName = "Cardinoid",
    Events = {"StateChanged", "MoveToFinished"}
}

function Cardinoid:Constructor(...)
    local args = {...}
    local character
    local characterData

    if typeof(args[1]) == "Instance" then
        -- We are only making a Object for an existing character

        character = args[1]
        characterData = args[2] or {}

        local humanoidRootPart = character.HumanoidRootPart

        self.Mover = humanoidRootPart.CardinoidMover
        self.Aligner = humanoidRootPart.CardinoidAligner
        self.Animator = character.AnimationController.Animator
        self.Character = character
        self.RootPart = humanoidRootPart
    else
        -- We are creating a new character

        characterData = args[1] or {}

        -- Create the basic character model
        character = Instance.new("Model")
        character.Name = characterData.Name or ("Cardinoid_".. math.random(100000, 999999)) -- If no name is given generate one

        local moveDirAttachment = Instance.new("Attachment")
        moveDirAttachment.Name = "MoveDirection"

        local lookDirAttachment = Instance.new("Attachment")
        lookDirAttachment.Name = "LookDirection"

        local humanoidRootPart = Instance.new("Part")
        humanoidRootPart.Name = "HumanoidRootPart"
        humanoidRootPart.Transparency = 1
        -- Normal HumanoidRootParts have CanCollide off but this could easily fall out of the world
        -- humanoidRootPart.CanCollide = false
        humanoidRootPart.Size = HUMANOIDROOTPART_SIZE
        humanoidRootPart.RootPriority = HUMANOIDROOTPART_ROOTPRIORITY
        humanoidRootPart.Parent = character

        local vectorForce = Instance.new("VectorForce")
        vectorForce.Name = "CardinoidMover"
        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        vectorForce.ApplyAtCenterOfMass = true
        vectorForce.Attachment0 = moveDirAttachment
        vectorForce.Force = Vector3.new()
        vectorForce.Parent = humanoidRootPart

        local alignOrientation = Instance.new("AlignOrientation")
        alignOrientation.Name = "CardinoidAligner"
        alignOrientation.Responsiveness = ALIGNER_RESPONSIVENESS
        alignOrientation.Attachment0 = moveDirAttachment
        alignOrientation.Attachment1 = lookDirAttachment
        alignOrientation.Parent = humanoidRootPart

        -- Parents the attachments, hope that the LookDirection attachment doesn't get deleted by some other script
        moveDirAttachment.Parent = humanoidRootPart
        lookDirAttachment.Parent = workspace:FindFirstChildWhichIsA("Terrain")

        local animationController = Instance.new("AnimationController")
        animationController.Parent = character

        local animator = Instance.new("Animator")
        animator.Parent = animationController

        character.PrimaryPart = humanoidRootPart

        self.Mover = vectorForce
        self.Aligner = alignOrientation
        self.Animator = animator
        self.Character = character
        self.RootPart = humanoidRootPart
    end

    -- Set stats
    self.Health             = characterData.Health          or self.Health
    self.MaxHealth          = characterData.MaxHealth       or self.MaxHealth
    self.WalkSpeed          = characterData.WalkSpeed       or self.WalkSpeed
    self.JumpPower          = characterData.JumpPower       or self.JumpPower
    self.HipHeight          = characterData.HipHeight       or self.HipHeight
    self.LookInMoveDir      = characterData.LookInMoveDir   or self.LookInMoveDir
    self.CanJump            = characterData.CanJump         or self.CanJump
    self.CanClimb           = characterData.CanClimb        or self.CanClimb

    -- Setup of StateController
    local stateController = (characterData.StateController or self.StateController).new(self)

    self.StateController = stateController

    -- NetworkOwner of the machine this script is running on
    local localNetworkOwner

    if RunService:IsClient() then
        localNetworkOwner = Players.LocalPlayer.Name
    end

    -- Prevent lag from running updates on a character who isn't descendant of workspace
    character.AncestryChanged:Connect(function()
        -- If the connection is dead and we're descendant of workspace then rebind to RunService
        if character:IsDescendantOf(workspace) and character:GetAttribute("NetworkOwner") == localNetworkOwner then
            self:ResumeSimulation()
        else
            self:PauseSimulation()
        end

        -- This prevents automatic network ownership assignemnt
        if character:IsDescendantOf(workspace) then
            self:SetNetworkOwner(nil)
        end
    end)

    -- Detect when the Networkowner is changed
    character:GetAttributeChangedSignal("NetworkOwner"):Connect(function()
        local networkOwner = character:GetAttribute("NetworkOwner")

        if networkOwner == localNetworkOwner then
            self:ResumeSimulation()
        else
            self:PauseSimulation()
        end
    end)

    if character:GetAttribute("NetworkOwner") == localNetworkOwner then
        self:ResumeSimulation()
    end
end

function Cardinoid:Destructor()
    self.Aligner.Attachment1:Destroy()
    self.Character:Destroy()
    self.StateController:Destroy()
    self:PauseSimulation()
end

function Cardinoid:MountRig(rig)
    Output.assert(typeof(rig) == "Instance", "Expected Instance as Argument #1, instead got ".. typeof(rig))
    Output.assert(rig:FindFirstChild("HumanoidRootPart"), "Expected rig to have a HumanoidRootPart", nil, 1)

    self:UnmountRig()

    local character = self.Character
    local humanoidRootPart = character.HumanoidRootPart
    local rigParts = self.RigParts

    rig = rig:Clone()
    for _,v in pairs(rig:GetDescendants()) do
        if v:IsA("Motor6D") then
            if v.Part0.Name == "HumanoidRootPart" then
                v.Part0 = humanoidRootPart
            end
            if v.Part1.Name == "HumanoidRootPart" then
                v.Part1 = humanoidRootPart
            end
        elseif v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            table.insert(rigParts, v)
            v.Anchored = false
            v.Massless = true
            v.Parent = character
        end
    end

    humanoidRootPart.Size = rig.HumanoidRootPart.Size

    rig:Destroy()

    return self
end

function Cardinoid:UnmountRig()
    for _,limb in pairs(self.RigParts) do
        limb:Destroy()
    end
    return self
end

function Cardinoid:LoadAnimation(animation, name)
    Output.assert(typeof(animation) == "Instance" and animation:IsA("Animation"), "Expected Animation as Argument #1", nil, 1)

    name = name or animation.Name

    local animationTrack = self.Animator:LoadAnimation(animation)

    self.AnimationTracks[name] = self.AnimationTracks[name] or {}
    table.insert(self.AnimationTracks[name], animationTrack)

    return animationTrack
end

--[[
function Cardinoid:Unload(name)
    local animationTrack = self.AnimationTracks[name]

    Output.assert(animationTrack, "Could not find animation ".. name, nil, 1)

    animationTrack:Destroy()
end
]]

function Cardinoid:PlayAnimation(name, ...)
    local animationTracks = self.AnimationTracks[name]

    --Output.assert(animationTracks, "Could not find animation ".. name, nil, 1)

    if animationTracks then
        local numAnimationTracks = #animationTracks
        local animationTrack = animationTracks[math.random(1, numAnimationTracks)]

        animationTrack:Play(...)

        self.PlayingAnimations[name] = animationTrack
    end
    return self
end

function Cardinoid:StopAnimation(name, ...)
    local animationTrack = self.PlayingAnimations[name]

    --Output.assert(animationTrack, "Could not find animation ".. name, nil, 1)

    if animationTrack then
        animationTrack:Stop(...)

        self.PlayingAnimations[name] = nil
    end
    return self
end

function Cardinoid:StopAllAnimations(...)
    for _,animationTrack in pairs(self.Animator:GetPlayingAnimationTracks()) do
        animationTrack:Stop(...)
    end
    return self
end

function Cardinoid:Jump()
    if self.CanJump then
        self.JumpInput = true
    end
    return self
end

function Cardinoid:Sit(seat, offset)
    return self
end

function Cardinoid:MoveTo(target, timeout)
    timeout = timeout or MOVETO_TIMEOUT

    self.MoveToPosition = target
    self.MoveToTimeout = timeout
    self.MoveToTick = tick()
end

function Cardinoid:CancelMoveTo()
    self.MoveToPosition = nil
    self.MoveToTimeout = MOVETO_TIMEOUT
    self.MoveToTick = 0
end

function Cardinoid:SetNetworkOwner(networkOwner)
    Output.assert(networkOwner == nil or (typeof(networkOwner) == "Instance" and networkOwner:IsA("Player")), "Expected nil or Player as Argument #1, instead got ".. typeof(networkOwner), nil, 1)

    local character = self.Character
    if networkOwner then
        character:SetAttribute("NetworkOwner", networkOwner.Name)
    else
        character:SetAttribute("NetworkOwner", nil)
    end

    if character:IsDescendantOf(workspace) then
        character.HumanoidRootPart:SetNetworkOwner(networkOwner)
    end

    return self
end

function Cardinoid:PauseSimulation()
    local connection = self.PreSimConnection
    if connection then
        connection:Disconnect()
    end
end

function Cardinoid:ResumeSimulation()
    local connection = self.PreSimConnection
    if not connection or (connection and not connection.Connected) then
        -- TODO: Switch this to PreSimulation once enabled
        self.PreSimConnection = RunService.Heartbeat:Connect(updateCardinoid(self))
    end
end

function Cardinoid:start()
    Output = self:Load("Deus.Output")

    CharacterState = self:WrapModule(script.CharacterState, true, true)
    StateController = self:WrapModule(script.StateController, true, true)

    local None = self:Load("Deus.Symbol").get("None")

    self.Private = {
        PreSimConnection = None,

        Mover = None,
        Aligner = None,
        Animator = None,

        JumpInput = false,

        MoveToPosition = None,
        MoveToTimeout = 0,
        MoveToTick = 0,

        RigParts = {}
    }

    self.Readable = {
        Character = None,

        LastState = CharacterState.Idling,
        State = CharacterState.Idling, --CharacterState.Idling,

        PlayingAnimations = {},
        AnimationTracks = {},

        RootPart = None
    }

    self.Writable = {
        Health = 100,
        MaxHealth = 100,
        WalkSpeed = 16,
        JumpPower = 50,
        HipHeight = 2,

        LookInMoveDir = true,
        CanJump = true,
        CanClimb = true,

        MoveDir = Vector3.new(),
        LookDir = Vector3.new(),

        StateController = StateController
    }

    return self:Load("Deus.BaseObject").new(self)
end

return Cardinoid