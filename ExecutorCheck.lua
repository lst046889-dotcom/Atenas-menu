-- ExecutorCheck.lua
local executors = {"Delta", "Fluxos", "ScriptWare", "Hydrogen"}
local detected = false
for _, v in pairs(executors) do
    if identifyexecutor and identifyexecutor():find(v) then
        detected = true
        break
    end
end
if not detected then
    print("Executor não reconhecido, algumas funções podem falhar.")
end