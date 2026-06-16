-- MultiJump.lua
local MultiJump = { active = false, connection = nil, extraJumps = 0, currentJumps = 0 }

local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

local function onJumpRequest()
    if not MultiJump.active then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.FloorMaterial == Enum.Material.Air then
        if MultiJump.currentJumps < MultiJump.extraJumps then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            MultiJump.currentJumps = MultiJump.currentJumps + 1
        end
    else
        MultiJump.currentJumps = 0
    end
end

function MultiJump.Start(extra)
    if MultiJump.active then return end
    MultiJump.active = true
    MultiJump.extraJumps = extra or 1
    MultiJump.currentJumps = 0
    MultiJump.connection = UserInputService.JumpRequest:Connect(onJumpRequest)
end

function MultiJump.Stop()
    MultiJump.active = false
    if MultiJump.connection then MultiJump.connection:Disconnect() MultiJump.connection = nil end
end

function MultiJump.SetExtraJumps(v) MultiJump.extraJumps = v end

return MultiJump