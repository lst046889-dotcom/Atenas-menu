local Noclip = { active = false, conn = nil, original = {} }
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

function Noclip.Toggle(v)
    if v then
        Noclip.active = true
        Noclip.conn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if Noclip.original[part] == nil then Noclip.original[part] = part.CanCollide end
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        Noclip.active = false
        if Noclip.conn then Noclip.conn:Disconnect() Noclip.conn = nil end
        local char = player.Character
        if char then
            for part, val in pairs(Noclip.original) do
                if part and part.Parent then part.CanCollide = val end
            end
        end
        Noclip.original = {}
    end
end

function Noclip.Stop() Noclip.Toggle(false) end
return Noclip