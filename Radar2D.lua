-- Radar2D.lua (simples, desenha na tela)
local Radar2D = { active = false, radius = 150, players = {} }

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local function createRadar()
    -- Implementação simplificada: desenhar um círculo e pontos no CoreGui
    if typeof(Drawing) ~= "table" then return end
    local radarCircle = Drawing.new("Circle")
    radarCircle.Radius = Radar2D.radius
    radarCircle.Thickness = 2
    radarCircle.Color = Color3.new(1,1,1)
    radarCircle.Filled = false
    radarCircle.Visible = true
    radarCircle.Position = Vector2.new(100, 100)

    local enemyDots = {}
    local function update()
        if not Radar2D.active then return end
        local myChar = player.Character
        if not myChar then return end
        local myPos = myChar:FindFirstChild("HumanoidRootPart")
        if not myPos then return end
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p == player then continue end
            local char = p.Character
            if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local rel = hrp.Position - myPos.Position
            local angle = math.atan2(rel.Z, rel.X) - camera.CFrame:ToOrientation()
            local dist = math.min(rel.Magnitude, Radar2D.radius)
            local x = 100 + math.cos(angle) * dist
            local y = 100 + math.sin(angle) * dist
            if not enemyDots[p] then
                local dot = Drawing.new("Square")
                dot.Size = Vector2.new(4,4)
                dot.Filled = true
                dot.Color = Color3.fromRGB(255,0,0)
                dot.Visible = true
                enemyDots[p] = dot
            end
            enemyDots[p].Position = Vector2.new(x-2, y-2)
        end
        -- remover dots de jogadores que saíram
        for p, dot in pairs(enemyDots) do
            if not p.Parent or not p.Character then
                dot:Remove()
                enemyDots[p] = nil
            end
        end
    end
    runService.RenderStepped:Connect(update)
end

function Radar2D.Start()
    if Radar2D.active then return end
    Radar2D.active = true
    createRadar()
end

function Radar2D.Stop()
    Radar2D.active = false
    -- limpeza não implementada por simplicidade
end

return Radar2D