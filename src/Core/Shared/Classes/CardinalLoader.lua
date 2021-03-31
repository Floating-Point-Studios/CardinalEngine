local Deus

local Output
local TableUtils

local ReservedNames = {
    "Cardinal",
    "Deus"
}

-- Store the modules here instead of Deus
local Modules = {}
local ModulesRefs = {}

local CardinalLoader = {
    ClassName = "CardinalLoader",
    Extendable = false,
    Events = {}
}

function CardinalLoader:Register(module, moduleName)
    moduleName = moduleName or module.Name
    Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register module", moduleName)
    Deus:Register(module, moduleName)
end

function CardinalLoader:Load(...)
    return Deus:Load(...)
end

function CardinalLoader:WrapModule(...)
    return Deus:WrapModule(...)
end

function CardinalLoader:WrapFunction(...)
    return Deus:WrapFunction(...)
end

function CardinalLoader:IsRegistered(...)
    return Deus:IsRegistered(...)
end

function CardinalLoader:GetMainModule()
    return Deus.GetMainModule(self)
end

function CardinalLoader:GetInitTick()
    return Deus.GetInitTick(self)
end

function CardinalLoader:GetStartTick()
    return Deus.GetStartTick(self)
end

function CardinalLoader:IsPluginFramework()
    return Deus:IsPluginFramework()
end

--[[
function CardinalLoader:GetModules()
    local modulesData = {}

    for path, module in pairs(Modules) do
        local moduleData = {
            InitTick = -1,
            StartTick = -1,
            IsInitialized = false,
            IsStarted = false
        }

        if type(module) == "userdata" or type(module) == "function" then
            if type(module) == "userdata" then
                module = ModulesRefs[module]
            end

            moduleData.Module = module
            moduleData.IsInitialized = true

            print(getmetatable(module))
        end

        modulesData[path] = moduleData
    end
end
]]

function CardinalLoader:start()
    -- Proxy prevents modules from accessing Deus
    Deus = getmetatable(getmetatable(self).__index).__index

    Output = self:Load("Deus.Output")
    TableUtils = self:Load("Deus.TableUtils")

    local DeusModules = Deus:GetModules()
    for path, module in pairs(DeusModules) do
        if type(module) == "table" then
            local proxy = TableUtils.lock(module)
            Modules[path] = proxy
            ModulesRefs[proxy] = module
        else
            Modules[path] = module
        end
        DeusModules[path] = nil
    end

    -- We force these metamethods to run by transferring the Deus modules into our own modules variable which now allows us to detect every change being made by Deus
    setmetatable(
        DeusModules,
        {
            __index = function(_, path)
                return Modules[path]
            end,
            __newindex = function(_, path, module)
                if type(module) == "table" then
                    local proxy = TableUtils.lock(module)
                    Modules[path] = proxy
                    ModulesRefs[proxy] = module
                else
                    Modules[path] = module
                end
            end
        }
    )

    self.Private = {}

    self.Readable = {}

    self.Writable = {}

    return self:Load("Deus.BaseObject").new(self)
end

return CardinalLoader