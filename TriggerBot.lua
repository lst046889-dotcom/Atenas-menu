-- TriggerBot.lua
local TriggerBot = { active = false, connection = nil }

local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInput")

local function onRender()
    if not TriggerBot.active then return end
    local mouse = player:GetMouse()
    local target = mouse.Target
    if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
        -- atira automaticamente
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true)
        task.wait()
        VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false)
    end
end

function TriggerBot.Start()
    if TriggerBot.active then return end
    TriggerBot.active = true
    TriggerBot.connection = game:GetService("RunService").RenderStepped:Connect(onRender)
end

function TriggerBot.Stop()
    TriggerBot.active = false
    if TriggerBot.connection then TriggerBot.connection:Disconnect() TriggerBot.connection = nil end
end

return TriggerBot