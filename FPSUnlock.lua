-- FPSUnlock.lua
if setfpscap then
    setfpscap(999)
elseif setfpslimit then
    setfpslimit(999)
else
    -- tentativa alternativa
    local success, res = pcall(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            wait(1/144)
        end)
    end)
end