-- AntiTamper.lua
-- Verifica se o script foi modificado em tempo de execução
local originalHash = "AtenasMenu2024"
local code = debug and debug.getinfo and debug.getinfo(1, "S").source
if code and not code:match(originalHash) then
    game:Shutdown()
end