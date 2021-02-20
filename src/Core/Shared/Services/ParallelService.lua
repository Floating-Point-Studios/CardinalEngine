local Workers

local ParallelService = {}

function ParallelService.run(module, funcName, ...)
    local worker = Workers:Get()

    local result = worker:RunJob(module, funcName, ...)

    Workers:Add(worker)

    return unpack(result)
end

function ParallelService:start()
    local Worker = self:Load("Deus.Worker")

    Workers = self:Load("Deus.Pool").new(function()
        return Worker.new()
    end)
end

return ParallelService