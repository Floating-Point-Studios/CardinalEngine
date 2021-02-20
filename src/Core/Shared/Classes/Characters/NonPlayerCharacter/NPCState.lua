local NPCState = {}

function NPCState:start()
    return self:Load("Deus.Enumeration").addEnum(
        "NPCState",
        {
            Idle = 0,
            Walking = 1,
            Falling = 2,
            Jumping = 3,
            Swimming = 4,
            SwimIdle = 5,
            Climbing = 6
        }
    )
end

return NPCState