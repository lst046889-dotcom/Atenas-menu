-- AntiDump.lua
-- Impede que o script seja copiado de forma simples
if game:IsLoaded() then
    local original = getfenv and getfenv() or _G
    if original then
        original.script = nil
    end
end
print("AntiDump ativo")