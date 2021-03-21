# PID

Instructions to tune can be found [here](http://robotsforroboticists.com/pid-control/){target=blank}.

## Creating

```lua
local PID = Deus:Load("Deus.PID")

local pid = PID.new(kP, kI, kD, desiredValue, bias)
```

## Usage

```lua
local error = pid:Update(actualValue)
```

## Properties

| Type      | Name              |
|           |                   |
| `number`  | KP                |
| `number`  | KI                |
| `number`  | KD                |
| `number`  | DesiredValue      |
| `number`  | Bias              |
| `number`  | _lastUpdate       |
| `number`  | _errorPrior       |
| `number`  | _integralPrior    |