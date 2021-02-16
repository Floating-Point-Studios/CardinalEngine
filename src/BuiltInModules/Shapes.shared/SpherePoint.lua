local MathUtils
local VectorUtils

local SpherePoint = {}

function SpherePoint.generate(numPoints)
    local spherePoints = {}

    for i = 1, numPoints do
        local longitude = MathUtils.ga * i
        longitude /= 2 * math.pi
        longitude -= math.floor(longitude)
        longitude *= 2 * math.pi

        if (longitude > math.pi) then
            longitude -= 2 * math.pi
        end

        local latitude = math.asin(-1 + 2 * i / numPoints)

        table.insert(spherePoints, {latitude, longitude})
    end

    return spherePoints
end

function SpherePoint.llToVector3(points, radius)
    local spherePoints = {}

    for _,point in pairs(points) do
        table.insert(spherePoints, VectorUtils.llarToWorld(point[1], point[2], 0, radius))
    end

    return spherePoints
end

function SpherePoint.start()
    MathUtils = SpherePoint:Load("Deus.MathUtils")
    VectorUtils = SpherePoint:Load("Deus.VectorUtils")
end

return SpherePoint