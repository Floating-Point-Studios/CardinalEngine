--[[
    Ported from
    https://github.com/LPGhatguy/luanoid
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")

local Deus = shared.Deus

local BaseObject = Deus:Load("Deus.BaseObject")
local InstanceUtils = Deus:Load("Deus.InstanceUtils")

local R15RigTemplate
local NPCState = require(script.NPCState)
local UpdateHandler = require(script.UpdateHandler)
local DefaultAnimations = require(script.DefaultAnimations)

if RunService:IsServer() then
    R15RigTemplate = InsertService:LoadAsset(6324529033):WaitForChild("R15Rig")
    R15RigTemplate.Parent = ReplicatedStorage
else
    R15RigTemplate = ReplicatedStorage:WaitForChild("R15Rig")
end

return BaseObject.new(
    {
        ClassName = "Cardinal.NonPlayerCharacter",

        Constructor = function(self, rigTemplate, animations)
            local PrivateProperties = self.Internal.DEUSOBJECT_Properties
            local ReadOnlyProperties = self.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties
            local ReadAndWriteProperties = self.Internal.DEUSOBJECT_LockedTables.ReadAndWriteProperties

            -- Character setup
            local character = (rigTemplate or R15RigTemplate):Clone()
            local humanoidRootPart = character.HumanoidRootPart
            local animationController = Instance.new("AnimationController")
            local vectorForce = Instance.new("VectorForce")

            -- Controller setup
            animationController.Parent = character
            vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            vectorForce.ApplyAtCenterOfMass = true
            vectorForce.Attachment0 = humanoidRootPart.RootRigAttachment
            vectorForce.Force = Vector3.new()
            vectorForce.Parent = humanoidRootPart

            local alignOrientation = Instance.new("AlignOrientation", humanoidRootPart)
            alignOrientation.Attachment0 = humanoidRootPart.RootRigAttachment
            alignOrientation.Attachment1 = workspace.Terrain.Attachment

            ReadOnlyProperties.Character = character
            PrivateProperties.AnimationController = animationController
            PrivateProperties.VectorForce = vectorForce

            -- Spawning
            humanoidRootPart.CFrame = CFrame.new(0, 20, 0)
            character.Parent = workspace

            InstanceUtils.anchor(character, false)

            -- Animation loading
            animations = animations or DefaultAnimations
            for _,animationData in pairs(animations) do
                local state = animationData.State
                for animName, animVariant in pairs(animationData.Variants) do
                    self:LoadAnimation(animVariant.Animation, animName, animVariant.Speed, animVariant.Weight, state)
                end
            end

            -- Character Updating
            PrivateProperties.UpdateConnection = RunService.Heartbeat:Connect(function(dt)
                local state = PrivateProperties.UpdateHandler(self, dt)

                if self:SetState(state) then

                    local stateAnimations = PrivateProperties.StateAnimations[state]
                    if stateAnimations then
                        local track = stateAnimations[math.random(1, #stateAnimations)]
                        if track then
                            track:Play()
                        end
                    end

                end
            end)
        end,

        Methods = {
            -- If a NPCState is provided the animation will be randomly selected when NPC enters state
            LoadAnimation = function(self, _, animation, animationName, defaultSpeed, defaultWeight, state)
                local PrivateProperties = self.Internal.DEUSOBJECT_Properties

                local track = PrivateProperties.AnimationController:LoadAnimation(animation)
                track:AdjustSpeed(defaultSpeed or 1)
                track:AdjustWeight(defaultWeight or 1)

                PrivateProperties.AnimationTracks[animationName or animation.Name] = {
                    Track = track,
                    DefaultSpeed = defaultSpeed,
                    DefaultWeight = defaultWeight
                }

                if state then
                    local stateAnimations = PrivateProperties.StateAnimations[state]
                    if not stateAnimations then
                        stateAnimations = {}
                        PrivateProperties.StateAnimations[state] = stateAnimations
                    end

                    table.insert(stateAnimations, track)
                end
            end,

            UnloadAnimation = function(self, _, animationName)
                self.Internal.DEUSOBJECT_Properties.AnimationTracks[animationName]:Destroy()
            end,

            PlayAnimation = function(self, _, animationName, speed, weight)
                local track = self.Internal.DEUSOBJECT_Properties.AnimationTracks[animationName]

                if speed then
                    track:AdjustSpeed(speed)
                end
                if weight then
                    track:AdjustWeight(weight)
                end

                track:Play()
            end,

            StopAnimation = function(self, _, animationName)
                self.Internal.DEUSOBJECT_Properties.AnimationTracks[animationName]:Stop()
            end,

            GetAnimationTrack = function(self, _, animationName)
                return self.Internal.DEUSOBJECT_Properties.AnimationTracks[animationName]
            end,

            SetState = function(self, _, newState)
                local Events = self.Internal.DEUSOBJECT_LockedTables.Events
                local ReadOnlyProperties = self.Internal.DEUSOBJECT_LockedTables.ReadOnlyProperties
                local curState = ReadOnlyProperties.State

                if newState ~= curState then
                    ReadOnlyProperties.State = newState
                    Events.StateChanged:Fire(newState, curState)
                    return true
                end
                return false
            end,

            ApplyHumanoidDescription = function(self, _, humanoidDescription)

            end
        },

        Events = {"StateChanged"},

        PrivateProperties = {
            UpdateHandler = UpdateHandler,
            StateAnimations = {},
            AnimationTracks = {},
            UpdateConnection = nil
        },

        PublicReadOnlyProperties = {
            Character = nil,
            State = NPCState.Idle
        },

        PublicReadAndWriteProperties = {
            MaxHealth = 100,
            Health = 100,

            WalkSpeed = 16,

            JumpPower = 50,

            HipHeight = 2,

            Jump = false,

            MoveDir = Vector3.new()
        }
    }
)