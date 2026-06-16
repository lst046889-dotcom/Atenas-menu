-- Mobile.lua
local Mobile = {
    isMobile = game:GetService("UserInputService").TouchEnabled,
    platform = game:GetService("UserInputService").Platform
}

function Mobile.GetControls()
    if Mobile.isMobile then
        return { jump = "Tap", move = "Joystick" }
    else
        return { jump = "Space", move = "WASD" }
    end
end

return Mobile