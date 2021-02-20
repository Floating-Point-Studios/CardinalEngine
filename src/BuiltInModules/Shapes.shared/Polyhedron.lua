local Mesh

-- Points from https://en.m.wikipedia.org/wiki/Tetrahedron
local TetrahedronPoints = {
    Regular = {
        Vector3.new(math.sqrt(8/9), 0, -1/3),
        Vector3.new(-math.sqrt(2/9), math.sqrt(2/3), -1/3),
        Vector3.new(-math.sqrt(2/9), -math.sqrt(2/3), -1/3),
        Vector3.new(0, 0, 1)
    },
    Demicube1 = {
        Vector3.new(1, 1, 1),
        Vector3.new(1, -1, -1),
        Vector3.new(-1, 1, -1),
        Vector3.new(-1, -1, 1)
    },
    Demicube2 = {
        Vector3.new(-1, -1, -1),
        Vector3.new(-1, 1, 1),
        Vector3.new(1, -1, 1),
        Vector3.new(1, 1, -1)
    }
}

local Tetrahedrons

local Polyhedron = {}

function Polyhedron.subdivide(polyhedron, triId)
    triId = tostring(triId)

    local triCount = polyhedron.TriangleCount
    local tri = polyhedron.Triangles[triId]
    local midpoints = {
        (tri[1] + tri[3]) / 2,
        (tri[2] + tri[3]) / 2,
        (tri[1] + tri[2]) / 2
    }

    polyhedron.Triangles[tostring(triCount + 1)] = {
        midpoints[1],
        midpoints[2],
        midpoints[3]
    }
    polyhedron.Triangles[tostring(triCount + 2)] = {
        tri[1],
        midpoints[1],
        midpoints[3]
    }
    polyhedron.Triangles[tostring(triCount + 3)] = {
        tri[2],
        midpoints[2],
        midpoints[3]
    }
    polyhedron.Triangles[tostring(triCount + 4)] = {
        tri[3],
        midpoints[1],
        midpoints[2],
    }

    polyhedron.TriangleCount += 4
    polyhedron.Triangles[triId] = nil
end

function Polyhedron.subdivideAll(polyhedron)
    local triCountStart = polyhedron.TriangleCount
    for triId in pairs(polyhedron.Triangles) do
        if tonumber(triId) <= triCountStart then
            Polyhedron.subdivide(polyhedron, triId)
        end
    end
    return polyhedron
end

function Polyhedron.generate(subdivisions, tetrahedronType)
    local polyhedron

    -- TriangleCount is used internally only for Id assignment and does not count the number of triangles
    if not tetrahedronType or tetrahedronType == Tetrahedrons.Regular then
        polyhedron = {
            TriangleCount = 4,
            Triangles = {
                ["1"] = {TetrahedronPoints.Regular[1], TetrahedronPoints.Regular[2], TetrahedronPoints.Regular[4]},
                ["2"] = {TetrahedronPoints.Regular[1], TetrahedronPoints.Regular[2], TetrahedronPoints.Regular[3]},
                ["3"] = {TetrahedronPoints.Regular[2], TetrahedronPoints.Regular[3], TetrahedronPoints.Regular[4]},
                ["4"] = {TetrahedronPoints.Regular[1], TetrahedronPoints.Regular[3], TetrahedronPoints.Regular[4]}
            }
        }
    elseif tetrahedronType == Tetrahedrons.Demicube1 then
        polyhedron = {
            TriangleCount = 4,
            Triangles = {
                ["1"] = {TetrahedronPoints.Demicube1[1], TetrahedronPoints.Demicube1[2], TetrahedronPoints.Demicube1[4]},
                ["2"] = {TetrahedronPoints.Demicube1[1], TetrahedronPoints.Demicube1[2], TetrahedronPoints.Demicube1[3]},
                ["3"] = {TetrahedronPoints.Demicube1[2], TetrahedronPoints.Demicube1[3], TetrahedronPoints.Demicube1[4]},
                ["4"] = {TetrahedronPoints.Demicube1[1], TetrahedronPoints.Demicube1[3], TetrahedronPoints.Demicube1[4]}
            }
        }
    elseif tetrahedronType == Tetrahedrons.Demicube2 then
        polyhedron = {
            TriangleCount = 4,
            Triangles = {
                ["1"] = {TetrahedronPoints.Demicube2[1], TetrahedronPoints.Demicube2[2], TetrahedronPoints.Demicube2[4]},
                ["2"] = {TetrahedronPoints.Demicube2[1], TetrahedronPoints.Demicube2[2], TetrahedronPoints.Demicube2[3]},
                ["3"] = {TetrahedronPoints.Demicube2[2], TetrahedronPoints.Demicube2[3], TetrahedronPoints.Demicube2[4]},
                ["4"] = {TetrahedronPoints.Demicube2[1], TetrahedronPoints.Demicube2[3], TetrahedronPoints.Demicube2[4]}
            }
        }
    end

    for i = 1, (subdivisions or 0) do
        Polyhedron.subdivideAll(polyhedron)
    end

    return polyhedron
end

function Polyhedron.toUnitSphere(polyhedron)
    for _,tri in pairs(polyhedron.Triangles) do
        tri[1] = tri[1].Unit
        tri[2] = tri[2].Unit
        tri[3] = tri[3].Unit
    end
    return polyhedron
end

function Polyhedron.toPoints(polyhedron)
    local points = {}
    for _,tri in pairs(polyhedron.Triangles) do
        table.insert(points, tri[1])
        table.insert(points, tri[2])
        table.insert(points, tri[3])
    end
    return points
end

function Polyhedron.toMesh(polyhedron)
    local polyhedronMesh = Mesh.new()
    for _,tri in pairs(polyhedron.Triangles) do
        local vertexId1 = polyhedronMesh:AddVertex(tri[1])
        local vertexId2 = polyhedronMesh:AddVertex(tri[2])
        local vertexId3 = polyhedronMesh:AddVertex(tri[3])

        polyhedronMesh:AddLine(vertexId1, vertexId2)
        polyhedronMesh:AddLine(vertexId2, vertexId3)
        polyhedronMesh:AddLine(vertexId1, vertexId3)
    end

    polyhedronMesh:MergeVerticesByDistance(0.0001)

    return polyhedronMesh
end

function Polyhedron:start()
    Mesh = self:Load("Deus.Mesh")

    Tetrahedrons = self:Load("Deus.Enumeration").addEnum(
        "Tetrahedron",
        {
            Regular = 1,
            Demicube1 = 2,
            Demicube2 = 3
        }
    )
end

return Polyhedron