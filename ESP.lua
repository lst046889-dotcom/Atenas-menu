-- Modules/ESP.lua
-- Sistema de ESP para Atenas Menu

local ESP = {}
ESP.active = false
ESP.storage = {}          -- armazena dados de cada jogador
ESP.updateConnection = nil
ESP.playerAddedConn = nil
ESP.playerRemovingConn = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- Pares de ossos para desenho do esqueleto
local SKELETON_PAIRS = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"},  {"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"},  {"LeftLowerLeg","LeftFoot"},
}

-- Funções auxiliares
local function getTorso(char)
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

local function getHead(char)
    return char:FindFirstChild("Head")
end

-- Cria todos os elementos de desenho para um jogador
local function createESPforPlayer(targetPlayer)
    if targetPlayer == player then return end
    if ESP.storage[targetPlayer] then return end

    local useDrawing = (typeof(Drawing) == "table")

    -- Fallback para executores sem Drawing API
    if not useDrawing then
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 1
        hl.Enabled = false
        hl.Parent = game:GetService("CoreGui")
        ESP.storage[targetPlayer] = {
            highlight = hl,
            name = targetPlayer.DisplayName or targetPlayer.Name
        }
        return
    end

    -- Cria os 8 cantos da caixa
    local corners = {}
    for i = 1, 8 do
        corners[i] = Drawing.new("Line")
        corners[i].Visible = false
        corners[i].Thickness = 2
        corners[i].Color = Color3.new(1, 1, 1)
    end

    -- Cria as linhas do esqueleto
    local skeleton = {}
    for i = 1, #SKELETON_PAIRS do
        skeleton[i] = Drawing.new("Line")
        skeleton[i].Visible = false
        skeleton[i].Thickness = 1
        skeleton[i].Color = Color3.new(1, 1, 1)
    end

    -- Função auxiliar para criar textos
    local function newText(size, outline)
        local t = Drawing.new("Text")
        t.Visible = false
        t.Size = size
        t.Center = true
        t.Outline = outline
        t.Color = Color3.new(1, 1, 1)
        return t
    end

    -- Função auxiliar para criar quadrados (preenchidos ou não)
    local function newSquare(filled, color)
        local s = Drawing.new("Square")
        s.Visible = false
        s.Filled = filled
        s.Color = color or Color3.new(1, 1, 1)
        return s
    end

    -- Highlight para Chams
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 1
    hl.Enabled = false
    hl.Parent = game:GetService("CoreGui")

    -- Linha que liga o jogador ao centro da tela
    local lineToPlayer = Drawing.new("Line")
    lineToPlayer.Visible = false
    lineToPlayer.Thickness = 1
    lineToPlayer.Color = Color3.new(1, 1, 1)

    ESP.storage[targetPlayer] = {
        corners = corners,
        skeleton = skeleton,
        nameLabel = newText(13, true),
        distLabel = newText(12, true),
        healthBg = newSquare(true, Color3.fromRGB(30, 30, 30)),
        healthFill = newSquare(true, Color3.fromRGB(0, 255, 100)),
        healthBorder = newSquare(false, Color3.new(0, 0, 0)),
        healthText = newText(11, true),
        lineToPlayer = lineToPlayer,
        highlight = hl,
        name = targetPlayer.DisplayName or targetPlayer.Name
    }
end

-- Remove todos os elementos de um jogador
local function removeESPforPlayer(targetPlayer)
    local data = ESP.storage[targetPlayer]
    if not data then return end

    for _, v in pairs(data) do
        if typeof(v) == "table" and v.Remove then
            pcall(function() v:Remove() end)
        elseif typeof(v) == "Instance" then
            pcall(function() v:Destroy() end)
        end
    end
    ESP.storage[targetPlayer] = nil
end

-- Esconde os elementos de um jogador (sem destruir)
local function hideESPdata(data)
    if data.highlight then
        pcall(function() data.highlight.Enabled = false end)
    end
    for _, v in pairs(data) do
        if typeof(v) == "table" and v.Visible ~= nil then
            pcall(function() v.Visible = false end)
        end
    end
    if data.corners then
        for _, l in pairs(data.corners) do
            pcall(function() l.Visible = false end)
        end
    end
    if data.skeleton then
        for _, l in pairs(data.skeleton) do
            pcall(function() l.Visible = false end)
        end
    end
end

-- Atualiza o ESP para todos os jogadores (executado a cada frame)
local function updateESP()
    if not ESP.active then return end

    local myChar = player.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    -- Se o ESP global estiver desligado, esconde tudo e sai
    if not Toggles.EspEnabled or not Toggles.EspEnabled.Value then
        for _, data in pairs(ESP.storage) do
            hideESPdata(data)
        end
        return
    end

    local maxDist = Options.EspMaxDistance.Value

    -- Cria ESP para novos jogadores que ainda não possuem
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and not ESP.storage[p] then
            createESPforPlayer(p)
        end
    end

    -- Atualiza cada jogador
    for targetPlayer, data in pairs(ESP.storage) do
        local char = targetPlayer.Character
        if not char then
            hideESPdata(data)
            goto continue
        end

        local head = getHead(char)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not head or not hrp or not humanoid or humanoid.Health <= 0 then
            hideESPdata(data)
            goto continue
        end

        local distance = (hrp.Position - myHRP.Position).Magnitude
        if distance > maxDist then
            hideESPdata(data)
            goto continue
        end

        local distMeters = math.floor(distance / 3.28)
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        local espColor = Options.EspBoxColor.Value

        -- Chams (Highlight)
        if Toggles.EspChams and Toggles.EspChams.Value and distance <= 250 then
            data.highlight.FillColor = Options.EspChamsColor.Value
            data.highlight.Enabled = true
            if data.highlight.Parent ~= char then
                pcall(function() data.highlight.Parent = char end)
            end
        else
            pcall(function() data.highlight.Enabled = false end)
        end

        -- Se o executor não suporta Drawing, pula os desenhos avançados
        if typeof(Drawing) ~= "table" then
            goto continue
        end

        -- Projeções dos pontos 3D para a tela
        local headTop = head.Position + Vector3.new(0, head.Size.Y / 2 + 0.2, 0)
        local feetPos = hrp.Position - Vector3.new(0, 3, 0)
        local headSc, headVis = Camera:WorldToViewportPoint(headTop)
        local feetSc, feetVis = Camera:WorldToViewportPoint(feetPos)
        local rootSc, rootVis = Camera:WorldToViewportPoint(hrp.Position)

        local boxValid = headVis and feetVis
        local boxHeight = boxValid and math.abs(headSc.Y - feetSc.Y) or 0
        local boxWidth = boxHeight * 0.5
        local boxX = headSc.X - boxWidth / 2
        local boxY = headSc.Y

        -- Caixa com cantos
        if Toggles.EspBox and Toggles.EspBox.Value and boxValid and boxHeight > 5 then
            local cl = math.min(boxWidth, boxHeight) * 0.22
            data.corners[1].From = Vector2.new(boxX, boxY)
            data.corners[1].To   = Vector2.new(boxX + cl, boxY)
            data.corners[2].From = Vector2.new(boxX, boxY)
            data.corners[2].To   = Vector2.new(boxX, boxY + cl)
            data.corners[3].From = Vector2.new(boxX + boxWidth, boxY)
            data.corners[3].To   = Vector2.new(boxX + boxWidth - cl, boxY)
            data.corners[4].From = Vector2.new(boxX + boxWidth, boxY)
            data.corners[4].To   = Vector2.new(boxX + boxWidth, boxY + cl)
            data.corners[5].From = Vector2.new(boxX, boxY + boxHeight)
            data.corners[5].To   = Vector2.new(boxX + cl, boxY + boxHeight)
            data.corners[6].From = Vector2.new(boxX, boxY + boxHeight)
            data.corners[6].To   = Vector2.new(boxX, boxY + boxHeight - cl)
            data.corners[7].From = Vector2.new(boxX + boxWidth, boxY + boxHeight)
            data.corners[7].To   = Vector2.new(boxX + boxWidth - cl, boxY + boxHeight)
            data.corners[8].From = Vector2.new(boxX + boxWidth, boxY + boxHeight)
            data.corners[8].To   = Vector2.new(boxX + boxWidth, boxY + boxHeight - cl)
            for _, c in pairs(data.corners) do
                c.Color = espColor
                c.Visible = true
            end
        else
            for _, c in pairs(data.corners) do c.Visible = false end
        end

        -- Nome do jogador
        if Toggles.EspNick and Toggles.EspNick.Value and headVis then
            data.nameLabel.Position = Vector2.new(headSc.X, headSc.Y - 20)
            data.nameLabel.Text = data.name
            data.nameLabel.Color = espColor
            data.nameLabel.Visible = true
        else
            data.nameLabel.Visible = false
        end

        -- Distância
        if Toggles.EspDistancia and Toggles.EspDistancia.Value and feetVis then
            data.distLabel.Position = Vector2.new(feetSc.X, feetSc.Y + 5)
            data.distLabel.Text = distMeters .. "m"
            data.distLabel.Visible = true
        else
            data.distLabel.Visible = false
        end

        -- Barra de vida
        if Toggles.EspVida and Toggles.EspVida.Value and boxValid and boxHeight > 5 then
            local barW = 4
            local barX = boxX - barW - 3
            local fillH = math.max(1, boxHeight * healthPercent)
            local r = math.clamp(2 - 2 * healthPercent, 0, 1)
            local g = math.clamp(2 * healthPercent, 0, 1)
            local barColor = Color3.new(r, g, 0)
            data.healthBorder.Position = Vector2.new(barX - 1, boxY - 1)
            data.healthBorder.Size = Vector2.new(barW + 2, boxHeight + 2)
            data.healthBorder.Visible = true
            data.healthBg.Position = Vector2.new(barX, boxY)
            data.healthBg.Size = Vector2.new(barW, boxHeight)
            data.healthBg.Visible = true
            data.healthFill.Color = barColor
            data.healthFill.Position = Vector2.new(barX, boxY + boxHeight - fillH)
            data.healthFill.Size = Vector2.new(barW, fillH)
            data.healthFill.Visible = true
            data.healthText.Text = tostring(math.floor(humanoid.Health))
            data.healthText.Position = Vector2.new(barX + barW / 2, boxY - 10)
            data.healthText.Color = barColor
            data.healthText.Visible = true
        else
            data.healthBorder.Visible = false
            data.healthBg.Visible = false
            data.healthFill.Visible = false
            data.healthText.Visible = false
        end

        -- Esqueleto
        if Toggles.EspEsqueleto and Toggles.EspEsqueleto.Value and distance <= 200 then
            for i, pair in ipairs(SKELETON_PAIRS) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])
                if p1 and p2 then
                    local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                    if v1 and v2 then
                        data.skeleton[i].From = Vector2.new(s1.X, s1.Y)
                        data.skeleton[i].To = Vector2.new(s2.X, s2.Y)
                        data.skeleton[i].Color = Options.EspSkeletonColor.Value
                        data.skeleton[i].Visible = true
                    else
                        data.skeleton[i].Visible = false
                    end
                else
                    data.skeleton[i].Visible = false
                end
            end
        else
            for _, l in pairs(data.skeleton) do l.Visible = false end
        end

        -- Linhas até o centro da tela
        if Toggles.EspLinhas and Toggles.EspLinhas.Value and rootVis and distance <= 300 then
            data.lineToPlayer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            data.lineToPlayer.To = Vector2.new(rootSc.X, rootSc.Y)
            data.lineToPlayer.Color = Options.EspLineColor.Value
            data.lineToPlayer.Visible = true
        else
            data.lineToPlayer.Visible = false
        end

        ::continue::
    end
end

-- Inicia o ESP
function ESP.Start()
    if ESP.active then return end
    ESP.active = true

    -- Cria ESP para todos os jogadores já existentes
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            createESPforPlayer(p)
        end
    end

    -- Conecta eventos de entrada/saída
    ESP.playerAddedConn = Players.PlayerAdded:Connect(function(p)
        task.wait(0.5)
        createESPforPlayer(p)
    end)
    ESP.playerRemovingConn = Players.PlayerRemoving:Connect(removeESPforPlayer)

    -- Loop de atualização contínua
    ESP.updateConnection = RunService.RenderStepped:Connect(updateESP)
end

-- Para o ESP e limpa tudo
function ESP.Stop()
    if not ESP.active then return end
    ESP.active = false

    if ESP.updateConnection then
        ESP.updateConnection:Disconnect()
        ESP.updateConnection = nil
    end
    if ESP.playerAddedConn then
        ESP.playerAddedConn:Disconnect()
        ESP.playerAddedConn = nil
    end
    if ESP.playerRemovingConn then
        ESP.playerRemovingConn:Disconnect()
        ESP.playerRemovingConn = nil
    end

    -- Remove todos os ESPs da memória
    for p in pairs(ESP.storage) do
        removeESPforPlayer(p)
    end
    ESP.storage = {}
end

return ESP