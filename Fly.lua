-- Fly.lua
local Fly = { active = false, connection = nil, speed = 50 }

local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.Parent = hrp

    Fly.connection = RunService.RenderStepped:Connect(function()
        if not Fly.active or not hrp.Parent then
            if bodyVel then bodyVel:Destroy() end
            if Fly.connection then Fly.connection:Disconnect() Fly.connection = nil end
            if hum then hum.PlatformStand = false end
            return
        end
        local move = Vector3.new(
            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.E) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.Q) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )
        if move.Magnitude > 0 then move = move.Unit end
        local cam = workspace.CurrentCamera
        local vel = (cam.CFrame.RightVector * move.X + cam.CFrame.UpVector * move.Y + cam.CFrame.LookVector * move.Z) * Fly.speed
        if bodyVel then bodyVel.Velocity = vel end
    end)
end

function Fly.Start(speedValue)
    if Fly.active then return end
    Fly.active = true
    Fly.speed = speedValue or 50
    startFly()
end

function Fly.Stop()
    Fly.active = false
    if Fly.connection then Fly.connection:Disconnect() Fly.connection = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        local bv = char:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyVelocity")
        if bv then bv:Destroy() end
    end
end

function Fly.SetSpeed(v) Fly.speed = v end

return Fly