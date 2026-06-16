-- Tabela de chaves válidas
return {
    ["ADMIN123"] = { valid = true, expiry = nil },
    ["USER456"]  = { valid = true, expiry = os.time() + (30 * 86400) },
    ["TRIAL789"] = { valid = true, expiry = os.time() + (7 * 86400) },
}