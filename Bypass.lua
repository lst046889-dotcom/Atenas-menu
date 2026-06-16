-- ============================================
-- BYPASS ANTI-DETECÇÃO (VERSÃO ATENAS)
-- ============================================
-- Módulo opcional. Carregue com:
--   local bypass = dofile("Atenas menu/Security/Bypass.lua")
--   bypass:Enable()
-- ============================================

local Bypass = {}

local function getServices()
    return {
        Players = game:GetService("Players"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        RunService = game:GetService("RunService"),
        Workspace = game:GetService("Workspace"),
        CoreGui = game:GetService("CoreGui"),
        GuiService = game:GetService("GuiService"),
        TeleportService = game:GetService("TeleportService"),
        ScriptContext = game:GetService("ScriptContext"),
        LogService = game:GetService("LogService"),
    }
end

function Bypass:Enable()
    local services = getServices()
    local LocalPlayer = services.Players.LocalPlayer

    -- ========== 1. Desativa handlers de erro ==========
    for _, conn in next, getconnections(services.ScriptContext.Error) do
        if typeof(conn.Disable) == "function" then
            pcall(conn.Disable, conn)
        end
    end

    for _, conn in next, getconnections(services.LogService.MessageOut) do
        if typeof(conn.Disconnect) == "function" then
            pcall(conn.Disconnect, conn)
        end
    end

    -- ========== 2. Bloqueia instâncias críticas (genéricas) ==========
    local blockedInstances = {}
    local blockList = {
        "TesteAnti",
        "AntiExploit",
        "Detect",
        "ChatService",
        "RemoteDetect",
    }

    for _, name in ipairs(blockList) do
        local inst = services.Workspace:FindFirstChild(name) or
                     services.ReplicatedStorage:FindFirstChild(name) or
                     LocalPlayer:FindFirstChild(name)
        if inst then
            blockedInstances[name] = inst
        end
    end

    -- ========== 3. Hooks de metatabelas (compatível com Atenas) ==========
    local getrawmetatable = getrawmetatable or debug.getmetatable
    local make_writeable = make_writeable or setreadonly or changereadonly or change_writeable
    local gameMeta = getrawmetatable(game)
    if not gameMeta then return false end

    local originalIndex = gameMeta.__index
    local originalNamecall = gameMeta.__namecall

    -- Chaves que NÃO devem ser bloqueadas (para não quebrar o Atenas)
    local allowKeys = {
        FindFirstChild = true,
        GetChildren = true,
        WaitForChild = true,
        IsDescendantOf = true,
        Destroy = true,
        Remove = true,
        Parent = true,
        Name = true,
        ClassName = true,
    }

    -- Chaves que serão bloqueadas
    local blockKeys = {
        Fire = true,
        Invoke = true,
        FireServer = true,
        InvokeServer = true,
        GetPropertyChangedSignal = true,
        AncestryChanged = true,
        Kick = true,
    }

    make_writeable(gameMeta, false)

    -- Hook __index
    gameMeta.__index = newcclosure(function(self, key, ...)
        if not checkcaller() then
            -- Se a instância está bloqueada e a chave é bloqueada
            if blockedInstances[self.Name] and blockKeys[key] then
                if key == "Kick" and self == LocalPlayer then
                    return true
                end
                if key == "GetPropertyChangedSignal" or key == "AncestryChanged" then
                    return function() return { Disconnect = function() end } end
                end
                if key == "WaitForChild" or key:match("^FindFirstChild") then
                    return function(_, childName)
                        if childName == self.Name then
                            return blockedInstances[self.Name]
                        end
                        return nil
                    end
                end
                if key == "IsDescendantOf" then
                    return function() return true end
                end
                return nil
            end
            -- Permite chaves da whitelist
            if allowKeys[key] then
                return originalIndex(self, key, ...)
            end
        end
        return originalIndex(self, key, ...)
    end)

    -- Hook __namecall
    gameMeta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            if blockedInstances[self.Name] and blockKeys[method] then
                if method == "Kick" and self == LocalPlayer then
                    return true
                end
                if method == "GetPropertyChangedSignal" or method == "AncestryChanged" then
                    return function() return { Disconnect = function() end } end
                end
                if method == "WaitForChild" or method:match("^FindFirstChild") then
                    local args = { ... }
                    local childName = args[1]
                    if childName == self.Name then
                        return blockedInstances[self.Name]
                    end
                    return nil
                end
                if method == "IsDescendantOf" then
                    return true
                end
                return nil
            end
            if allowKeys[method] then
                return originalNamecall(self, ...)
            end
        end
        return originalNamecall(self, ...)
    end)

    make_writeable(gameMeta, true)

    -- ========== 4. Remove sinais de chat (se existir) ==========
    task.wait(1)
    local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    if playerScripts then
        local chat = playerScripts:FindFirstChild("ChatService")
        if chat then
            pcall(function() chat.Disabled = true end)
        end
    end

    -- ========== 5. Reconexão automática (opcional) ==========
    local function rejoin()
        local TeleportService = services.TeleportService
        pcall(function()
            if services.Players.NumPlayers > 1 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            else
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
        LocalPlayer:Kick("Reconectando...")
    end

    -- Detecta erros de desconexão
    local guiService = services.GuiService
    if guiService then
        guiService.ErrorMessageChanged:Connect(function()
            rejoin()
        end)
    end

    services.LogService.MessageOut:Connect(function(msg)
        if string.find(msg, "Server Kick Message:") then
            rejoin()
        end
    end)

    print("[Bypass] Ativado com sucesso (modo Atenas)")
    return true
end

return Bypass