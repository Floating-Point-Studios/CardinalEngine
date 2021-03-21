local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Output
local RemoteEvent
local RemoteFunction

local Remotes
local RemoteEvents = {}
local RemoteFunctions = {}

local function getRemoteEvent(name)
    local remote = RemoteEvents[name]
    if remote then
        return remote
    else
        if RunService:IsServer() then

            remote = RemoteEvent.new(name, Remotes.Events)
            RemoteEvents[name] = remote
            return remote

        elseif RunService:IsClient() then

            remote = Remotes.Events:WaitForChild(name)

            Output.assert(remote, "Could not find RemoteEvent ".. name, nil, 1)

            remote = RemoteEvent.new(remote)

            RemoteEvents[name] = remote
            return remote

        end
    end
end

local function getRemoteFunction(name)
    local remote = RemoteFunctions[name]
    if remote then
        return remote
    else
        if RunService:IsServer() then

            remote = RemoteFunction.new(name, Remotes.Functions)
            RemoteFunctions[name] = remote
            return remote

        elseif RunService:IsClient() then

            remote = Remotes.Functions:WaitForChild(name)

            Output.assert(remote, "Could not find RemoteFunction ".. name, nil, 1)

            remote = RemoteFunction.new(remote)

            RemoteFunctions[name] = remote
            return remote

        end
    end
end

local NetworkService = {}

function NetworkService:Connect(name, func)
    getRemoteEvent(name):Connect(func)
end

function NetworkService:Fire(name, ...)
    getRemoteEvent(name):Fire(...)
end

function NetworkService:OnInvoke(name, func)
    getRemoteFunction(name):OnInvoke(func)
end

function NetworkService:Invoke(name, ...)
    getRemoteFunction(name):Invoke(...)
end

function NetworkService:start()
    Output = self:Load("Deus.Output")
    RemoteEvent = self:Load("Deus.RemoteEvent")
    RemoteFunction = self:Load("Deus.RemoteFunction")

    if RunService:IsServer() then
        -- Setup of Remotes folder
        Remotes = Instance.new("Folder")
        Remotes.Name = "CardinalRemotes"

        Instance.new("Folder", Remotes).Name = "Events"
        Instance.new("Folder", Remotes).Name = "Functions"

        Remotes.Parent = ReplicatedStorage
    else
        Remotes = ReplicatedStorage:WaitForChild("CardinalRemotes")
    end
end

return NetworkService