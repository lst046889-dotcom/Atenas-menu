local Hitbox = { active = false, color = Color3.fromRGB(255,0,0), fakeHitboxes = {} }
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local connection = nil

local function apply()
    local size = Options.HitboxSize.Value
    local formato = Options.HitboxFormato.Value
    for _, v in pairs(Players:GetPlayers()) do
        if v == player or not v.Character then continue end
        local alvo = (Options.HitboxAlvo.Value == "Cabeça") and v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("UpperTorso") or v.Character:FindFirstChild("Torso")
        if not alvo then continue end
        local fake = Hitbox.fakeHitboxes[v]
        if not fake or not fake.Parent then
            fake = Instance.new("Part")
            fake.Name = "_HitboxFake"
            fake.Anchored = true
            fake.CanCollide = false
            fake.Massless = true
            fake.CastShadow = false
            fake.Parent = workspace
            Hitbox.fakeHitboxes[v] = fake
        end
        fake.CFrame = alvo.CFrame
        if formato == "Esfera" then fake.Shape = Enum.PartType.Ball
        elseif formato == "Quadrado" then fake.Shape = Enum.PartType.Block
        else fake.Shape = Enum.PartType.Cylinder end
        fake.Size = Vector3.new(size, size, size)
        fake.Transparency = 0.7
        fake.Material = Enum.Material.Neon
        fake.Color = Hitbox.color
    end
end

function Hitbox.Start()
    if Hitbox.active then return end
    Hitbox.active = true
    connection = RunService.Heartbeat:Connect(apply)
end

function Hitbox.Stop()
    Hitbox.active = false
    if connection then connection:Disconnect() connection = nil end
    for _, f in pairs(Hitbox.fakeHitboxes) do if f then f:Destroy() end end
    Hitbox.fakeHitboxes = {}
end

function Hitbox.SetColor(c) Hitbox.color = c end
function Hitbox.Reset() Hitbox.Stop(); Hitbox.Start() end

return Hitbox