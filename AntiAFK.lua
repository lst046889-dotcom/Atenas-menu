-- AntiAFK.lua
local AntiAFK = { active = false, connection = nil }

local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer

function AntiAFK.Start()
    if AntiAFK.active then return end
    AntiAFK.active = true
    AntiAFK.connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not AntiAFK.active then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

function AntiAFK.Stop()
    AntiAFK.active = false
    if AntiAFK.connection then AntiAFK.connection:Disconnect() AntiAFK.connection = nil end
end

return AntiAFK