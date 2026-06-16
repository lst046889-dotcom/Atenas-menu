local SilentAim = { active = false, target = nil, circle = nil, oldIndex = nil }
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local function getTargetPart(char)
    if Options.SilentAimParte.Value == "Cabeça" then return char:FindFirstChild("Head")
    else return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
end

local function isInFOV(point, fov)
    local cf = camera.CFrame
    local dot = (point - cf.Position).Unit:Dot(cf.LookVector)
    local angle = math.acos(math.clamp(dot, -1, 1)) * (180 / math.pi)
    return angle <= (fov / 2)
end

local function findTarget()
    local myChar = player.Character
    if not myChar then return nil end
    local best, bestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        local char = p.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = getTargetPart(char)
        if part and isInFOV(part.Position, Options.SilentAimFOV.Value) then
            local dist = (part.Position - myChar.HumanoidRootPart.Position).Magnitude
            if dist < bestDist then bestDist = dist best = char end
        end
    end
    return best
end

local function setupHook()
    local mouse = player:GetMouse()
    SilentAim.oldIndex = hookmetamethod(game, "__index", function(self, key)
        if self == mouse and key == "Hit" and SilentAim.active and SilentAim.target then
            local part = getTargetPart(SilentAim.target)
            if part then return part.CFrame + Vector3.new(math.random(-10,10)/10, math.random(-10,10)/10, math.random(-10,10)/10) end
        end
        return SilentAim.oldIndex(self, key)
    end)
end

local function updateCircle()
    if not SilentAim.circle then return end
    if not SilentAim.active or not Toggles.ShowFOVCircle.Value then
        SilentAim.circle.Visible = false
        return
    end
    SilentAim.circle.Visible = true
    if SilentAim.target and SilentAim.target.Character then
        local torso = SilentAim.target.Character:FindFirstChild("UpperTorso")
        if torso then
            local pos, on = camera:WorldToViewportPoint(torso.Position)
            if on then SilentAim.circle.Position = Vector2.new(pos.X, pos.Y) end
        end
    else
        SilentAim.circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    end
    SilentAim.circle.Radius = (Options.SilentAimFOV.Value / 100) * 300
end

function SilentAim.Start()
    if SilentAim.active then return end
    SilentAim.active = true
    setupHook()
    if typeof(Drawing) == "table" then
        SilentAim.circle = Drawing.new("Circle")
        SilentAim.circle.Thickness = 2
        SilentAim.circle.Color = Color3.fromRGB(255,255,255)
        SilentAim.circle.Filled = false
    end
    task.spawn(function()
        while SilentAim.active do
            if Toggles.SilentAim.Value then
                SilentAim.target = findTarget()
                updateCircle()
            else
                SilentAim.target = nil
                updateCircle()
            end
            task.wait(0.05)
        end
    end)
end

function SilentAim.Stop()
    SilentAim.active = false
    if SilentAim.circle then SilentAim.circle:Remove() SilentAim.circle = nil end
    if SilentAim.oldIndex then hookmetamethod(game, "__index", SilentAim.oldIndex) end
    SilentAim.target = nil
end

return SilentAim