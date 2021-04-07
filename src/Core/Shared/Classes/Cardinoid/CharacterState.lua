local CharacterState = {}

function CharacterState:start()
    return self:Load("Deus.Enumeration").addEnum(
    "CharacterState",
        {
            Unsimulated = 0,
            Idling = 1,
            Walking = 2,
            Jumping = 3,
            -- Sitting = 4,
            -- Falling = 5,
            -- Swimming = 6,
            -- SwimIdling = 7,
            -- Climbing = 8
        }
    )
end

return CharacterState