-- This service creates a pool of projectile objects then reuses them.

local Output

local BasicProjectilePool
local DragProjectilePool
local LaserProjectilePool

local InternalAccessTable = setmetatable({}, {__mode = "v"})

local ProjectileService = {}

function ProjectileService.newBasicProjectile(...)
    local projectile = BasicProjectilePool:Get()

    -- Check if the projectile is a re-used projectile if so we won't have internal access to reconstruct it
    if projectile:IsInternalAccess() then
        return projectile:Reconstruct(...).Proxy
    else
        return InternalAccessTable[projectile]:Reconstruct(...).Proxy
    end
end

function ProjectileService.newDragProjectile(...)
    local projectile = DragProjectilePool

    if projectile:IsInternalAccess() then
        return projectile:Reconstruct(...).Proxy
    else
        return InternalAccessTable[projectile]:Reconstruct(...).Proxy
    end
end

function ProjectileService.newLaserProjectile(...)
    local projectile = LaserProjectilePool:Get()

    if projectile:IsInternalAccess() then
        return projectile:Reconstruct(...).Proxy
    else
        return InternalAccessTable[projectile]:Reconstruct(...).Proxy
    end
end

-- Returns the projectile to the pool once done being used
function ProjectileService.returnToPool(projectile)
    Output.assert(typeof(projectile) == "userdata" and projectile:IsA("BaseObject"), "Object is not a DeusObject")

    if projectile.ClassName == "Deus.BasicProjectile" then
        BasicProjectilePool:Add(projectile)
    elseif projectile.ClassName == "Deus.DragProjectile" then
        DragProjectilePool:Add(projectile)
    elseif projectile.ClassName == "Deus.LaserProjectile" then
        LaserProjectilePool:Add(projectile)
    else
        Output.error("Object is not a projectile")
    end
end

-- Runs the real destroy function on all projectiles currently in pools
function ProjectileService.clearBasicProjectilePool()
    for _,v in pairs(BasicProjectilePool:GetAll()) do
        v:Destroy()
    end
end

function ProjectileService.clearDragProjectilePool()
    for _,v in pairs(DragProjectilePool:GetAll()) do
        v:Destroy()
    end
end

function ProjectileService.clearLaserProjectilePool()
    for _,v in pairs(LaserProjectilePool:GetAll()) do
        v:Destroy()
    end
end

function ProjectileService:start()
    Output = self:Load("Deus.Output")

    local Projectiles = self:Load("Deus.Projectiles")
    local Pool = self:Load("Deus.Pool")

    BasicProjectilePool = Pool.new(function()
        local projectile = Projectiles.newBasicProjectile()
        InternalAccessTable[projectile.Proxy] = projectile
        return projectile
    end)

    DragProjectilePool = Pool.new(function()
        local projectile = Projectiles.newDragProjectile()
        InternalAccessTable[projectile.Proxy] = projectile
        return projectile
    end)

    LaserProjectilePool = Pool.new(function()
        local projectile = Projectiles.newLaserProjectile()
        InternalAccessTable[projectile.Proxy] = projectile
        return projectile
    end)
end

return ProjectileService