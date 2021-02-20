local Enumeration

local NPCState = Enumeration.NPCState

local function makeAnimation(id)
    local anim = Instance.new("Animation")
    anim.AnimationId = id
    return anim
end

local Animations = {
    Walk = {
        State = NPCState.Walking,
        Variants = {
            WalkAnim = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=913402848")
            }
        }
    },

    --[[
    Run = {
        Variants = {
            RunAnim = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=913376220")
            }
        }
    },
    --]]

    Idle = {
        State = NPCState.Idle,
        Variants = {
            IdleAnim1 = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=507766388"),
                Weight = 9
            },
            IdleAnim2 = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=507766666")
            }
        }
    },

    Swim = {
        State = NPCState.Swimming,
        Variants = {
            SwimAnim = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=913384386")
            }
        }
    },

    SwimIdle = {
        State = NPCState.SwimIdle,
        Variants = {
            SwimIdleAnim = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=913389285")
            }
        }
    },

    Jump = {
        State = NPCState.Jumping,
        Variants = {
            JumpAnim = {
                Animation = makeAnimation("http://www.roblox.com/asset/?id=507765000")
            }
        }
    }
}

local DefaultAnimations = {}

function DefaultAnimations:start()
    Enumeration = self:Load("Deus.Enumeration")

    return Animations
end

return DefaultAnimations