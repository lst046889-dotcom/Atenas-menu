-- ============================================
-- ATENAS MENU - MAIN COMPLETO
-- ============================================

local function downloadFile(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then return result else return nil end
end

-- ========== 1. CARREGA BIBLIOTECA E ADDONS ==========
local Library = loadstring(downloadFile("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(downloadFile("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(downloadFile("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

if not Library then
    warn("Falha ao carregar Library")
    return
end

-- ========== 2. CARREGA MÓDULOS ==========
local Hitbox      = dofile("Atenas menu/Modules/Hitbox.lua")
local SilentAim   = dofile("Atenas menu/Modules/SilentAim.lua")
local ESP         = dofile("Atenas menu/Modules/ESP.lua")
local Speed       = dofile("Atenas menu/Modules/Speed.lua")
local Noclip      = dofile("Atenas menu/Modules/Noclip.lua")
local Fly         = dofile("Atenas menu/Modules/Fly.lua")
local MultiJump   = dofile("Atenas menu/Modules/MultiJump.lua")
local AntiAFK     = dofile("Atenas menu/Modules/AntiAFK.lua")
local Crosshair   = dofile("Atenas menu/Modules/Crosshair.lua")
local FOVChanger  = dofile("Atenas menu/Modules/FOVChanger.lua")
local FPSBoost    = dofile("Atenas menu/Modules/FPSBoost.lua")
local Radar2D     = dofile("Atenas menu/Modules/Radar2D.lua")
local Targetaim   = dofile("Atenas menu/Modules/Targetaim.lua")
local TriggerBot  = dofile("Atenas menu/Modules/TriggerBot.lua")
local Bypass      = dofile("Atenas menu/Security/Bypass.lua")

-- ========== 3. VARIÁVEIS GLOBAIS ==========
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ========== 4. CRIA JANELA PRINCIPAL ==========
local Window = Library:CreateWindow({
    Title = "Atenas Menu",
    Footer = "by Atenas Team",
    Icon = 85679881136879,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- Abas
local Tabs = {
    PvP         = Window:AddTab("PvP", "sword"),
    Esp         = Window:AddTab("ESP", "eye"),
    Movement    = Window:AddTab("Movimento", "zap"),
    Visuals     = Window:AddTab("Visuais", "palette"),
    Extras      = Window:AddTab("Extras", "star"),
    Config      = Window:AddTab("Configurações", "settings"),
    Security    = Window:AddTab("Segurança", "shield"),
}

-- ============================================
-- ABA PVP (Combate + Aimbot)
-- ============================================
local pvpLeft  = Tabs.PvP:AddLeftGroupbox("Combate", "sword")
local pvpRight = Tabs.PvP:AddRightGroupbox("Aimbot", "crosshair")

-- Hitbox Expander
local hitboxToggle = pvpLeft:AddToggle("HitboxExpander", {
    Text = "Expansor de Hitbox (Esfera 15x15)",
    Default = false,
    Callback = function(v)
        if v then Hitbox.Start() else Hitbox.Stop() end
    end
})
pvpLeft:AddDropdown("HitboxAlvo", {
    Values = {"Corpo","Cabeça"}, Default = "Corpo",
    Callback = function() if hitboxToggle.Value then Hitbox.Stop(); Hitbox.Start() end end
})
pvpLeft:AddDropdown("HitboxFormato", {
    Values = {"Cilindro","Esfera","Quadrado"}, Default = "Cilindro",
    Callback = function() if hitboxToggle.Value then Hitbox.Stop(); Hitbox.Start() end end
})
pvpLeft:AddSlider("HitboxSize", {
    Text = "Tamanho", Default = 15, Min = 1, Max = 25,
    Callback = function() if hitboxToggle.Value then Hitbox.Stop(); Hitbox.Start() end end
})
pvpLeft:AddLabel("Cor da Hitbox"):AddColorPicker("HitboxColor", {
    Default = Color3.fromRGB(255,0,0),
    Callback = function(c) Hitbox.SetColor(c) end
})
pvpLeft:AddDivider()
pvpLeft:AddButton({ Text = "Resetar Hitbox", Func = function()
    hitboxToggle:SetValue(false)
    Options.HitboxAlvo:SetValue("Corpo")
    Options.HitboxFormato:SetValue("Cilindro")
    Options.HitboxSize:SetValue(15)
    Options.HitboxColor:SetValueRGB(Color3.fromRGB(255,0,0))
    Library:Notify({ Title = "PvP", Description = "Hitbox resetada!", Time = 2 })
end })

-- Silent Aim
pvpRight:AddToggle("SilentAim", {
    Text = "Aimbot", Default = false,
    Callback = function(v) if v then SilentAim.Start() else SilentAim.Stop() end end
})
pvpRight:AddToggle("ShowFOVCircle", { Text = "Mostrar Círculo FOV", Default = true })
pvpRight:AddDropdown("SilentAimParte", { Values = {"Cabeça","Corpo"}, Default = "Cabeça" })
pvpRight:AddSlider("SilentAimFOV", { Text = "FOV", Default = 40, Min = 10, Max = 100 })
pvpRight:AddSlider("SilentAimSmoothness", { Text = "Suavidade", Default = 0.4, Min = 0.1, Max = 0.8 })
pvpRight:AddDivider()
pvpRight:AddButton({ Text = "Resetar Aimbot", Func = function()
    Toggles.SilentAim:SetValue(false)
    Toggles.ShowFOVCircle:SetValue(true)
    Options.SilentAimParte:SetValue("Cabeça")
    Options.SilentAimFOV:SetValue(40)
    Options.SilentAimSmoothness:SetValue(0.4)
    Library:Notify({ Title = "Aimbot", Description = "Resetado!", Time = 2 })
end })

-- TriggerBot
pvpRight:AddDivider()
pvpRight:AddToggle("TriggerBot", {
    Text = "TriggerBot (auto disparo)", Default = false,
    Callback = function(v) if v then TriggerBot.Start() else TriggerBot.Stop() end end
})

-- ============================================
-- ABA ESP
-- ============================================
local espLeft  = Tabs.Esp:AddLeftGroupbox("Visual", "eye")
local espRight = Tabs.Esp:AddRightGroupbox("Cores e Estilo", "palette")

espLeft:AddToggle("EspEnabled", {
    Text = "Ativar ESP",
    Default = false,
    Callback = function(v) if v then ESP.Start() else ESP.Stop() end end
})
espLeft:AddToggle("EspVida",      { Text = "Barra de Vida", Default = false })
espLeft:AddToggle("EspNick",      { Text = "Nome", Default = false })
espLeft:AddToggle("EspDistancia", { Text = "Distância", Default = false })
espLeft:AddToggle("EspChams",     { Text = "Chams", Default = false, Tooltip = "Até 250m" })
espLeft:AddToggle("EspEsqueleto", { Text = "Esqueleto", Default = false, Tooltip = "Até 200m" })
espLeft:AddToggle("EspLinhas",    { Text = "Linhas", Default = false, Tooltip = "Até 300m" })
espLeft:AddToggle("EspBox",       { Text = "Caixa com Cantos", Default = false })
espLeft:AddSlider("EspMaxDistance", {
    Text = "Distância Máxima", Default = 500, Min = 50, Max = 2000
})

espRight:AddLabel("Cor Principal"):AddColorPicker("EspBoxColor", { Default = Color3.new(1,1,1) })
espRight:AddLabel("Cor do Esqueleto"):AddColorPicker("EspSkeletonColor", { Default = Color3.fromRGB(200,200,255) })
espRight:AddLabel("Cor das Linhas"):AddColorPicker("EspLineColor", { Default = Color3.new(1,1,1) })
espRight:AddLabel("Cor do Chams"):AddColorPicker("EspChamsColor", {
    Default = Color3.fromRGB(255,0,0),
    Transparency = 0.5
})
espRight:AddDivider()
espRight:AddButton({ Text = "Resetar ESP", Func = function()
    Toggles.EspEnabled:SetValue(false)
    Toggles.EspVida:SetValue(false)
    Toggles.EspNick:SetValue(false)
    Toggles.EspDistancia:SetValue(false)
    Toggles.EspChams:SetValue(false)
    Toggles.EspEsqueleto:SetValue(false)
    Toggles.EspLinhas:SetValue(false)
    Toggles.EspBox:SetValue(false)
    Options.EspMaxDistance:SetValue(500)
    Options.EspBoxColor:SetValueRGB(Color3.fromRGB(255,255,255))
    Options.EspSkeletonColor:SetValueRGB(Color3.fromRGB(200,200,255))
    Options.EspLineColor:SetValueRGB(Color3.fromRGB(255,255,255))
    Options.EspChamsColor:SetValueRGB(Color3.fromRGB(255,0,0))
    Library:Notify({ Title = "ESP", Description = "Resetado!", Time = 2 })
end })

-- ============================================
-- ABA MOVIMENTO
-- ============================================
local movLeft = Tabs.Movement:AddLeftGroupbox("Movimento", "zap")
local movRight = Tabs.Movement:AddRightGroupbox("Voo e Pulos", "flying")

-- Velocidade e Noclip
movLeft:AddToggle("SuperVelocidade", {
    Text = "Super Velocidade", Default = false,
    Callback = function(v) Speed.Toggle(v) end
})
movLeft:AddSlider("VelocidadeSlider", {
    Text = "Velocidade", Default = 50, Min = 16, Max = 200,
    Callback = function(v) Speed.SetValue(v) end
})
movLeft:AddDivider()
movLeft:AddToggle("Noclip", {
    Text = "Noclip", Default = false,
    Callback = function(v) Noclip.Toggle(v) end
})
movLeft:AddDivider()
movLeft:AddButton({ Text = "Resetar Habilidades", Func = function()
    Toggles.SuperVelocidade:SetValue(false)
    Toggles.Noclip:SetValue(false)
    Options.VelocidadeSlider:SetValue(50)
    Library:Notify({ Title = "Movimento", Description = "Resetado!", Time = 2 })
end })

-- Fly e MultiJump
movRight:AddToggle("Fly", {
    Text = "Fly (WASD + Q/E)", Default = false,
    Callback = function(v)
        if v then Fly.Start(Options.FlySpeed.Value) else Fly.Stop() end
    end
})
movRight:AddSlider("FlySpeed", {
    Text = "Velocidade de Voo", Default = 50, Min = 10, Max = 200,
    Callback = function(v) Fly.SetSpeed(v) end
})
movRight:AddDivider()
movRight:AddToggle("MultiJump", {
    Text = "MultiJump", Default = false,
    Callback = function(v)
        if v then MultiJump.Start(Options.ExtraJumps.Value) else MultiJump.Stop() end
    end
})
movRight:AddSlider("ExtraJumps", {
    Text = "Pulos Extras", Default = 1, Min = 1, Max = 10,
    Callback = function(v) if Toggles.MultiJump.Value then MultiJump.SetExtraJumps(v) end end
})

-- ============================================
-- ABA VISUAIS
-- ============================================
local visLeft  = Tabs.Visuals:AddLeftGroupbox("Camera e Mira", "eye")
local visRight = Tabs.Visuals:AddRightGroupbox("Performance", "cpu")

-- Crosshair, FOV, Radar
visLeft:AddToggle("Crosshair", {
    Text = "Crosshair Personalizado", Default = false,
    Callback = function(v) if v then Crosshair.Start() else Crosshair.Stop() end end
})
visLeft:AddToggle("FOVChanger", {
    Text = "Alterar FOV", Default = false,
    Callback = function(v)
        if v then FOVChanger.Start(Options.FOVValue.Value) else FOVChanger.Stop() end
    end
})
visLeft:AddSlider("FOVValue", {
    Text = "Campo de Visão (FOV)", Default = 90, Min = 50, Max = 120,
    Callback = function(v) if Toggles.FOVChanger.Value then FOVChanger.SetFOV(v) end end
})
visLeft:AddToggle("Radar2D", {
    Text = "Radar 2D (experimental)", Default = false,
    Callback = function(v) if v then Radar2D.Start() else Radar2D.Stop() end end
})

-- FPS Boost e AntiAFK
visRight:AddToggle("FPSBoost", {
    Text = "Boost de FPS (remove decals)", Default = false,
    Callback = function(v) if v then FPSBoost.Start() else FPSBoost.Stop() end end
})
visRight:AddDivider()
visRight:AddToggle("AntiAFK", {
    Text = "Anti AFK", Default = false,
    Callback = function(v) if v then AntiAFK.Start() else AntiAFK.Stop() end end
})

-- ============================================
-- ABA EXTRAS
-- ============================================
local extLeft = Tabs.Extras:AddLeftGroupbox("Utilidades", "tool")

extLeft:AddButton({ Text = "Lock no alvo mais próximo", Func = function()
    local target = Targetaim.GetClosest()
    if target then
        Library:Notify({ Title = "Target", Description = "Alvo: " .. target.Name, Time = 2 })
        Targetaim.Lock()
    else
        Library:Notify({ Title = "Target", Description = "Nenhum alvo encontrado", Time = 1 })
    end
end })
extLeft:AddButton({ Text = "Soltar alvo", Func = function()
    Targetaim.Release()
    Library:Notify({ Title = "Target", Description = "Alvo liberado", Time = 1 })
end })

-- ============================================
-- ABA CONFIGURAÇÕES (UI)
-- ============================================
local cfgLeft = Tabs.Config:AddLeftGroupbox("Menu", "wrench")

cfgLeft:AddToggle("KeybindMenuOpen", {
    Text = "Abrir Menu de Atalhos",
    Default = Library.KeybindFrame.Visible,
    Callback = function(v) Library.KeybindFrame.Visible = v end
})
cfgLeft:AddToggle("ShowCustomCursor", {
    Text = "Cursor Personalizado",
    Default = true,
    Callback = function(v) Library.ShowCustomCursor = v end
})
cfgLeft:AddDropdown("NotificationSide", {
    Values = {"Left","Right"}, Default = "Right",
    Callback = function(v) Library:SetNotifySide(v) end
})
cfgLeft:AddDropdown("DPIDropdown", {
    Values = {"50%","75%","100%","125%","150%","175%","200%"},
    Default = "100%",
    Callback = function(v)
        v = v:gsub("%%","")
        Library:SetDPIScale(tonumber(v))
    end
})
cfgLeft:AddSlider("UICornerSlider", {
    Text = "Raio dos Cantos",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Callback = function(v) Window:SetCornerRadius(v) end
})
cfgLeft:AddDivider()
cfgLeft:AddLabel("Tecla do Menu"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true
})
cfgLeft:AddButton("Descarregar Script", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

-- ============================================
-- ABA SEGURANÇA (BYPASS)
-- ============================================
local secLeft = Tabs.Security:AddLeftGroupbox("Proteção", "shield")

secLeft:AddToggle("Bypass", {
    Text = "Ativar bypass anti-detecção (experimental)",
    Default = false,
    Tooltip = "Pode causar conflitos com outros módulos. Use com cuidado.",
    Callback = function(v)
        if v then
            if Bypass then
                local success, err = pcall(Bypass.Enable, Bypass)
                if success then
                    Library:Notify({ Title = "Bypass", Description = "Ativado com sucesso!", Time = 2 })
                else
                    Library:Notify({ Title = "Bypass", Description = "Falha ao ativar: " .. tostring(err), Time = 3 })
                end
            else
                Library:Notify({ Title = "Bypass", Description = "Módulo não encontrado!", Time = 2 })
            end
        else
            Library:Notify({ Title = "Bypass", Description = "Desative e recarregue o script para remover o bypass.", Time = 3 })
        end
    end
})

secLeft:AddButton({
    Text = "Recarregar script",
    Func = function()
        Library:Unload()
        task.wait(0.5)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/AtenasMenu/main/main.lua"))()
    end
})

-- ============================================
-- ADDONS (ThemeManager, SaveManager)
-- ============================================
if ThemeManager then
    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder("AtenasMenu")
    ThemeManager:ApplyToTab(Tabs.Config)
end

if SaveManager then
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    SaveManager:SetFolder("AtenasMenu/specific-game")
    SaveManager:BuildConfigSection(Tabs.Config)
    SaveManager:LoadAutoloadConfig()
end

-- ============================================
-- CLEANUP FINAL (descarregar tudo)
-- ============================================
Library.OnUnload = function()
    Hitbox.Stop()
    SilentAim.Stop()
    ESP.Stop()
    Speed.Stop()
    Noclip.Stop()
    Fly.Stop()
    MultiJump.Stop()
    AntiAFK.Stop()
    Crosshair.Stop()
    FOVChanger.Stop()
    FPSBoost.Stop()
    Radar2D.Stop()
    TriggerBot.Stop()
    Targetaim.Release()
    -- Nota: o bypass não é desativado automaticamente (requer recarregar)
end

-- ============================================
-- NOTIFICAÇÃO FINAL
-- ============================================
Library:Notify({ Title = "Atenas Menu", Description = "Script carregado com sucesso!", Time = 3 })
print("Atenas Menu carregado.")