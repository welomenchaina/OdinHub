local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
local IntroFrame = Instance.new("Frame")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local GlowFrame = Instance.new("Frame")
local GlowCorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopBarCorner = Instance.new("UICorner")
local TitleLabel = Instance.new("TextLabel")
local SubtitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local CloseCorner = Instance.new("UICorner")
local ContentFrame = Instance.new("Frame")
local OdinLogo = Instance.new("TextLabel")
local LogoGradient = Instance.new("UIGradient")
local KeyInputFrame = Instance.new("Frame")
local KeyInputCorner = Instance.new("UICorner")
local KeyInputStroke = Instance.new("UIStroke")
local KeyInputBox = Instance.new("TextBox")
local KeyInputIcon = Instance.new("TextLabel")
local CheckKeyButton = Instance.new("TextButton")
local CheckKeyCorner = Instance.new("UICorner")
local CheckKeyGradient = Instance.new("UIGradient")
local CheckKeyStroke = Instance.new("UIStroke")
local GetKeyButton = Instance.new("TextButton")
local GetKeyCorner = Instance.new("UICorner")
local GetKeyGradient = Instance.new("UIGradient")
local StatusLabel = Instance.new("TextLabel")
local ParticlesFrame = Instance.new("Frame")
local BackgroundGradient = Instance.new("UIGradient")

ScreenGui.Name = "OdinHubKeySystem"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

IntroFrame.Name = "IntroFrame"
IntroFrame.Parent = ScreenGui
IntroFrame.BackgroundTransparency = 1
IntroFrame.BorderSizePixel = 0
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.ZIndex = 100

local letters = {"O", "D", "I", "N"}
local letterLabels = {}
local startX = 0.5 - (#letters * 0.03)

for i, letter in ipairs(letters) do
    local label = Instance.new("TextLabel")
    label.Name = "Letter"..i
    label.Parent = IntroFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(startX + ((i-1) * 0.06), 0, 0.5, 0)
    label.Size = UDim2.new(0, 80, 0, 80)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Font = Enum.Font.GothamBold
    label.Text = letter
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextSize = 72
    label.TextTransparency = 1
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(138, 43, 226)
    letterLabels[i] = label
end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

BackgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 15, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
BackgroundGradient.Rotation = 45
BackgroundGradient.Parent = MainFrame

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

GlowFrame.Name = "GlowFrame"
GlowFrame.Parent = MainFrame
GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
GlowFrame.BorderSizePixel = 0
GlowFrame.Position = UDim2.new(0, -2, 0, -2)
GlowFrame.Size = UDim2.new(1, 4, 1, 4)
GlowFrame.ZIndex = 0
GlowFrame.BackgroundTransparency = 0.3

GlowCorner.CornerRadius = UDim.new(0, 16)
GlowCorner.Parent = GlowFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 60)

TopBarCorner.CornerRadius = UDim.new(0, 16)
TopBarCorner.Parent = TopBar

local TopBarBottomCover = Instance.new("Frame")
TopBarBottomCover.Parent = TopBar
TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBarBottomCover.BorderSizePixel = 0
TopBarBottomCover.Position = UDim2.new(0, 0, 1, -16)
TopBarBottomCover.Size = UDim2.new(1, 0, 0, 16)

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 10)
TitleLabel.Size = UDim2.new(1, -40, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "ODIN HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Parent = TopBar
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Position = UDim2.new(0, 20, 0, 35)
SubtitleLabel.Size = UDim2.new(1, -40, 0, 18)
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "⚔️ Allfather's Key System ⚔️"
SubtitleLabel.TextColor3 = Color3.fromRGB(200, 180, 120)
SubtitleLabel.TextSize = 12
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
CloseButton.Position = UDim2.new(1, -40, 0, 15)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20

CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.Size = UDim2.new(1, 0, 1, -60)

OdinLogo.Name = "OdinLogo"
OdinLogo.Parent = ContentFrame
OdinLogo.BackgroundTransparency = 1
OdinLogo.Position = UDim2.new(0.5, 0, 0, 20)
OdinLogo.Size = UDim2.new(0, 200, 0, 50)
OdinLogo.AnchorPoint = Vector2.new(0.5, 0)
OdinLogo.Font = Enum.Font.GothamBold
OdinLogo.Text = "⚡ ODIN ⚡"
OdinLogo.TextSize = 38
OdinLogo.TextColor3 = Color3.fromRGB(255, 255, 255)

LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(184, 134, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
}
LogoGradient.Parent = OdinLogo

KeyInputFrame.Name = "KeyInputFrame"
KeyInputFrame.Parent = ContentFrame
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyInputFrame.Position = UDim2.new(0.5, 0, 0, 90)
KeyInputFrame.Size = UDim2.new(0, 340, 0, 45)
KeyInputFrame.AnchorPoint = Vector2.new(0.5, 0)

KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInputFrame

KeyInputStroke.Color = Color3.fromRGB(255, 215, 0)
KeyInputStroke.Thickness = 2
KeyInputStroke.Transparency = 0.5
KeyInputStroke.Parent = KeyInputFrame

KeyInputIcon.Name = "KeyInputIcon"
KeyInputIcon.Parent = KeyInputFrame
KeyInputIcon.BackgroundTransparency = 1
KeyInputIcon.Position = UDim2.new(0, 12, 0.5, 0)
KeyInputIcon.Size = UDim2.new(0, 25, 0, 25)
KeyInputIcon.AnchorPoint = Vector2.new(0, 0.5)
KeyInputIcon.Font = Enum.Font.GothamBold
KeyInputIcon.Text = "🔑"
KeyInputIcon.TextSize = 18
KeyInputIcon.TextColor3 = Color3.fromRGB(255, 215, 0)

KeyInputBox.Name = "KeyInputBox"
KeyInputBox.Parent = KeyInputFrame
KeyInputBox.BackgroundTransparency = 1
KeyInputBox.Position = UDim2.new(0, 45, 0, 0)
KeyInputBox.Size = UDim2.new(1, -55, 1, 0)
KeyInputBox.Font = Enum.Font.Gotham
KeyInputBox.PlaceholderText = "Enter your key here..."
KeyInputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
KeyInputBox.Text = ""
KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInputBox.TextSize = 14
KeyInputBox.TextXAlignment = Enum.TextXAlignment.Left
KeyInputBox.ClearTextOnFocus = false

CheckKeyButton.Name = "CheckKeyButton"
CheckKeyButton.Parent = ContentFrame
CheckKeyButton.BackgroundColor3 = Color3.fromRGB(184, 134, 11)
CheckKeyButton.Position = UDim2.new(0.5, 0, 0, 150)
CheckKeyButton.Size = UDim2.new(0, 340, 0, 45)
CheckKeyButton.AnchorPoint = Vector2.new(0.5, 0)
CheckKeyButton.Font = Enum.Font.GothamBold
CheckKeyButton.Text = "⚔️ VERIFY KEY ⚔️"
CheckKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyButton.TextSize = 16

CheckKeyCorner.CornerRadius = UDim.new(0, 10)
CheckKeyCorner.Parent = CheckKeyButton

CheckKeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 134, 11))
}
CheckKeyGradient.Rotation = 45
CheckKeyGradient.Parent = CheckKeyButton

CheckKeyStroke.Color = Color3.fromRGB(255, 255, 255)
CheckKeyStroke.Thickness = 0
CheckKeyStroke.Transparency = 0.8
CheckKeyStroke.Parent = CheckKeyButton

GetKeyButton.Name = "GetKeyButton"
GetKeyButton.Parent = ContentFrame
GetKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
GetKeyButton.Position = UDim2.new(0.5, 0, 0, 210)
GetKeyButton.Size = UDim2.new(0, 340, 0, 40)
GetKeyButton.AnchorPoint = Vector2.new(0.5, 0)
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.Text = "🛡️ Get Key 🛡️"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 215, 0)
GetKeyButton.TextSize = 14

GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyButton

GetKeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 90, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 120, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 90, 0))
}


local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(255, 215, 0)
GetKeyStroke.Thickness = 2
GetKeyStroke.Transparency = 0.3
GetKeyStroke.Parent = GetKeyButton

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = ContentFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.5, 0, 1, -25)
StatusLabel.Size = UDim2.new(1, -40, 0, 20)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
StatusLabel.TextSize = 11

ParticlesFrame.Name = "ParticlesFrame"
ParticlesFrame.Parent = MainFrame
ParticlesFrame.BackgroundTransparency = 1
ParticlesFrame.Size = UDim2.new(1, 0, 1, 0)
ParticlesFrame.ZIndex = -1

for i = 1, 20 do
    local Particle = Instance.new("Frame")
    Particle.Parent = ParticlesFrame
    Particle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    Particle.BorderSizePixel = 0
    Particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    Particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
    Particle.BackgroundTransparency = math.random(40, 80) / 100
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Particle
    
    local function animateParticle()
        local tweenInfo = TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local goal = {Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)}
        TweenService:Create(Particle, tweenInfo, goal):Play()
    end
    animateParticle()
end

spawn(function()
    local delay = 0.05
    for i, label in ipairs(letterLabels) do
        wait(delay)
        TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        delay = delay - 0.01
    end
    
    wait(0.5)
    
    for i, label in ipairs(letterLabels) do
        TweenService:Create(label, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    end
    
    wait(0.4)
    IntroFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 350)}):Play()
end)

local glowTween = TweenService:Create(GlowFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.7
})
glowTween:Play()

local logoTween = TweenService:Create(LogoGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
    Offset = Vector2.new(1, 0)
})
logoTween:Play()

local bgTween = TweenService:Create(BackgroundGradient, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
    Rotation = 225
})
bgTween:Play()

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play()
    wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

CheckKeyButton.MouseEnter:Connect(function()
    TweenService:Create(CheckKeyButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 350, 0, 48)}):Play()
    TweenService:Create(CheckKeyStroke, TweenInfo.new(0.2), {Thickness = 3}):Play()
end)

CheckKeyButton.MouseLeave:Connect(function()
    TweenService:Create(CheckKeyButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 340, 0, 45)}):Play()
    TweenService:Create(CheckKeyStroke, TweenInfo.new(0.2), {Thickness = 0}):Play()
end)

GetKeyButton.MouseEnter:Connect(function()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 235, 100)}):Play()
end)

GetKeyButton.MouseLeave:Connect(function()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 215, 0)}):Play()
end)

KeyInputBox.Focused:Connect(function()
    TweenService:Create(KeyInputStroke, TweenInfo.new(0.2), {Transparency = 0, Thickness = 2}):Play()
end)

KeyInputBox.FocusLost:Connect(function()
    TweenService:Create(KeyInputStroke, TweenInfo.new(0.2), {Transparency = 0.5, Thickness = 2}):Play()
end)

GetKeyButton.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Opening portal to Odin's Hub"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    TweenService:Create(GetKeyButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 215, 0)}):Play()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    wait(0.2)
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 215, 0)}):Play()
    
    if setclipboard then
        setclipboard("https://ads.luarmor.net/get_key?for=Odin_Hub-sHpmdyoLEflr")
        StatusLabel.Text = "Key link copied to clipboard!"
    end
    
    if request then
        request({
            Url = "https://ads.luarmor.net/get_key?for=Odin_Hub-sHpmdyoLEflr",
            Method = "GET"
        })
    end
end)

local function saveKey(key)
    if not isfolder("OdinHub") then
        makefolder("OdinHub")
    end
    if not isfolder("OdinHub/KeySystem") then
        makefolder("OdinHub/KeySystem")
    end
    writefile("OdinHub/KeySystem/Key.txt", key)
end

local function loadKey()
    if isfile("OdinHub/KeySystem/Key.txt") then
        return readfile("OdinHub/KeySystem/Key.txt")
    end
    return ""
end

KeyInputBox.Text = loadKey()

CheckKeyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyInputBox.Text
    
    if enteredKey == "" or enteredKey == " " then
        StatusLabel.Text = "No key was detected!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 59, 59)
        TweenService:Create(KeyInputFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true), {
            Position = UDim2.new(0.5, 5, 0, 90)
        }):Play()
        return
    end
    
    CheckKeyButton.Text = "VERIFYING..."
    StatusLabel.Text = "Checking...."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    TweenService:Create(CheckKeyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(184, 134, 11)}):Play()
    
    wait(1)
    
    saveKey(enteredKey)
    
    StatusLabel.Text = "Key entered, luarmor validation next!"
    StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    CheckKeyButton.Text = "⚔️ VALIDATED ⚔️"
    TweenService:Create(CheckKeyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
    
    wait(0.5)
    
    script_key = enteredKey;
    
    wait(0.5)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)
