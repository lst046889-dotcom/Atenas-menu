local Speed = { active = false, original = nil }
local player = game:GetService("Players").LocalPlayer

function Speed.Toggle(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if v then
        Speed.original = hum.WalkSpeed
        hum.WalkSpeed = Options.VelocidadeSlider.Value
        Speed.active = true
    else
        if Speed.original then hum.WalkSpeed = Speed.original end
        Speed.active = false
    end
end

function Speed.SetValue(val)
    if Speed.active then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end

function Speed.Stop() Speed.Toggle(false) end
return Speed