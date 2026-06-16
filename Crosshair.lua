-- Crosshair.lua
local Crosshair = { active = false, circle = nil, dot = nil }

local camera = workspace.CurrentCamera

local function create()
    if typeof(Drawing) ~= "table" then return end
    Crosshair.circle = Drawing.new("Circle")
    Crosshair.circle.Visible = true
    Crosshair.circle.Radius = 8
    Crosshair.circle.Thickness = 1.5
    Crosshair.circle.Color = Color3.fromRGB(255, 255, 255)
    Crosshair.circle.Filled = false
    Crosshair.circle.Transparency = 0.5
    Crosshair.circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    Crosshair.dot = Drawing.new("Square")
    Crosshair.dot.Visible = true
    Crosshair.dot.Size = Vector2.new(2, 2)
    Crosshair.dot.Color = Color3.fromRGB(255, 0, 0)
    Crosshair.dot.Filled = true
    Crosshair.dot.Position = Vector2.new(camera.ViewportSize.X/2 - 1, camera.ViewportSize.Y/2 - 1)
end

local function destroy()
    if Crosshair.circle then Crosshair.circle:Remove() Crosshair.circle = nil end
    if Crosshair.dot then Crosshair.dot:Remove() Crosshair.dot = nil end
end

function Crosshair.Start()
    if Crosshair.active then return end
    Crosshair.active = true
    create()
    game:GetService("RunService").RenderStepped:Connect(function()
        if not Crosshair.active then return end
        if Crosshair.circle then
            Crosshair.circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        end
        if Crosshair.dot then
            Crosshair.dot.Position = Vector2.new(camera.ViewportSize.X/2 - 1, camera.ViewportSize.Y/2 - 1)
        end
    end)
end

function Crosshair.Stop()
    Crosshair.active = false
    destroy()
end

return Crosshair