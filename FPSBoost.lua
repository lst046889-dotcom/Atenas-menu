-- FPSBoost.lua
local FPSBoost = { active = false }

local function apply()
    -- Desativa efeitos pesados (opcional)
    settings().Rendering.QualityLevel = 1
    -- Limita alguns elementos (exemplo)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end

function FPSBoost.Start()
    if FPSBoost.active then return end
    FPSBoost.active = true
    apply()
end

function FPSBoost.Stop()
    FPSBoost.active = false
    -- Não restauramos para não complicar, mas pode ser implementado
end

return FPSBoost