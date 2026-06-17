-- ============================================
-- LOADER DO ATENAS MENU (VIA GITHUB)
-- ============================================

local function carregarScript(url)
    local success, resultado = pcall(function()
        return game:HttpGet(url)
    end)
    if success and resultado then
        return resultado
    else
        warn("❌ Falha ao baixar:", url, success and "Erro desconhecido" or resultado)
        return nil
    end
end

-- Baixa e executa a tela de login
local loginScript = carregarScript("https://raw.githubusercontent.com/lst046889-dotcom/Atenas-menu/main/KeySystem/LoginUI.lua")
if loginScript then
    local loginFunction = loadstring(loginScript)
    if loginFunction then
        -- Executa a tela de login e passa o callback para carregar o main
        loginFunction(function()
            local mainScript = carregarScript("https://raw.githubusercontent.com/lst046889-dotcom/Atenas-menu/main/main.lua")
            if mainScript then
                loadstring(mainScript)()
            else
                warn("❌ Não foi possível carregar o menu principal.")
            end
        end)
    else
        warn("❌ Erro ao compilar LoginUI.lua")
    end
else
    warn("❌ Não foi possível baixar LoginUI.lua")
end