-- ============================================
-- ATENAS MENU - LOGIN + MATRIX EFFECT
-- COMPLETO E CORRIGIDO
-- ============================================

local validateKey = function(userKey)

    local VALID_KEYS = {
        ["ADMIN123"] = {
            valid = true,
            expiry = nil
        },

        ["USER456"] = {
            valid = true,
            expiry = os.time() + (30 * 86400)
        },

        ["TRIAL789"] = {
            valid = true,
            expiry = os.time() + (7 * 86400)
        },
    }

    local keyData = VALID_KEYS[userKey]

    if not keyData or not keyData.valid then
        return false
    end

    if keyData.expiry and os.time() > keyData.expiry then
        return false
    end

    return true
end

-- ============================================
-- SERVICES
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AtenasLoginGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- ============================================
-- BACKGROUND
-- ============================================

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(8,8,15)
Background.BorderSizePixel = 0
Background.ZIndex = 0
Background.Parent = ScreenGui

local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(10,8,12)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(20,6,12)
    )
})

BgGradient.Rotation = 135
BgGradient.Parent = Background

-- ============================================
-- MATRIX EFFECT
-- ============================================

local MatrixContainer = Instance.new("Frame")
MatrixContainer.Size = UDim2.new(1,0,1,0)
MatrixContainer.BackgroundTransparency = 1
MatrixContainer.ZIndex = 1
MatrixContainer.Parent = ScreenGui

local chars = {
    "ア","イ","ウ","エ","オ",
    "カ","キ","ク","ケ","コ",
    "サ","シ","ス","セ","ソ",
    "タ","チ","ツ","テ","ト"
}

local columns = {}
local numberOfColumns = 14
local fontSize = 16

local function getViewportSize()

    local camera = workspace.CurrentCamera

    return
        camera.ViewportSize.X,
        camera.ViewportSize.Y
end

local function createMatrix()

    for _, col in pairs(columns) do
        for _, item in pairs(col) do
            if item.label then
                item.label:Destroy()
            end
        end
    end

    columns = {}

    local viewportX, viewportY =
        getViewportSize()

    local colWidth =
        viewportX / numberOfColumns

    for colIndex = 1, numberOfColumns do

        local columnChars = {}

        local numChars =
            math.random(10,18)

        local startX =
            (colIndex - 1) * colWidth +
            (colWidth / 2) -
            fontSize / 2

        for row = 1, numChars do

            local lbl =
                Instance.new("TextLabel")

            lbl.Size =
                UDim2.new(0,fontSize,0,fontSize)

            lbl.Position = UDim2.new(
                0,
                startX,
                0,
                -fontSize * row + math.random(-30,0)
            )

            lbl.BackgroundTransparency = 1

            lbl.Text =
                chars[math.random(1,#chars)]

            lbl.TextColor3 = Color3.fromRGB(
                math.random(150,255),
                math.random(0,40),
                math.random(0,30)
            )

            lbl.TextSize = fontSize
            lbl.Font = Enum.Font.GothamBold

            lbl.TextTransparency =
                math.random(20,60) / 100

            lbl.ZIndex = 2

            lbl.Parent = MatrixContainer

            table.insert(columnChars, {
                label = lbl,
                speed = math.random(25,55),
                y = lbl.Position.Y.Offset,
                changeTimer = 0,
                changeDelay = math.random(2,7)
            })
        end

        table.insert(columns,columnChars)
    end
end

createMatrix()

local lastTime = tick()

RunService.Heartbeat:Connect(function()

    local now = tick()

    local dt =
        math.min(now - lastTime,0.05)

    lastTime = now

    local _, viewportY =
        getViewportSize()

    for _, col in pairs(columns) do

        for _, cd in pairs(col) do

            cd.y = cd.y + cd.speed * dt

            if cd.y > viewportY + 30 then

                cd.y = -30

                cd.label.Text =
                    chars[math.random(1,#chars)]

                cd.label.TextColor3 =
                    Color3.fromRGB(
                        math.random(180,255),
                        math.random(0,30),
                        math.random(0,20)
                    )
            end

            cd.label.Position = UDim2.new(
                0,
                cd.label.Position.X.Offset,
                0,
                cd.y
            )

            local progress =
                cd.y / viewportY

            local transp =
                0.2 +
                math.abs(progress - 0.5) * 1.2

            cd.label.TextTransparency =
                math.clamp(transp,0.1,0.8)

            cd.changeTimer =
                cd.changeTimer + dt

            if cd.changeTimer >= cd.changeDelay then

                cd.changeTimer = 0

                cd.label.Text =
                    chars[math.random(1,#chars)]
            end
        end
    end
end)

-- ============================================
-- PANEL
-- ============================================

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0,380,0,320)
Panel.Position = UDim2.new(0.5,-190,0.5,-160)

Panel.BackgroundColor3 =
    Color3.fromRGB(16,12,18)

Panel.BorderSizePixel = 0
Panel.ZIndex = 10
Panel.Parent = ScreenGui

Instance.new("UICorner",Panel).CornerRadius =
    UDim.new(0,16)

local PanelStroke =
    Instance.new("UIStroke",Panel)

PanelStroke.Color =
    Color3.fromRGB(200,40,40)

PanelStroke.Thickness = 1.5
PanelStroke.Transparency = 0.2

-- ============================================
-- TOP BAR
-- ============================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,3)

TopBar.BackgroundColor3 =
    Color3.fromRGB(200,40,40)

TopBar.BorderSizePixel = 0
TopBar.ZIndex = 11
TopBar.Parent = Panel

Instance.new("UICorner",TopBar).CornerRadius =
    UDim.new(0,16)

local TopBarGradient =
    Instance.new("UIGradient")

TopBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(150,30,30)
    ),

    ColorSequenceKeypoint.new(
        0.5,
        Color3.fromRGB(220,60,60)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(150,30,30)
    )
})

TopBarGradient.Parent = TopBar

-- ============================================
-- LOGO
-- ============================================

local LogoFrame =
    Instance.new("Frame")

LogoFrame.Size = UDim2.new(0,70,0,70)
LogoFrame.Position = UDim2.new(0.5,-35,0,20)

LogoFrame.BackgroundColor3 =
    Color3.fromRGB(25,15,20)

LogoFrame.BorderSizePixel = 0
LogoFrame.ZIndex = 11
LogoFrame.Parent = Panel

Instance.new("UICorner",LogoFrame).CornerRadius =
    UDim.new(0,18)

local LogoStroke =
    Instance.new("UIStroke")

LogoStroke.Color =
    Color3.fromRGB(200,50,50)

LogoStroke.Thickness = 1.5
LogoStroke.Parent = LogoFrame

local LogoImage =
    Instance.new("ImageLabel")

LogoImage.Size = UDim2.new(1,-10,1,-10)
LogoImage.Position = UDim2.new(0,5,0,5)

LogoImage.BackgroundTransparency = 1

LogoImage.Image =
    "rbxassetid://85679881136879"

LogoImage.ScaleType =
    Enum.ScaleType.Fit

LogoImage.ZIndex = 12
LogoImage.Parent = LogoFrame

-- ============================================
-- TITLE
-- ============================================

local Title =
    Instance.new("TextLabel")

Title.Size = UDim2.new(1,0,0,28)
Title.Position = UDim2.new(0,0,0,100)

Title.BackgroundTransparency = 1

Title.Text = "Atenas Menu"

Title.TextColor3 =
    Color3.fromRGB(255,255,255)

Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 12
Title.Parent = Panel

local Subtitle =
    Instance.new("TextLabel")

Subtitle.Size = UDim2.new(1,0,0,18)
Subtitle.Position = UDim2.new(0,0,0,130)

Subtitle.BackgroundTransparency = 1

Subtitle.Text =
    "Insira sua chave de acesso"

Subtitle.TextColor3 =
    Color3.fromRGB(200,120,120)

Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.Gotham
Subtitle.ZIndex = 12
Subtitle.Parent = Panel

-- ============================================
-- INPUT
-- ============================================

local InputBg =
    Instance.new("Frame")

InputBg.Size = UDim2.new(1,-40,0,46)
InputBg.Position = UDim2.new(0,20,0,180)

InputBg.BackgroundColor3 =
    Color3.fromRGB(22,16,24)

InputBg.BorderSizePixel = 0
InputBg.ZIndex = 11
InputBg.Parent = Panel

Instance.new("UICorner",InputBg).CornerRadius =
    UDim.new(0,10)

local InputStroke =
    Instance.new("UIStroke")

InputStroke.Color =
    Color3.fromRGB(150,40,40)

InputStroke.Thickness = 1.5
InputStroke.Parent = InputBg

local KeyInput =
    Instance.new("TextBox")

KeyInput.Size = UDim2.new(1,-20,1,0)
KeyInput.Position = UDim2.new(0,10,0,0)

KeyInput.BackgroundTransparency = 1

KeyInput.TextColor3 =
    Color3.fromRGB(255,200,200)

KeyInput.PlaceholderColor3 =
    Color3.fromRGB(120,80,80)

KeyInput.Text = ""
KeyInput.PlaceholderText =
    "Digite sua key..."

KeyInput.TextSize = 15
KeyInput.Font = Enum.Font.Gotham
KeyInput.ZIndex = 12
KeyInput.Parent = InputBg

-- ============================================
-- BUTTON
-- ============================================

local EnterBtn =
    Instance.new("TextButton")

EnterBtn.Size = UDim2.new(1,-40,0,44)
EnterBtn.Position = UDim2.new(0,20,0,240)

EnterBtn.BackgroundColor3 =
    Color3.fromRGB(180,40,40)

EnterBtn.TextColor3 =
    Color3.fromRGB(255,255,255)

EnterBtn.Text = "ENTRAR"
EnterBtn.TextSize = 15
EnterBtn.Font = Enum.Font.GothamBold

EnterBtn.BorderSizePixel = 0
EnterBtn.ZIndex = 11
EnterBtn.Parent = Panel

Instance.new("UICorner",EnterBtn).CornerRadius =
    UDim.new(0,10)

local BtnGradient =
    Instance.new("UIGradient")

BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(200,50,50)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(140,30,30)
    )
})

BtnGradient.Rotation = 90
BtnGradient.Parent = EnterBtn

-- ============================================
-- STATUS
-- ============================================

local StatusLabel =
    Instance.new("TextLabel")

StatusLabel.Size = UDim2.new(1,-40,0,20)
StatusLabel.Position = UDim2.new(0,20,0,292)

StatusLabel.BackgroundTransparency = 1

StatusLabel.Text = ""

StatusLabel.TextColor3 =
    Color3.fromRGB(255,80,80)

StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.ZIndex = 12
StatusLabel.Parent = Panel

-- ============================================
-- HOVER EFFECTS
-- ============================================

EnterBtn.MouseEnter:Connect(function()

    BtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(220,70,70)
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(160,50,50)
        )
    })
end)

EnterBtn.MouseLeave:Connect(function()

    BtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(200,50,50)
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(140,30,30)
        )
    })
end)

KeyInput.Focused:Connect(function()

    InputStroke.Color =
        Color3.fromRGB(220,60,60)

    InputStroke.Thickness = 2
end)

KeyInput.FocusLost:Connect(function()

    InputStroke.Color =
        Color3.fromRGB(150,40,40)

    InputStroke.Thickness = 1.5
end)

-- ============================================
-- ENTRY ANIMATION
-- ============================================

Panel.Size = UDim2.new(0,340,0,280)

TweenService:Create(
    Panel,
    TweenInfo.new(
        0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0,380,0,320)
    }
):Play()

-- ============================================
-- LOGIN
-- ============================================

local busy = false

local function tryLogin()

    if busy then
        return
    end

    local inputKey = KeyInput.Text

    if validateKey(inputKey) then

        busy = true

        StatusLabel.Text =
            "✓ Chave válida!"

        StatusLabel.TextColor3 =
            Color3.fromRGB(100,255,150)

        InputStroke.Color =
            Color3.fromRGB(80,200,100)

        EnterBtn.Text = "✓"

        BtnGradient.Color =
            ColorSequence.new({
                ColorSequenceKeypoint.new(
                    0,
                    Color3.fromRGB(50,180,80)
                ),

                ColorSequenceKeypoint.new(
                    1,
                    Color3.fromRGB(30,140,60)
                )
            })

        task.wait(1)

        ScreenGui:Destroy()

        -- loadstring(game:HttpGet("LINK"))()

    else

        StatusLabel.Text =
            "✗ Chave inválida ou expirada!"

        StatusLabel.TextColor3 =
            Color3.fromRGB(255,80,80)

        InputStroke.Color =
            Color3.fromRGB(255,50,50)

        task.wait(2)

        StatusLabel.Text = ""

        InputStroke.Color =
            Color3.fromRGB(150,40,40)
    end
end

EnterBtn.MouseButton1Click:Connect(tryLogin)

KeyInput.FocusLost:Connect(function(enterPressed)

    if enterPressed then
        tryLogin()
    end
end)