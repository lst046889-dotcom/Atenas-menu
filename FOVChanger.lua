-- FOVChanger.lua
local FOVChanger = { active = false, originalFOV = nil }

local camera = workspace.CurrentCamera

function FOVChanger.Start(fov)
    if FOVChanger.active then return end
    FOVChanger.active = true
    FOVChanger.originalFOV = camera.FieldOfView
    camera.FieldOfView = fov or 90
end

function FOVChanger.Stop()
    if not FOVChanger.active then return end
    FOVChanger.active = false
    if FOVChanger.originalFOV then
        camera.FieldOfView = FOVChanger.originalFOV
    end
end

function FOVChanger.SetFOV(v) 
    if FOVChanger.active then camera.FieldOfView = v end 
end

return FOVChanger