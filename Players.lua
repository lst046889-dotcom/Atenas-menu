-- Players.lua
local PlayersUtil = {}

function PlayersUtil.GetClosest(player, ignoreDead)
    local closest, dist = nil, math.huge
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p == player then continue end
        local char = p.Character
        if not char then continue end
        if ignoreDead then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then continue end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = (hrp.Position - myPos.Position).Magnitude
            if d < dist then dist = d; closest = p end
        end
    end
    return closest
end

function PlayersUtil.GetAllInRange(player, range)
    local inRange = {}
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return inRange end
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p == player then continue end
        local char = p.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - myPos.Position).Magnitude <= range then
            table.insert(inRange, p)
        end
    end
    return inRange
end

return PlayersUtil