-- RenderLimiter.lua
-- reduz fps para economizar bateria (exemplo)
local RenderLimiter = { active = false, connection = nil, limit = 30 }

local function throttle()
    if not RenderLimiter.active then return end
    task.wait(1 / RenderLimiter.limit)
end

function RenderLimiter.Start(limit)
    RenderLimiter.active = true
    RenderLimiter.limit = limit or 30
    RenderLimiter.connection = game:GetService("RunService").RenderStepped:Connect(throttle)
end

function RenderLimiter.Stop()
    RenderLimiter.active = false
    if RenderLimiter.connection then RenderLimiter.connection:Disconnect() end
end

return RenderLimiter