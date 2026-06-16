-- MemoryCleaner.lua
local MemoryCleaner = { active = false, connection = nil }

local function clean()
    if not MemoryCleaner.active then return end
    collectgarbage("collect")
    if game:GetService("CoreGui"):FindFirstChild("AtenasMenu") then
        -- força coleta de lixo
    end
end

function MemoryCleaner.Start()
    if MemoryCleaner.active then return end
    MemoryCleaner.active = true
    MemoryCleaner.connection = game:GetService("RunService").Stepped:Connect(clean)
end

function MemoryCleaner.Stop()
    MemoryCleaner.active = false
    if MemoryCleaner.connection then MemoryCleaner.connection:Disconnect() end
end

return MemoryCleaner