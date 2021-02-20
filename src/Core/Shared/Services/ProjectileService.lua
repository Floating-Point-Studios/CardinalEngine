-- This service creates a pool of projectile objects then reuses them

local BasicProjectilePool
local DragProjectilePool
local LaserProjectilePool

local InternalAccessTable = setmetatable({}, {__mode = "v"})

-- Override the projectile's destroy function to have them re-inserted into the pool
local function ProjectileDestroyOverride(self)
    if self.ClassName == "Deus.BasicProjectile" then
        BasicProjectilePool:Add(self)
    elseif self.ClassName == "Deus.DragProjectile" then
        DragProjectilePool:Add(self)
    elseif self.ClassName == "Deus.LaserProjectile" then
        LaserProjectilePool:Add(self)
    end
end

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

-- Runs the real destroy function on all projectiles currently in pools
function ProjectileService.clearBasicProjectilePool()
    for _,v in pairs(BasicProjectilePool:GetAll()) do
        v.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = nil
        v:Destroy()
    end
end

function ProjectileService.clearDragProjectilePool()
    for _,v in pairs(DragProjectilePool:GetAll()) do
        v.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = nil
        v:Destroy()
    end
end

function ProjectileService.clearLaserProjectilePool()
    for _,v in pairs(LaserProjectilePool:GetAll()) do
        v.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = nil
        v:Destroy()
    end
end

function ProjectileService:start()
    local Projectiles = self:Load("Deus.Projectiles")
    local Pool = self:Load("Deus.Pool")

    BasicProjectilePool = Pool.new(function()
        local projectile = Projectiles.newBasicProjectile()
        projectile.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = ProjectileDestroyOverride

        InternalAccessTable[projectile.Proxy] = projectile

        return projectile
    end)

    DragProjectilePool = Pool.new(function()
        local projectile = Projectiles.newDragProjectile()
        projectile.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = ProjectileDestroyOverride

        InternalAccessTable[projectile.Proxy] = projectile

        return projectile
    end)

    LaserProjectilePool = Pool.new(function()
        local projectile = Projectiles.newLaserProjectile()
        projectile.Internal.DEUSOBJECT_LockedTables.Methods.Destroy = ProjectileDestroyOverride

        InternalAccessTable[projectile.Proxy] = projectile

        return projectile
    end)
end

return ProjectileService