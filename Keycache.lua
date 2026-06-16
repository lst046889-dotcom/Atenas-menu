return {
    Save = function(key) -- salvar em arquivo
        if writefile then writefile("Atenas menu/Config/key.txt", key) end
    end,
    Load = function()
        if readfile and isfile then
            local f = readfile("Atenas menu/Config/key.txt")
            return f or ""
        end
        return ""
    end
}