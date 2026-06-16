local VALID_KEYS = dofile("Atenas menu/KeySystem/Keydata.lua")

return function(userKey)
    local data = VALID_KEYS[userKey]
    if not data or not data.valid then return false end
    if data.expiry and os.time() > data.expiry then return false end
    return true
end