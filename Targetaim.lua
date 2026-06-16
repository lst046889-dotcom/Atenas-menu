-- Targetaim.lua (apenas lock no alvo mais próximo)
local Targetaim = { active = false, currentTarget = nil }

local player = game:GetService("Players").LocalPlayer

function Targetaim.GetClosest()
    local closest, dist = nil, math.huge
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p == player then continue end
        local char = p.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local d = (hrp.Position - myPos.Position).Magnitude
        if d < dist then dist = d; closest = p end
    end
    return closest
end

function Targetaim.Lock()
    Targetaim.currentTarget = Targetaim.GetClosest()
    return Targetaim.currentTarget
end

function Targetaim.Release()
    Targetaim.currentTarget = nil
end

return Targetaim