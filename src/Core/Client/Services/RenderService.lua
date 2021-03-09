local RunService = game:GetService("RunService")

local TableUtils

local FPSData = {
    Framerates = {},
    FPSAveraged = 0,
    FPS = 0,
}

local RenderService = {}

-- Not guaranteed to be accurate
function RenderService:GetFPS(average)
    if average then
        return FPSData.FPSAveraged
    else
        return FPSData.FPS
    end
end

function RenderService:start()
    TableUtils = self:Load("Deus.TableUtils")

    -- Switch to PreRender once that's enabled
    RunService:BindToRenderStep("DeusRenderServiceFPSTracker", Enum.RenderPriority.Last.Value, function(dt)
        local fps = 1/dt

        table.insert(FPSData.Framerates, fps)

        if #FPSData.Framerates > 5 then
            table.remove(FPSData.Framerates, 1)
        end

        FPSData.FPSAveraged = TableUtils.average(FPSData.Framerates)
        FPSData.FPS = fps
    end)
end

return RenderService