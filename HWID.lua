-- HWID.lua
-- Obtém HWID do sistema (funciona em alguns executors)
local hwid = syn and syn.get_hwid and syn.get_hwid() or "Unknown"
print("HWID: " .. hwid)