# VisualDebug

Debug library for 3D space.

## drawBox

```lua
-- CFrame, Size (number), Color3
local boxAdornment = VisualDebug.drawBox(CFrame.new(0, 10, 0), 10, Color3.fromRGB(60, 120, 240))
```

## drawSphere

```lua
-- Position (Vector3), Radius (number), Color3
local sphereAdornment = VisualDebug.drawSphere(Vector3.new(0, 10, 0), 10, Color3.fromRGB(60, 120, 240))
```

## drawLine

```lua
-- Start (Vector3), End (Vector3), Color3
local lineAdornment = VisualDebug.drawLine(Vector3.new(0, 10, 0), Vector3.new(10, 20, 10), Color3.fromRGB(60, 120, 240))
```

## drawPath

```lua
-- Points (table), Radius (number), Color3
local pathAdornmentFolder = VisualDebug.drawPath(points, 1, Color3.fromRGB(60, 120, 240))
```

## drawArrow

```lua
-- Start (Vector3), Direction (Vector3), Radius(number), Color3
local arrowAdornmentFolder = VisualDebug.drawArrow(Vector3.new(0, 10, 0), Vector3.new(0, 10, 0), 1, Color3.fromRGB(60, 120, 240))
```