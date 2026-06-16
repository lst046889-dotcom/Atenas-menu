-- ObfuscationCheck.lua
-- Verifica se o código está ofuscado (simples)
local function isObfuscated()
    local str = debug.getinfo(1, "S").source
    return #str > 500 and str:match("[%w_]+") == nil
end
if not isObfuscated() then
    warn("Código não está ofuscado!")
end