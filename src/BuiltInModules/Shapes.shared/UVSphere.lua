local Mesh

local UVSphere = {}

function UVSphere.generate(stacks, sectors)
    local sphere = {
        StacksCount = stacks,
        SectorsCount = sectors,
        Stacks = {}
    }

    stacks = math.max(stacks or 1, 1)
    sectors = math.max(sectors or 1, 1)

    for u = 0, sectors do
        local stack = {}
        for v = 0, stacks do
            table.insert(stack, (
                -- Longitude
                CFrame.Angles(0, math.rad(u/(sectors + 1) * 360), 0) *
                -- Latitude
                CFrame.Angles(math.rad(v/(stacks) * 180 + 90), 0, 0) *
                -- Radius
                CFrame.new(0, 0, -1)).Position)
        end
        table.insert(sphere.Stacks, stack)
    end

    return sphere
end

function UVSphere.toPoints(sphere)
    local points = {}
    for _,stack in pairs(sphere.Stacks) do
        for _,point in pairs(stack) do
            table.insert(points, point)
        end
    end
    return points
end

function UVSphere.toMesh(sphere)
    local sphereMesh = Mesh.new()
    local stacksBorders = sphere.StacksCount + 1
    local sectorsBorders = sphere.SectorsCount + 1

    for u, stack in pairs(sphere.Stacks) do
        for v, vector in pairs(stack) do
            local vertexId = sphereMesh:AddVertex(vector)

            -- Longitudinal lines
            if u > 1 then
                if u == sectorsBorders then
                    -- Last stack
                    local previousStackId = vertexId % stacksBorders
                    if previousStackId == 0 then
                        previousStackId = stacksBorders
                    end

                    sphereMesh:AddLine(vertexId, previousStackId)
                    sphereMesh:AddLine(vertexId, vertexId - stacksBorders)
                else
                    -- Stack 2+
                    sphereMesh:AddLine(vertexId, vertexId - stacksBorders)
                end
            end

            -- Latitudinal lines
            local vertexIdMod = vertexId % stacksBorders
            if vertexIdMod > 1 or vertexIdMod == 0 then
                sphereMesh:AddLine(vertexId, vertexId - 1)
            end
        end
    end

    sphereMesh:MergeVerticesByDistance(0.0001)

    return sphereMesh
end

function UVSphere.start()
    Mesh = UVSphere:Load("Deus.Mesh")
end

return UVSphere