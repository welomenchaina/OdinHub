local WimplyUI = {}
WimplyUI.__index = WimplyUI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Plr = Players.LocalPlayer
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Themes = {
    Amethyst = {
        Primary = Color3.fromRGB(127, 2, 195), PrimaryDark = Color3.fromRGB(90, 0, 140),
        Background = Color3.fromRGB(14, 12, 20), Secondary = Color3.fromRGB(22, 19, 30),
        TitleBar = Color3.fromRGB(18, 15, 24), Text = Color3.fromRGB(210, 210, 215),
        SubText = Color3.fromRGB(100, 95, 110), Accent = Color3.fromRGB(160, 120, 230),
        Toggle = Color3.fromRGB(38, 34, 50), Input = Color3.fromRGB(28, 25, 38),
        Stroke = Color3.fromRGB(50, 35, 75), TabActive = Color3.fromRGB(127, 2, 195),
        TabInactive = Color3.fromRGB(24, 21, 32), TabHover = Color3.fromRGB(35, 30, 48),
        TabTextActive = Color3.fromRGB(255, 255, 255), TabTextInactive = Color3.fromRGB(100, 95, 115),
        RowHover = Color3.fromRGB(28, 25, 38), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(80, 40, 120), Chevron = Color3.fromRGB(90, 80, 110),
        NotifyBg = Color3.fromRGB(20, 17, 28), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    },
    Midnight = {
        Primary = Color3.fromRGB(0, 100, 220), PrimaryDark = Color3.fromRGB(0, 70, 160),
        Background = Color3.fromRGB(10, 10, 16), Secondary = Color3.fromRGB(18, 18, 28),
        TitleBar = Color3.fromRGB(14, 14, 22), Text = Color3.fromRGB(200, 205, 215),
        SubText = Color3.fromRGB(85, 90, 110), Accent = Color3.fromRGB(80, 140, 230),
        Toggle = Color3.fromRGB(30, 30, 48), Input = Color3.fromRGB(22, 22, 36),
        Stroke = Color3.fromRGB(30, 38, 60), TabActive = Color3.fromRGB(0, 100, 220),
        TabInactive = Color3.fromRGB(18, 18, 28), TabHover = Color3.fromRGB(26, 28, 42),
        TabTextActive = Color3.fromRGB(255, 255, 255), TabTextInactive = Color3.fromRGB(85, 90, 115),
        RowHover = Color3.fromRGB(24, 24, 38), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(40, 70, 130), Chevron = Color3.fromRGB(70, 80, 110),
        NotifyBg = Color3.fromRGB(14, 14, 24), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    },
    Rose = {
        Primary = Color3.fromRGB(190, 40, 85), PrimaryDark = Color3.fromRGB(140, 25, 60),
        Background = Color3.fromRGB(16, 11, 14), Secondary = Color3.fromRGB(26, 19, 22),
        TitleBar = Color3.fromRGB(20, 14, 18), Text = Color3.fromRGB(215, 205, 210),
        SubText = Color3.fromRGB(110, 90, 100), Accent = Color3.fromRGB(230, 120, 160),
        Toggle = Color3.fromRGB(42, 30, 36), Input = Color3.fromRGB(32, 24, 28),
        Stroke = Color3.fromRGB(60, 30, 45), TabActive = Color3.fromRGB(190, 40, 85),
        TabInactive = Color3.fromRGB(26, 19, 22), TabHover = Color3.fromRGB(38, 28, 32),
        TabTextActive = Color3.fromRGB(255, 255, 255), TabTextInactive = Color3.fromRGB(110, 90, 100),
        RowHover = Color3.fromRGB(32, 24, 28), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(120, 40, 70), Chevron = Color3.fromRGB(110, 80, 90),
        NotifyBg = Color3.fromRGB(22, 15, 18), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    },
    Emerald = {
        Primary = Color3.fromRGB(0, 170, 100), PrimaryDark = Color3.fromRGB(0, 120, 70),
        Background = Color3.fromRGB(10, 16, 13), Secondary = Color3.fromRGB(16, 26, 20),
        TitleBar = Color3.fromRGB(12, 20, 16), Text = Color3.fromRGB(200, 220, 210),
        SubText = Color3.fromRGB(80, 110, 95), Accent = Color3.fromRGB(80, 220, 150),
        Toggle = Color3.fromRGB(25, 42, 34), Input = Color3.fromRGB(18, 32, 26),
        Stroke = Color3.fromRGB(25, 50, 38), TabActive = Color3.fromRGB(0, 170, 100),
        TabInactive = Color3.fromRGB(16, 26, 20), TabHover = Color3.fromRGB(22, 36, 28),
        TabTextActive = Color3.fromRGB(255, 255, 255), TabTextInactive = Color3.fromRGB(80, 110, 95),
        RowHover = Color3.fromRGB(20, 32, 26), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(30, 100, 65), Chevron = Color3.fromRGB(70, 100, 85),
        NotifyBg = Color3.fromRGB(12, 20, 16), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    },
    Sunset = {
        Primary = Color3.fromRGB(220, 100, 20), PrimaryDark = Color3.fromRGB(160, 70, 10),
        Background = Color3.fromRGB(16, 13, 10), Secondary = Color3.fromRGB(28, 22, 16),
        TitleBar = Color3.fromRGB(22, 17, 12), Text = Color3.fromRGB(225, 215, 200),
        SubText = Color3.fromRGB(115, 100, 80), Accent = Color3.fromRGB(240, 160, 80),
        Toggle = Color3.fromRGB(45, 36, 26), Input = Color3.fromRGB(34, 28, 20),
        Stroke = Color3.fromRGB(60, 42, 25), TabActive = Color3.fromRGB(220, 100, 20),
        TabInactive = Color3.fromRGB(28, 22, 16), TabHover = Color3.fromRGB(40, 32, 22),
        TabTextActive = Color3.fromRGB(255, 255, 255), TabTextInactive = Color3.fromRGB(115, 100, 80),
        RowHover = Color3.fromRGB(34, 28, 20), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(140, 70, 20), Chevron = Color3.fromRGB(110, 90, 70),
        NotifyBg = Color3.fromRGB(22, 18, 13), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    },
    Dark = {
        Primary = Color3.fromRGB(180, 180, 180), PrimaryDark = Color3.fromRGB(120, 120, 120),
        Background = Color3.fromRGB(12, 12, 12), Secondary = Color3.fromRGB(20, 20, 20),
        TitleBar = Color3.fromRGB(16, 16, 16), Text = Color3.fromRGB(200, 200, 200),
        SubText = Color3.fromRGB(85, 85, 85), Accent = Color3.fromRGB(160, 160, 160),
        Toggle = Color3.fromRGB(35, 35, 35), Input = Color3.fromRGB(26, 26, 26),
        Stroke = Color3.fromRGB(36, 36, 36), TabActive = Color3.fromRGB(50, 50, 50),
        TabInactive = Color3.fromRGB(20, 20, 20), TabHover = Color3.fromRGB(30, 30, 30),
        TabTextActive = Color3.fromRGB(220, 220, 220), TabTextInactive = Color3.fromRGB(80, 80, 80),
        RowHover = Color3.fromRGB(26, 26, 26), Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(60, 60, 60), Chevron = Color3.fromRGB(70, 70, 70),
        NotifyBg = Color3.fromRGB(16, 16, 16), NotifySuccess = Color3.fromRGB(40, 180, 100),
        NotifyError = Color3.fromRGB(200, 50, 50), NotifyWarn = Color3.fromRGB(220, 160, 30)
    }
}

local function lerp(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t) return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t)) end

local function tween(obj, prop, val, dur)
    task.spawn(function()
        local start = obj[prop]
        local steps = math.max(1, math.floor(dur * 60))
        for i = 1, steps do
            local t = i / steps; t = t * t * (3 - 2 * t)
            if typeof(start) == "Color3" then obj[prop] = lerpColor(start, val, t)
            elseif typeof(start) == "UDim2" then
                obj[prop] = UDim2.new(lerp(start.X.Scale, val.X.Scale, t), lerp(start.X.Offset, val.X.Offset, t), lerp(start.Y.Scale, val.Y.Scale, t), lerp(start.Y.Offset, val.Y.Offset, t))
            elseif typeof(start) == "number" then obj[prop] = lerp(start, val, t) end
            RunService.Heartbeat:Wait()
        end
        obj[prop] = val
    end)
end

local function hasDesc(c) return c.Description and c.Description ~= "" end
local function rowH(c, base) return hasDesc(c) and (base + 14) or base end

local function hsvToRgb(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0
    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end
    return Color3.new(math.clamp(r + m, 0, 1), math.clamp(g + m, 0, 1), math.clamp(b + m, 0, 1))
end

local function rgbToHsv(color)
    local r, g, b = color.R, color.G, color.B
    local mx = math.max(r, g, b)
    local mn = math.min(r, g, b)
    local d = mx - mn
    local h, s, v = 0, 0, mx
    if mx ~= 0 then s = d / mx end
    if d ~= 0 then
        if mx == r then h = 60 * (((g - b) / d) % 6)
        elseif mx == g then h = 60 * (((b - r) / d) + 2)
        else h = 60 * (((r - g) / d) + 4) end
    end
    if h < 0 then h = h + 360 end
    return h, s, v
end

function WimplyUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Wimply.xyz"
    local size = config.Size or UDim2.new(0, isMobile and 340 or 420, 0, isMobile and 460 or 520)
    local minSize = config.MinSize or {X = 300, Y = 250}
    local themeName = config.Theme or "Amethyst"
    local minimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    local configFolder = config.ConfigFolder or "WimplyUI"
    local titleImage = config.Icon
    local theme = Themes[themeName] or Themes.Amethyst
    local window = {
        theme = theme, themeName = themeName, tabs = {}, tabOrder = {},
        flags = {}, flagSetters = {}, configFolder = configFolder,
        themedObjects = {}, _dropdownOverlay = nil, _notifyStack = {}
    }

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "WimplyUI_" .. math.random(100000, 999999)
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if Gui.IgnoreGuiInset == false then
    Gui.IgnoreGuiInset = true
    end
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
    if not Gui.Parent then Gui.Parent = Plr:WaitForChild("PlayerGui") end
    window.Gui = Gui

    local notifyHolder = Instance.new("Frame")
    notifyHolder.Size = UDim2.new(0, 260, 1, -20)
    notifyHolder.Position = UDim2.new(1, -270, 0, 10)
    notifyHolder.BackgroundTransparency = 1
    notifyHolder.ZIndex = 300
    notifyHolder.Parent = Gui

    local notifyLayout = Instance.new("UIListLayout")
    notifyLayout.Padding = UDim.new(0, 6)
    notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifyLayout.Parent = notifyHolder

    function window:Notify(cfg)
        cfg = cfg or {}
        local nTitle = cfg.Title or "Notification"
        local nContent = cfg.Content or ""
        local nDuration = cfg.Duration or 4
        local nType = cfg.Type or "info"
        local nIcon = cfg.Icon

        local barColor = self.theme.Primary
        if nType == "success" then barColor = self.theme.NotifySuccess
        elseif nType == "error" then barColor = self.theme.NotifyError
        elseif nType == "warning" then barColor = self.theme.NotifyWarn end

        local lines = math.max(1, math.ceil(#nContent / 35))
        local nh = 36 + lines * 12

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, nh)
        card.BackgroundColor3 = self.theme.NotifyBg
        card.BorderSizePixel = 0
        card.BackgroundTransparency = 1
        card.ZIndex = 301
        card.Parent = notifyHolder
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local ns = Instance.new("UIStroke", card)
        ns.Color = self.theme.Stroke; ns.Thickness = 1; ns.Transparency = 0.5

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 3, 0.7, 0)
        bar.Position = UDim2.new(0, 6, 0.15, 0)
        bar.BackgroundColor3 = barColor
        bar.BorderSizePixel = 0
        bar.ZIndex = 302
        bar.Parent = card
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local xOff = 16
        if nIcon then
            local ico = Instance.new("ImageLabel")
            ico.Size = UDim2.new(0, 16, 0, 16)
            ico.Position = UDim2.new(0, 16, 0, 8)
            ico.BackgroundTransparency = 1
            ico.Image = nIcon
            ico.ScaleType = Enum.ScaleType.Fit
            ico.ZIndex = 302
            ico.Parent = card
            xOff = 38
        end

        local nt = Instance.new("TextLabel")
        nt.Size = UDim2.new(1, -(xOff + 8), 0, 16)
        nt.Position = UDim2.new(0, xOff, 0, 6)
        nt.BackgroundTransparency = 1
        nt.Text = nTitle
        nt.TextColor3 = self.theme.Text
        nt.Font = Enum.Font.GothamBold
        nt.TextSize = 11
        nt.TextXAlignment = Enum.TextXAlignment.Left
        nt.ZIndex = 302
        nt.Parent = card

        if nContent ~= "" then
            local nc = Instance.new("TextLabel")
            nc.Size = UDim2.new(1, -(xOff + 8), 0, lines * 12)
            nc.Position = UDim2.new(0, xOff, 0, 22)
            nc.BackgroundTransparency = 1
            nc.Text = nContent
            nc.TextColor3 = self.theme.SubText
            nc.Font = Enum.Font.Gotham
            nc.TextSize = 10
            nc.TextWrapped = true
            nc.TextXAlignment = Enum.TextXAlignment.Left
            nc.TextYAlignment = Enum.TextYAlignment.Top
            nc.ZIndex = 302
            nc.Parent = card
        end

        local prog = Instance.new("Frame")
        prog.Size = UDim2.new(1, 0, 0, 2)
        prog.Position = UDim2.new(0, 0, 1, -2)
        prog.BackgroundColor3 = barColor
        prog.BackgroundTransparency = 0.5
        prog.BorderSizePixel = 0
        prog.ZIndex = 302
        prog.Parent = card

        task.spawn(function()
            tween(card, "BackgroundTransparency", 0, 0.15)
            task.wait(0.1)
            tween(prog, "Size", UDim2.new(0, 0, 0, 2), nDuration)
            task.wait(nDuration)
            tween(card, "BackgroundTransparency", 1, 0.2)
            task.wait(0.25)
            card:Destroy()
        end)
    end

    local introFrame = Instance.new("Frame")
    introFrame.Size = UDim2.new(1, 0, 1, 0)
    introFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    introFrame.BorderSizePixel = 0; introFrame.ZIndex = 200; introFrame.Parent = Gui

    local introGlow = Instance.new("Frame")
    introGlow.Size = UDim2.new(0, 4, 0, 4)
    introGlow.Position = UDim2.new(0.5, -2, 0.5, -2)
    introGlow.BackgroundColor3 = theme.Primary
    introGlow.BorderSizePixel = 0; introGlow.ZIndex = 201; introGlow.Parent = introFrame
    Instance.new("UICorner", introGlow).CornerRadius = UDim.new(1, 0)

    local introTitle = Instance.new("TextLabel")
    introTitle.Size = UDim2.new(1, 0, 0, 30)
    introTitle.Position = UDim2.new(0, 0, 0.5, 30)
    introTitle.BackgroundTransparency = 1; introTitle.Text = title
    introTitle.TextColor3 = theme.Accent; introTitle.TextTransparency = 1
    introTitle.Font = Enum.Font.GothamBold; introTitle.TextSize = 18
    introTitle.ZIndex = 202; introTitle.Parent = introFrame

    local introSub = Instance.new("TextLabel")
    introSub.Size = UDim2.new(1, 0, 0, 20)
    introSub.Position = UDim2.new(0, 0, 0.5, 60)
    introSub.BackgroundTransparency = 1; introSub.Text = "loading..."
    introSub.TextColor3 = theme.SubText; introSub.TextTransparency = 1
    introSub.Font = Enum.Font.Gotham; introSub.TextSize = 11
    introSub.ZIndex = 202; introSub.Parent = introFrame

    task.spawn(function()
        tween(introGlow, "Size", UDim2.new(0, 60, 0, 60), 0.3)
        tween(introGlow, "Position", UDim2.new(0.5, -30, 0.5, -30), 0.3)
        task.wait(0.15)
        tween(introTitle, "TextTransparency", 0, 0.25)
        tween(introSub, "TextTransparency", 0, 0.25)
        task.wait(0.2)
        tween(introGlow, "Size", UDim2.new(0, 200, 0, 200), 0.35)
        tween(introGlow, "Position", UDim2.new(0.5, -100, 0.5, -100), 0.35)
        tween(introGlow, "BackgroundTransparency", 0.8, 0.35)
        task.wait(0.4)
        introSub.Text = "ready"
        task.wait(0.3)
        tween(introFrame, "BackgroundTransparency", 1, 0.3)
        tween(introGlow, "BackgroundTransparency", 1, 0.3)
        tween(introTitle, "TextTransparency", 1, 0.2)
        tween(introSub, "TextTransparency", 1, 0.2)
        task.wait(0.35)
        introFrame:Destroy()
    end)

    local Main = Instance.new("Frame")
    Main.Size = size; Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = theme.Background; Main.BorderSizePixel = 0
    Main.ClipsDescendants = true; Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = theme.Stroke; mainStroke.Thickness = 1; mainStroke.Transparency = 0.4
    window.Main = Main
    table.insert(window.themedObjects, {obj = Main, prop = "BackgroundColor3", key = "Background"})
    table.insert(window.themedObjects, {obj = mainStroke, prop = "Color", key = "Stroke"})

    local dragging, dragStart, startPos = false, nil, nil
    local resizing, resizeStart, resizeSize = false, nil, nil

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local ap = Main.AbsolutePosition; local as = Main.AbsoluteSize
            local mx, my = input.Position.X - ap.X, input.Position.Y - ap.Y
            if mx > as.X - 22 and my > as.Y - 22 then
                resizing = true; resizeStart = input.Position; resizeSize = Main.Size
            elseif my < 38 then
                dragging = true; dragStart = input.Position; startPos = Main.Position
            end
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false; resizing = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and dragStart then
                local d = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
            if resizing and resizeStart then
                local d = input.Position - resizeStart
                Main.Size = UDim2.new(0, math.max(minSize.X, resizeSize.X.Offset + d.X), 0, math.max(minSize.Y, resizeSize.Y.Offset + d.Y))
            end
        end
    end)

    local rh = Instance.new("TextLabel")
    rh.Size = UDim2.new(0, 12, 0, 12); rh.Position = UDim2.new(1, -14, 1, -14)
    rh.BackgroundTransparency = 1; rh.Text = "⋱"; rh.TextColor3 = theme.SubText
    rh.TextSize = 10; rh.Font = Enum.Font.Gotham; rh.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 38); TitleBar.BackgroundColor3 = theme.TitleBar
    TitleBar.BorderSizePixel = 0; TitleBar.Parent = Main
    table.insert(window.themedObjects, {obj = TitleBar, prop = "BackgroundColor3", key = "TitleBar"})

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1); sep.Position = UDim2.new(0, 0, 1, 0)
    sep.BackgroundColor3 = theme.Stroke; sep.BackgroundTransparency = 0.6
    sep.BorderSizePixel = 0; sep.Parent = TitleBar
    table.insert(window.themedObjects, {obj = sep, prop = "BackgroundColor3", key = "Stroke"})

    local txOff = 14
    if titleImage then
        local ico = Instance.new("ImageLabel")
        ico.Size = UDim2.new(0, 22, 0, 22); ico.Position = UDim2.new(0, 10, 0.5, -11)
        ico.BackgroundTransparency = 1; ico.Image = titleImage
        ico.ScaleType = Enum.ScaleType.Fit; ico.Parent = TitleBar
        txOff = 38
    end

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -(txOff + 75), 1, 0)
    TitleText.Position = UDim2.new(0, txOff, 0, 0)
    TitleText.BackgroundTransparency = 1; TitleText.Text = title
    TitleText.TextColor3 = theme.Accent; TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 13; TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    table.insert(window.themedObjects, {obj = TitleText, prop = "TextColor3", key = "Accent"})

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 26, 0, 26); MinBtn.Position = UDim2.new(1, -62, 0, 6)
    MinBtn.BackgroundColor3 = theme.Input; MinBtn.Text = "–"
    MinBtn.TextColor3 = theme.SubText; MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14; MinBtn.BorderSizePixel = 0; MinBtn.AutoButtonColor = false
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
    table.insert(window.themedObjects, {obj = MinBtn, prop = "BackgroundColor3", key = "Input"})

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -32, 0, 6)
    CloseBtn.BackgroundColor3 = theme.Close; CloseBtn.BackgroundTransparency = 0.4
    CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.fromRGB(220, 180, 180)
    CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0; CloseBtn.AutoButtonColor = false; CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(1, -16, 0, 30); TabBar.Position = UDim2.new(0, 8, 0, 42)
    TabBar.BackgroundTransparency = 1; TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X; TabBar.BorderSizePixel = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0); TabBar.Parent = Main

    local tabLay = Instance.new("UIListLayout")
    tabLay.FillDirection = Enum.FillDirection.Horizontal; tabLay.Padding = UDim.new(0, 4)
    tabLay.SortOrder = Enum.SortOrder.LayoutOrder; tabLay.Parent = TabBar
    tabLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, tabLay.AbsoluteContentSize.X + 10, 0, 0)
    end)

    local tabSep = Instance.new("Frame")
    tabSep.Size = UDim2.new(1, 0, 0, 1); tabSep.Position = UDim2.new(0, 0, 0, 74)
    tabSep.BackgroundColor3 = theme.Stroke; tabSep.BackgroundTransparency = 0.7
    tabSep.BorderSizePixel = 0; tabSep.Parent = Main
    table.insert(window.themedObjects, {obj = tabSep, prop = "BackgroundColor3", key = "Stroke"})

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -16, 1, -82)
    ContentFrame.Position = UDim2.new(0, 8, 0, 78)
    ContentFrame.BackgroundTransparency = 1; ContentFrame.ScrollBarThickness = 2
    ContentFrame.ScrollBarImageColor3 = theme.ScrollBar; ContentFrame.ScrollBarImageTransparency = 0.3
    ContentFrame.BorderSizePixel = 0; ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = Main
    table.insert(window.themedObjects, {obj = ContentFrame, prop = "ScrollBarImageColor3", key = "ScrollBar"})

    local cLay = Instance.new("UIListLayout")
    cLay.Padding = UDim.new(0, 4); cLay.SortOrder = Enum.SortOrder.LayoutOrder; cLay.Parent = ContentFrame
    cLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, cLay.AbsoluteContentSize.Y + 8)
    end)

    window.TabBar = TabBar; window.ContentFrame = ContentFrame

    local minimized, savedSize = false, nil
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        ContentFrame.Visible = not minimized; TabBar.Visible = not minimized
        tabSep.Visible = not minimized; rh.Visible = not minimized
        if minimized then savedSize = Main.Size; tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 38), 0.12)
        else tween(Main, "Size", savedSize or size, 0.12) end
        MinBtn.Text = minimized and "+" or "–"
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 0), 0.12); task.wait(0.15); Gui:Destroy()
    end)

    if isMobile then
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(0, 44, 0, 44); ob.Position = UDim2.new(0, 8, 0.5, -22)
        ob.BackgroundColor3 = theme.Primary; ob.BackgroundTransparency = 0.2
        ob.Text = "W"; ob.TextColor3 = Color3.fromRGB(255, 255, 255)
        ob.Font = Enum.Font.GothamBold; ob.TextSize = 15; ob.BorderSizePixel = 0; ob.Parent = Gui
        Instance.new("UICorner", ob).CornerRadius = UDim.new(1, 0)
        table.insert(window.themedObjects, {obj = ob, prop = "BackgroundColor3", key = "Primary"})
        local md, ms, mp, mv = false, nil, nil, false
        ob.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                md = true; mv = false; ms = i.Position; mp = ob.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then md = false; if not mv then Main.Visible = not Main.Visible end end end)
            end
        end)
        ob.InputChanged:Connect(function(i)
            if md and i.UserInputType == Enum.UserInputType.Touch then
                local d = i.Position - ms; if d.Magnitude > 5 then mv = true end
                ob.Position = UDim2.new(mp.X.Scale, mp.X.Offset + d.X, mp.Y.Scale, mp.Y.Offset + d.Y)
            end
        end)
        ob.MouseButton1Click:Connect(function() if not mv then Main.Visible = not Main.Visible end end)
    else
        UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == minimizeKey then Main.Visible = not Main.Visible end end)
    end

    local currentTabName = nil
    local function switchTab(name)
        currentTabName = name
        for _, c in ipairs(ContentFrame:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
        for tn, td in pairs(window.tabs) do
            if tn == name then
                td.btn.BackgroundColor3 = window.theme.TabActive
                td.tabLbl.TextColor3 = window.theme.TabTextActive
                for _, el in ipairs(td.elements) do el.Visible = true end
            else
                td.btn.BackgroundColor3 = window.theme.TabInactive
                td.tabLbl.TextColor3 = window.theme.TabTextInactive
            end
        end
        ContentFrame.CanvasPosition = Vector2.new(0, 0)
    end

    function window:SetTheme(n)
        local t = Themes[n]; if not t then return end
        self.theme = t; self.themeName = n
        for _, e in ipairs(self.themedObjects) do
            if e.obj and e.obj.Parent then pcall(function() e.obj[e.prop] = t[e.key] end) end
        end
        if currentTabName then switchTab(currentTabName) end
    end

    function window:SaveConfig(n)
        n = n or "default"; local data = {}
        for f, v in pairs(self.flags) do
            if typeof(v) == "EnumItem" then data[f] = {_t = "key", _v = v.Name}
            elseif typeof(v) == "Color3" then data[f] = {_t = "c3", _r = math.floor(v.R*255), _g = math.floor(v.G*255), _b = math.floor(v.B*255)}
            elseif typeof(v) == "table" then data[f] = {_t = "tbl", _v = v}
            else data[f] = v end
        end
        data["_theme"] = self.themeName
        pcall(function()
            if not isfolder(self.configFolder) then makefolder(self.configFolder) end
            writefile(self.configFolder .. "/" .. n .. ".json", HttpService:JSONEncode(data))
        end)
    end

    function window:LoadConfig(n)
        n = n or "default"
        local ok, raw = pcall(function() return readfile(self.configFolder .. "/" .. n .. ".json") end)
        if not ok then return false end
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok2 then return false end
        if data["_theme"] then self:SetTheme(data["_theme"]) end
        for f, v in pairs(data) do
            if f == "_theme" then continue end
            if typeof(v) == "table" and v._t == "key" then v = Enum.KeyCode[v._v]
            elseif typeof(v) == "table" and v._t == "c3" then v = Color3.fromRGB(v._r, v._g, v._b)
            elseif typeof(v) == "table" and v._t == "tbl" then v = v._v end
            self.flags[f] = v
            if self.flagSetters[f] then pcall(function() self.flagSetters[f](v) end) end
        end
        return true
    end

    function window:GetConfigs()
        local c = {}
        pcall(function() if isfolder(self.configFolder) then
            for _, f in ipairs(listfiles(self.configFolder)) do local n = f:match("([^/\\]+)%.json$"); if n then table.insert(c, n) end end
        end end); return c
    end
    function window:DeleteConfig(n) pcall(function() delfile(self.configFolder .. "/" .. n .. ".json") end) end
    function window:SetAutoStart(n) pcall(function() if not isfolder(self.configFolder) then makefolder(self.configFolder) end; writefile(self.configFolder .. "/_autostart.txt", n) end) end
    function window:GetAutoStart() local ok, n = pcall(function() return readfile(self.configFolder .. "/_autostart.txt") end); return (ok and n and n ~= "") and n or nil end
    function window:AutoLoad() local a = self:GetAutoStart(); return a and self:LoadConfig(a) or false end

    local function addDesc(row, text, th, to, y)
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -56, 0, 12); d.Position = UDim2.new(0, 10, 0, y)
        d.BackgroundTransparency = 1; d.Text = text; d.TextColor3 = th.SubText
        d.Font = Enum.Font.Gotham; d.TextSize = 9; d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = row; table.insert(to, {obj = d, prop = "TextColor3", key = "SubText"})
    end

    function window:AddTab(cfg)
        cfg = cfg or {}; local name = cfg.Title or "Tab"; local tabIcon = cfg.Icon
        local tab = {elements = {}, addOrder = 0}
        local bw = math.max(55, #name * 7 + 18); if tabIcon then bw = bw + 20 end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, bw, 0, 26); btn.BackgroundColor3 = window.theme.TabInactive
        btn.Text = ""; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = TabBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        tab.btn = btn

        local lx = 8
        if tabIcon then
            local ti = Instance.new("ImageLabel")
            ti.Size = UDim2.new(0, 14, 0, 14); ti.Position = UDim2.new(0, 6, 0.5, -7)
            ti.BackgroundTransparency = 1; ti.Image = tabIcon; ti.ScaleType = Enum.ScaleType.Fit; ti.Parent = btn
            lx = 24
        end

        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, -(lx + 4), 1, 0); tl.Position = UDim2.new(0, lx, 0, 0)
        tl.BackgroundTransparency = 1; tl.Text = name; tl.TextColor3 = window.theme.TabTextInactive
        tl.Font = Enum.Font.GothamMedium; tl.TextSize = 11; tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.Parent = btn; tab.tabLbl = tl

        btn.MouseEnter:Connect(function()
            if currentTabName ~= name then tween(btn, "BackgroundColor3", window.theme.TabHover, 0.1); tween(tl, "TextColor3", window.theme.Text, 0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if currentTabName ~= name then tween(btn, "BackgroundColor3", window.theme.TabInactive, 0.1); tween(tl, "TextColor3", window.theme.TabTextInactive, 0.1) end
        end)
        btn.MouseButton1Click:Connect(function() switchTab(name) end)

        window.tabs[name] = tab; table.insert(window.tabOrder, name)

        local function makeRow(h)
            tab.addOrder = tab.addOrder + 1
            local r = Instance.new("Frame")
            r.Size = UDim2.new(1, 0, 0, h or 34); r.BackgroundColor3 = window.theme.Secondary
            r.BorderSizePixel = 0; r.LayoutOrder = tab.addOrder; r.Visible = false; r.Parent = ContentFrame
            Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
            table.insert(tab.elements, r)
            table.insert(window.themedObjects, {obj = r, prop = "BackgroundColor3", key = "Secondary"})
            r.MouseEnter:Connect(function() tween(r, "BackgroundColor3", window.theme.RowHover, 0.08) end)
            r.MouseLeave:Connect(function() tween(r, "BackgroundColor3", window.theme.Secondary, 0.08) end)
            return r
        end

        local T = {}

        function T:AddToggle(c)
            c = c or {}; local h = rowH(c, 34); local row = makeRow(h); local dy = hasDesc(c)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -56, 0, dy and 16 or h); lbl.Position = UDim2.new(0, 10, 0, dy and 4 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Toggle"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if dy then addDesc(row, c.Description, window.theme, window.themedObjects, 20) end

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 32, 0, 16); bg.Position = UDim2.new(1, -42, 0, dy and 9 or (h/2 - 8))
            bg.BackgroundColor3 = c.Default and window.theme.Primary or window.theme.Toggle; bg.BorderSizePixel = 0; bg.Parent = row
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local ci = Instance.new("Frame")
            ci.Size = UDim2.new(0, 12, 0, 12)
            ci.Position = c.Default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            ci.BackgroundColor3 = Color3.new(1, 1, 1); ci.BorderSizePixel = 0; ci.Parent = bg
            Instance.new("UICorner", ci).CornerRadius = UDim.new(1, 0)
            local st = c.Default or false; local cb = c.Callback or function() end; local fl = c.Flag
            local function set(v, sk)
                st = v; tween(bg, "BackgroundColor3", st and window.theme.Primary or window.theme.Toggle, 0.12)
                tween(ci, "Position", st and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), 0.12)
                if fl then window.flags[fl] = st end; if not sk then cb(st) end
            end
            local btn2 = Instance.new("TextButton"); btn2.Size = UDim2.new(1, 0, 1, 0); btn2.BackgroundTransparency = 1; btn2.Text = ""; btn2.Parent = row
            btn2.MouseButton1Click:Connect(function() set(not st) end)
            if fl then window.flags[fl] = st; window.flagSetters[fl] = function(v) set(v, false) end end
            local o = {}; function o:Set(v) set(v) end; function o:Get() return st end; return o
        end

        function T:AddButton(c)
            c = c or {}; local h = hasDesc(c) and 46 or 36; local row = makeRow(h); local cb = c.Callback or function() end
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -36, 0, hasDesc(c) and 16 or h); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 6 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Button"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 22) end
            local ch = Instance.new("TextLabel")
            ch.Size = UDim2.new(0, 20, 0, 20); ch.Position = UDim2.new(1, -26, 0.5, -10)
            ch.BackgroundTransparency = 1; ch.Text = "›"; ch.TextColor3 = window.theme.Chevron
            ch.Font = Enum.Font.GothamBold; ch.TextSize = 18; ch.Parent = row
            table.insert(window.themedObjects, {obj = ch, prop = "TextColor3", key = "Chevron"})
            local btn2 = Instance.new("TextButton"); btn2.Size = UDim2.new(1, 0, 1, 0); btn2.BackgroundTransparency = 1; btn2.Text = ""; btn2.Parent = row
            btn2.MouseButton1Click:Connect(function()
                tween(ch, "TextColor3", window.theme.Primary, 0.08); task.wait(0.08)
                tween(ch, "TextColor3", window.theme.Chevron, 0.15); cb()
            end)
        end

        function T:AddSlider(c)
            c = c or {}; local mn, mx = c.Min or 0, c.Max or 100; local def = c.Default or mn
            local inc = c.Increment or 1; local fl = c.Flag; local cb = c.Callback or function() end
            local h = hasDesc(c) and 56 or 44; local row = makeRow(h)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 0, 16); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 3 or 2)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Slider"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 18) end
            local vl = Instance.new("TextLabel")
            vl.Size = UDim2.new(0, 40, 0, 16); vl.Position = UDim2.new(1, -50, 0, hasDesc(c) and 3 or 2)
            vl.BackgroundTransparency = 1; vl.Text = tostring(def); vl.TextColor3 = window.theme.Accent
            vl.Font = Enum.Font.GothamMedium; vl.TextSize = 11; vl.TextXAlignment = Enum.TextXAlignment.Right; vl.Parent = row
            table.insert(window.themedObjects, {obj = vl, prop = "TextColor3", key = "Accent"})
            local sb = Instance.new("Frame")
            sb.Size = UDim2.new(1, -20, 0, 6); sb.Position = UDim2.new(0, 10, 1, -14)
            sb.BackgroundColor3 = window.theme.Toggle; sb.BorderSizePixel = 0; sb.Parent = row
            Instance.new("UICorner", sb).CornerRadius = UDim.new(1, 0)
            table.insert(window.themedObjects, {obj = sb, prop = "BackgroundColor3", key = "Toggle"})
            local fi = Instance.new("Frame")
            fi.Size = UDim2.new(math.clamp((def - mn) / (mx - mn), 0, 1), 0, 1, 0)
            fi.BackgroundColor3 = window.theme.Primary; fi.BorderSizePixel = 0; fi.Parent = sb
            Instance.new("UICorner", fi).CornerRadius = UDim.new(1, 0)
            table.insert(window.themedObjects, {obj = fi, prop = "BackgroundColor3", key = "Primary"})
            local val = def; if fl then window.flags[fl] = val end; local sl = false
            local function upd(i)
                local p = math.clamp((i.Position.X - sb.AbsolutePosition.X) / sb.AbsoluteSize.X, 0, 1)
                val = math.clamp(math.floor((mn + (mx - mn) * p) / inc + 0.5) * inc, mn, mx)
                fi.Size = UDim2.new((val - mn) / (mx - mn), 0, 1, 0); vl.Text = tostring(val)
                if fl then window.flags[fl] = val end; cb(val)
            end
            sb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sl = true; upd(i) end end)
            UIS.InputChanged:Connect(function(i) if sl and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sl = false end end)
            if fl then window.flagSetters[fl] = function(v) val = math.clamp(v, mn, mx); fi.Size = UDim2.new((val - mn) / (mx - mn), 0, 1, 0); vl.Text = tostring(val); cb(val) end end
            local o = {}; function o:Set(v) val = math.clamp(v, mn, mx); fi.Size = UDim2.new((val - mn) / (mx - mn), 0, 1, 0); vl.Text = tostring(val); if fl then window.flags[fl] = val end; cb(val) end; function o:Get() return val end; return o
        end

        function T:AddDropdown(c)
            c = c or {}; local multi = c.MultiSelect or false; local aos = c.ActivateOnSelect or false
            local opts = c.Options or {}; local fl = c.Flag; local cb = c.Callback or function() end
            local sel = multi and (c.Default or {}) or (c.Default or opts[1] or "")
            local h = rowH(c, 34); local row = makeRow(h)
            local function gd() if multi then return #sel == 0 and "None" or table.concat(sel, ", ") end; return tostring(sel) end

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 0, hasDesc(c) and 16 or h); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 4 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Dropdown"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 20) end

            local dbtn = Instance.new("TextButton")
            dbtn.Size = UDim2.new(0.5, -14, 0, 22); dbtn.Position = UDim2.new(0.5, 4, 0, hasDesc(c) and 6 or (h/2 - 11))
            dbtn.BackgroundColor3 = window.theme.Input; dbtn.Text = gd(); dbtn.TextColor3 = window.theme.Accent
            dbtn.Font = Enum.Font.GothamMedium; dbtn.TextSize = 10; dbtn.TextTruncate = Enum.TextTruncate.AtEnd
            dbtn.BorderSizePixel = 0; dbtn.AutoButtonColor = false; dbtn.Parent = row
            Instance.new("UICorner", dbtn).CornerRadius = UDim.new(0, 5)
            table.insert(window.themedObjects, {obj = dbtn, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = dbtn, prop = "TextColor3", key = "Accent"})
            if fl then window.flags[fl] = sel end

            local dOpen = false
            local function cDD() if window._dropdownOverlay then window._dropdownOverlay:Destroy(); window._dropdownOverlay = nil end; dOpen = false end
            local function oDD()
                cDD(); dOpen = true
                local ov = Instance.new("Frame"); ov.Size = UDim2.new(1, 0, 1, 0); ov.BackgroundTransparency = 1; ov.ZIndex = 100; ov.Parent = Main
                window._dropdownOverlay = ov
                local bg2 = Instance.new("TextButton"); bg2.Size = UDim2.new(1, 0, 1, 0); bg2.BackgroundTransparency = 0.7; bg2.BackgroundColor3 = Color3.new(0, 0, 0)
                bg2.Text = ""; bg2.ZIndex = 100; bg2.Parent = ov; bg2.MouseButton1Click:Connect(cDD)
                local lH = math.min(#opts * 28 + 4, 180); local ab = dbtn.AbsolutePosition; local am = Main.AbsolutePosition
                local ls = Instance.new("ScrollingFrame")
                ls.Size = UDim2.new(0, dbtn.AbsoluteSize.X, 0, lH)
                ls.Position = UDim2.new(0, ab.X - am.X, 0, ab.Y - am.Y + dbtn.AbsoluteSize.Y + 2)
                ls.BackgroundColor3 = window.theme.TitleBar; ls.BorderSizePixel = 0; ls.ScrollBarThickness = 2
                ls.ScrollBarImageColor3 = window.theme.ScrollBar; ls.CanvasSize = UDim2.new(0, 0, 0, #opts * 28 + 4)
                ls.ZIndex = 101; ls.Parent = ov
                Instance.new("UICorner", ls).CornerRadius = UDim.new(0, 6)
                local lss = Instance.new("UIStroke", ls); lss.Color = window.theme.Stroke; lss.Thickness = 1
                local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 2); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = ls
                Instance.new("UIPadding", ls).PaddingTop = UDim.new(0, 2)
                for _, op in ipairs(opts) do
                    local ob2 = Instance.new("TextButton"); ob2.Size = UDim2.new(1, -4, 0, 26); ob2.BackgroundTransparency = 1; ob2.Text = ""; ob2.AutoButtonColor = false; ob2.ZIndex = 102; ob2.Parent = ls
                    local ol = Instance.new("TextLabel"); ol.Size = UDim2.new(1, -28, 1, 0); ol.Position = UDim2.new(0, 8, 0, 0); ol.BackgroundTransparency = 1; ol.Text = op; ol.Font = Enum.Font.Gotham; ol.TextSize = 10; ol.TextXAlignment = Enum.TextXAlignment.Left; ol.ZIndex = 102; ol.Parent = ob2
                    local iS = multi and table.find(sel, op) ~= nil or (not multi and sel == op)
                    ol.TextColor3 = iS and window.theme.Primary or window.theme.Text
                    if multi then
                        local ck = Instance.new("TextLabel"); ck.Size = UDim2.new(0, 16, 0, 16); ck.Position = UDim2.new(1, -22, 0.5, -8)
                        ck.BackgroundTransparency = 1; ck.Text = iS and "✓" or ""; ck.TextColor3 = window.theme.Primary; ck.Font = Enum.Font.GothamBold; ck.TextSize = 12; ck.ZIndex = 102; ck.Parent = ob2
                        ob2.MouseButton1Click:Connect(function()
                            local idx = table.find(sel, op)
                            if idx then table.remove(sel, idx); ck.Text = ""; ol.TextColor3 = window.theme.Text
                            else table.insert(sel, op); ck.Text = "✓"; ol.TextColor3 = window.theme.Primary end
                            dbtn.Text = gd(); if fl then window.flags[fl] = sel end; cb(sel)
                        end)
                    else
                        ob2.MouseButton1Click:Connect(function() sel = op; dbtn.Text = gd(); if fl then window.flags[fl] = sel end; cb(sel); cDD() end)
                    end
                    ob2.MouseEnter:Connect(function() ob2.BackgroundTransparency = 0; ob2.BackgroundColor3 = window.theme.RowHover end)
                    ob2.MouseLeave:Connect(function() ob2.BackgroundTransparency = 1 end)
                end
            end
            dbtn.MouseButton1Click:Connect(function() if dOpen then cDD() else oDD() end end)
            if fl then window.flagSetters[fl] = function(v) sel = v; dbtn.Text = gd(); cb(v) end end
            local o = {}; function o:Set(v) sel = v; dbtn.Text = gd(); if fl then window.flags[fl] = sel end; cb(sel) end; function o:Get() return sel end; function o:Refresh(n) opts = n end; return o
        end

        function T:AddColorPicker(c)
            c = c or {}; local fl = c.Flag; local cb = c.Callback or function() end
            local col = c.Default or Color3.fromRGB(255, 0, 0)
            local h, s, v = rgbToHsv(col)
            local rh2 = rowH(c, 34); local row = makeRow(rh2)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -80, 0, hasDesc(c) and 16 or rh2); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 4 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Color"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 20) end

            local preview = Instance.new("Frame")
            preview.Size = UDim2.new(0, 28, 0, 16)
            preview.Position = UDim2.new(1, -42, 0, hasDesc(c) and 9 or (rh2/2 - 8))
            preview.BackgroundColor3 = col; preview.BorderSizePixel = 0; preview.Parent = row
            Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
            local ps = Instance.new("UIStroke", preview); ps.Color = window.theme.Stroke; ps.Thickness = 1

            if fl then window.flags[fl] = col end

            local pickerOpen = false
            local function closePicker()
                if window._dropdownOverlay then window._dropdownOverlay:Destroy(); window._dropdownOverlay = nil end
                pickerOpen = false
            end

            local function apply()
                col = hsvToRgb(h, s, v); preview.BackgroundColor3 = col
                if fl then window.flags[fl] = col end; cb(col)
            end

            local function openPicker()
                closePicker(); pickerOpen = true
                local ov = Instance.new("Frame"); ov.Size = UDim2.new(1, 0, 1, 0); ov.BackgroundTransparency = 1; ov.ZIndex = 100; ov.Parent = Main
                window._dropdownOverlay = ov
                local bg2 = Instance.new("TextButton"); bg2.Size = UDim2.new(1, 0, 1, 0); bg2.BackgroundTransparency = 0.7; bg2.BackgroundColor3 = Color3.new(0, 0, 0)
                bg2.Text = ""; bg2.ZIndex = 100; bg2.Parent = ov; bg2.MouseButton1Click:Connect(closePicker)

                local ap = preview.AbsolutePosition; local am = Main.AbsolutePosition
                local panel = Instance.new("Frame")
                panel.Size = UDim2.new(0, 200, 0, 180)
                panel.Position = UDim2.new(0, math.clamp(ap.X - am.X - 160, 4, Main.AbsoluteSize.X - 204), 0, ap.Y - am.Y + 20)
                panel.BackgroundColor3 = window.theme.TitleBar; panel.BorderSizePixel = 0; panel.ZIndex = 101; panel.Parent = ov
                Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
                local pst = Instance.new("UIStroke", panel); pst.Color = window.theme.Stroke; pst.Thickness = 1

                local svBox = Instance.new("Frame")
                svBox.Size = UDim2.new(0, 150, 0, 100); svBox.Position = UDim2.new(0, 8, 0, 8)
                svBox.BackgroundColor3 = hsvToRgb(h, 1, 1); svBox.BorderSizePixel = 0; svBox.ZIndex = 102
                svBox.ClipsDescendants = true; svBox.Parent = panel
                Instance.new("UICorner", svBox).CornerRadius = UDim.new(0, 6)

                local wGrad = Instance.new("UIGradient")
                wGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
                wGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
                wGrad.Parent = svBox

                local bOverlay = Instance.new("Frame")
                bOverlay.Size = UDim2.new(1, 0, 1, 0); bOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
                bOverlay.BorderSizePixel = 0; bOverlay.ZIndex = 103; bOverlay.Parent = svBox

                local bGrad = Instance.new("UIGradient")
                bGrad.Rotation = 90
                bGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
                bGrad.Parent = bOverlay

                local svCursor = Instance.new("Frame")
                svCursor.Size = UDim2.new(0, 8, 0, 8)
                svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
                svCursor.BackgroundColor3 = Color3.new(1, 1, 1); svCursor.BorderSizePixel = 0; svCursor.ZIndex = 104; svCursor.Parent = svBox
                Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", svCursor).Thickness = 1

                local hueBar = Instance.new("Frame")
                hueBar.Size = UDim2.new(0, 20, 0, 100); hueBar.Position = UDim2.new(0, 168, 0, 8)
                hueBar.BorderSizePixel = 0; hueBar.ZIndex = 102; hueBar.ClipsDescendants = true; hueBar.Parent = panel
                Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 4)

                local hGrad = Instance.new("UIGradient")
                hGrad.Rotation = 90
                hGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                hGrad.Parent = hueBar
                hueBar.BackgroundColor3 = Color3.new(1, 1, 1)

                local hueCursor = Instance.new("Frame")
                hueCursor.Size = UDim2.new(1, 0, 0, 4)
                hueCursor.Position = UDim2.new(0, 0, h / 360, -2)
                hueCursor.BackgroundColor3 = Color3.new(1, 1, 1); hueCursor.BorderSizePixel = 0; hueCursor.ZIndex = 103; hueCursor.Parent = hueBar
                Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1, 0)

                local pvw = Instance.new("Frame")
                pvw.Size = UDim2.new(0, 184, 0, 20); pvw.Position = UDim2.new(0, 8, 0, 114)
                pvw.BackgroundColor3 = col; pvw.BorderSizePixel = 0; pvw.ZIndex = 102; pvw.Parent = panel
                Instance.new("UICorner", pvw).CornerRadius = UDim.new(0, 4)

                local rgbLabel = Instance.new("TextLabel")
                rgbLabel.Size = UDim2.new(0, 184, 0, 14); rgbLabel.Position = UDim2.new(0, 8, 0, 136)
                rgbLabel.BackgroundTransparency = 1; rgbLabel.Font = Enum.Font.GothamMedium; rgbLabel.TextSize = 10
                rgbLabel.TextColor3 = window.theme.SubText; rgbLabel.ZIndex = 102; rgbLabel.Parent = panel

                local function refreshRgb()
                    local cc = hsvToRgb(h, s, v)
                    rgbLabel.Text = string.format("R: %d  G: %d  B: %d", math.floor(cc.R * 255), math.floor(cc.G * 255), math.floor(cc.B * 255))
                    pvw.BackgroundColor3 = cc; svBox.BackgroundColor3 = hsvToRgb(h, 1, 1)
                end
                refreshRgb()

                local presets = {
                    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 85, 0), Color3.fromRGB(255, 170, 0),
                    Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 170),
                    Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 85, 255), Color3.fromRGB(85, 0, 255),
                    Color3.fromRGB(170, 0, 255), Color3.fromRGB(255, 0, 170), Color3.fromRGB(255, 255, 255)
                }

                local presetRow = Instance.new("Frame")
                presetRow.Size = UDim2.new(0, 184, 0, 14); presetRow.Position = UDim2.new(0, 8, 0, 156)
                presetRow.BackgroundTransparency = 1; presetRow.ZIndex = 102; presetRow.Parent = panel
                local pl = Instance.new("UIListLayout"); pl.FillDirection = Enum.FillDirection.Horizontal; pl.Padding = UDim.new(0, 3); pl.Parent = presetRow

                for _, pc in ipairs(presets) do
                    local pb = Instance.new("TextButton")
                    pb.Size = UDim2.new(0, 12, 0, 12); pb.BackgroundColor3 = pc; pb.Text = ""; pb.BorderSizePixel = 0
                    pb.AutoButtonColor = false; pb.ZIndex = 103; pb.Parent = presetRow
                    Instance.new("UICorner", pb).CornerRadius = UDim.new(1, 0)
                    pb.MouseButton1Click:Connect(function()
                        h, s, v = rgbToHsv(pc)
                        svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
                        hueCursor.Position = UDim2.new(0, 0, h / 360, -2)
                        refreshRgb(); apply()
                    end)
                end

                local svDrag = false
                svBox.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDrag = true end
                end)
                UIS.InputChanged:Connect(function(i)
                    if svDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        s = math.clamp((i.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
                        refreshRgb(); apply()
                    end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then svDrag = false end
                end)

                local hueDrag = false
                hueBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then hueDrag = true end
                end)
                UIS.InputChanged:Connect(function(i)
                    if hueDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        h = math.clamp((i.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1) * 360
                        hueCursor.Position = UDim2.new(0, 0, h / 360, -2)
                        refreshRgb(); apply()
                    end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then hueDrag = false end
                end)
            end

            local btn2 = Instance.new("TextButton"); btn2.Size = UDim2.new(1, 0, 1, 0); btn2.BackgroundTransparency = 1; btn2.Text = ""; btn2.Parent = row
            btn2.MouseButton1Click:Connect(function() if pickerOpen then closePicker() else openPicker() end end)

            if fl then window.flagSetters[fl] = function(vv)
                col = vv; h, s, v = rgbToHsv(col); preview.BackgroundColor3 = col; cb(col)
            end end

            local o = {}
            function o:Set(vv) col = vv; h, s, v = rgbToHsv(col); preview.BackgroundColor3 = col; if fl then window.flags[fl] = col end; cb(col) end
            function o:Get() return col end
            return o
        end

        function T:AddInput(c)
            c = c or {}; local fl = c.Flag; local cb = c.Callback or function() end; local def = c.Default or ""
            local h2 = rowH(c, 34); local row = makeRow(h2)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 0, hasDesc(c) and 16 or h2); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 4 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Input"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 20) end
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.55, -10, 0, 22); box.Position = UDim2.new(0.45, 0, 0, hasDesc(c) and 6 or (h2/2 - 11))
            box.BackgroundColor3 = window.theme.Input; box.Text = def; box.PlaceholderText = c.Placeholder or "..."
            box.PlaceholderColor3 = window.theme.SubText; box.TextColor3 = window.theme.Text
            box.Font = Enum.Font.Gotham; box.TextSize = 10; box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Parent = row
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5); Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = box, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = box, prop = "TextColor3", key = "Text"})
            if fl then window.flags[fl] = def end
            box.FocusLost:Connect(function() if fl then window.flags[fl] = box.Text end; cb(box.Text) end)
            if fl then window.flagSetters[fl] = function(vv) box.Text = tostring(vv); cb(vv) end end
            local o = {}; function o:Set(vv) box.Text = tostring(vv); if fl then window.flags[fl] = vv end; cb(vv) end; function o:Get() return box.Text end; return o
        end

        function T:AddParagraph(c)
            c = c or {}; local tt = c.Title or ""; local ct = c.Content or ""
            local lines = math.ceil(#ct / 50); local h2 = (tt ~= "" and 16 or 0) + math.max(16, lines * 13) + 8; local row = makeRow(h2)
            if tt ~= "" then
                local ttl = Instance.new("TextLabel"); ttl.Size = UDim2.new(1, -16, 0, 14); ttl.Position = UDim2.new(0, 8, 0, 3)
                ttl.BackgroundTransparency = 1; ttl.Text = tt; ttl.TextColor3 = window.theme.Accent
                ttl.Font = Enum.Font.GothamMedium; ttl.TextSize = 11; ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.Parent = row
                table.insert(window.themedObjects, {obj = ttl, prop = "TextColor3", key = "Accent"})
            end
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -16, 1, tt ~= "" and -18 or -6); desc.Position = UDim2.new(0, 8, 0, tt ~= "" and 17 or 3)
            desc.BackgroundTransparency = 1; desc.Text = ct; desc.TextColor3 = window.theme.SubText
            desc.Font = Enum.Font.Gotham; desc.TextSize = 10; desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left; desc.TextYAlignment = Enum.TextYAlignment.Top; desc.Parent = row
            table.insert(window.themedObjects, {obj = desc, prop = "TextColor3", key = "SubText"})
            local o = {}; function o:SetTitle(t) end; function o:SetDesc(t) desc.Text = t; local nl = math.ceil(#t / 50); row.Size = UDim2.new(1, 0, 0, (tt ~= "" and 16 or 0) + math.max(16, nl * 13) + 8) end; return o
        end

        function T:AddImage(c)
            c = c or {}; local row = makeRow(c.Height or 120)
            local img = Instance.new("ImageLabel"); img.Size = UDim2.new(1, -16, 1, -8); img.Position = UDim2.new(0, 8, 0, 4)
            img.BackgroundTransparency = 1; img.Image = c.Image or ""; img.ScaleType = c.ScaleType or Enum.ScaleType.Fit; img.Parent = row
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
            local o = {}; function o:Set(id) img.Image = id end; return o
        end

        function T:AddKeybind(c)
            c = c or {}; local fl = c.Flag; local cb = c.Callback or function() end; local ck = c.Default or Enum.KeyCode.Unknown
            local h2 = rowH(c, 34); local row = makeRow(h2)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -90, 0, hasDesc(c) and 16 or h2); lbl.Position = UDim2.new(0, 10, 0, hasDesc(c) and 4 or 0)
            lbl.BackgroundTransparency = 1; lbl.Text = c.Title or "Keybind"; lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})
            if hasDesc(c) then addDesc(row, c.Description, window.theme, window.themedObjects, 20) end
            local kb = Instance.new("TextButton")
            kb.Size = UDim2.new(0, 70, 0, 22); kb.Position = UDim2.new(1, -80, 0, hasDesc(c) and 6 or (h2/2 - 11))
            kb.BackgroundColor3 = window.theme.Input; kb.Text = ck.Name or "None"; kb.TextColor3 = window.theme.Accent
            kb.Font = Enum.Font.GothamMedium; kb.TextSize = 10; kb.BorderSizePixel = 0; kb.AutoButtonColor = false; kb.Parent = row
            Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 5)
            table.insert(window.themedObjects, {obj = kb, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = kb, prop = "TextColor3", key = "Accent"})
            local listening = false; if fl then window.flags[fl] = ck end
            kb.MouseButton1Click:Connect(function() listening = true; kb.Text = "..."; tween(kb, "BackgroundColor3", window.theme.Primary, 0.1) end)
            UIS.InputBegan:Connect(function(i, g)
                if listening then
                    if i.UserInputType == Enum.UserInputType.Keyboard then ck = i.KeyCode; kb.Text = ck.Name; if fl then window.flags[fl] = ck end; listening = false; tween(kb, "BackgroundColor3", window.theme.Input, 0.1) end; return
                end
                if not g and i.KeyCode == ck then cb(ck) end
            end)
            if fl then window.flagSetters[fl] = function(vv) if typeof(vv) == "EnumItem" then ck = vv; kb.Text = vv.Name end end end
            local o = {}; function o:Set(k) ck = k; kb.Text = k.Name; if fl then window.flags[fl] = k end end; function o:Get() return ck end; return o
        end

        return T
    end

    function window:AddConfigTab(c)
        c = c or {}; local t = self:AddTab({ Title = c.Title or "Settings", Icon = c.Icon })
        t:AddParagraph({ Title = "Configuration", Content = "Save and load your settings." })
        t:AddInput({ Title = "Config Name", Placeholder = "my_config", Default = "default", Flag = "_cfgN" })
        t:AddButton({ Title = "Save Config", Description = "Save all current settings.", Callback = function() local n = self.flags["_cfgN"] or "default"; if n == "" then n = "default" end; self:SaveConfig(n) end })
        local cfgs = self:GetConfigs(); if #cfgs == 0 then cfgs = {"default"} end
        local cd = t:AddDropdown({ Title = "Load Config", Options = cfgs, Default = cfgs[1], Flag = "_cfgS", ActivateOnSelect = true, Callback = function(vv) self:LoadConfig(vv) end })
        local ad = t:AddDropdown({ Title = "Auto Load", Description = "Load this config on start.", Options = cfgs, Default = self:GetAutoStart() or cfgs[1], Flag = "_aS", Callback = function(vv) self:SetAutoStart(vv) end })
        t:AddButton({ Title = "Delete Config", Description = "Delete selected config.", Callback = function() self:DeleteConfig(self.flags["_cfgS"] or "default") end })
        t:AddButton({ Title = "Refresh List", Callback = function() local r = self:GetConfigs(); if #r == 0 then r = {"default"} end; cd:Refresh(r); ad:Refresh(r) end })
        t:AddParagraph({ Title = "Theme" })
        t:AddDropdown({ Title = "Theme", Options = {"Amethyst", "Midnight", "Rose", "Emerald", "Sunset", "Dark"}, Default = self.themeName, Callback = function(vv) self:SetTheme(vv) end })
        return t
    end

    function window:SelectTab(idx)
        if type(idx) == "number" then local n = window.tabOrder[idx]; if n then switchTab(n) end
        elseif type(idx) == "string" then if window.tabs[idx] then switchTab(idx) end end
    end
    function window:Destroy() Gui:Destroy() end
    return window
end

WimplyUI.Themes = Themes
return WimplyUI
