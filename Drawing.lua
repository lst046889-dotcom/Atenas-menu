-- Drawimg.lua - funções auxiliares para desenho
local Drawimg = {}

function Drawimg.Circle(center, radius, color, thickness)
    if typeof(Drawing) ~= "table" then return nil end
    local circ = Drawing.new("Circle")
    circ.Position = center
    circ.Radius = radius
    circ.Color = color
    circ.Thickness = thickness or 1
    circ.Filled = false
    return circ
end

function Drawimg.Text(text, pos, size, color, center)
    if typeof(Drawing) ~= "table" then return nil end
    local txt = Drawing.new("Text")
    txt.Text = text
    txt.Position = pos
    txt.Size = size or 14
    txt.Color = color or Color3.new(1,1,1)
    txt.Center = center or false
    txt.Outline = true
    return txt
end

return Drawimg