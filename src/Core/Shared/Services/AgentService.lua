local PathfindingService = game:GetService("PathfindingService")

local Cardinoid

local AgentService = {}

function AgentService:Spawn(agentData)
    local agent = Cardinoid.new(agentData)

    if type(agentData) == "table" then
        local position = agentData.Position
        if position then
            agent.Character.HumanoidRootPart.CFrame = CFrame.new(position)
        end

        local rig = agentData.Rig
        if rig then
            agent:MountRig(rig)
        end

        local parent = agentData.Parent
        if parent then
            agent.Character.Parent = parent
        end

        local networkOwner = agentData.NetworkOwner
        if networkOwner then
            agent:SetNetworkOwner(networkOwner)
        end
    end

    return agent
end

function AgentService:MoveTo(agent, target)
    local character = agent.Character
    local humanoidRootPart = character.HumanoidRootPart
    local agentSize = character:GetExtentsSize()
    local path = PathfindingService:CreatePath(
        {
            AgentRadius = math.max(agentSize.X, agentSize.Z),
            AgentHeight = agentSize.Y,
            AgentCanJump = agent.CanJump
        }
    )

    if typeof(target) == "Instance" then
        target = target.Position
    end

    path:ComputeAsync(humanoidRootPart.Position, target)
    local waypoints = path:GetWaypoints()

    -- Failed to find path
    if #waypoints == 0 then
        return false
    end

    for _,waypoint in pairs(waypoints) do
        agent:MoveTo(waypoint.Position)

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            self:Load("Deus.VisualDebug").drawSphere(waypoint.Position, 1, Color3.new(0, 1, 0))
        else
            self:Load("Deus.VisualDebug").drawSphere(waypoint.Position, 1, Color3.new(1, 0, 0))
        end

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            agent:Jump()
        end

        if not agent.MoveToFinished:Wait() then
            return false
        end
    end

    return true
end

function AgentService:start()
    Cardinoid = self:Load("Cardinal.Cardinoid")
end

return AgentService