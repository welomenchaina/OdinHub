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
        Primary = Color3.fromRGB(127, 2, 195),
        PrimaryDark = Color3.fromRGB(90, 0, 140),
        Background = Color3.fromRGB(14, 12, 20),
        Secondary = Color3.fromRGB(22, 19, 30),
        TitleBar = Color3.fromRGB(18, 15, 24),
        Text = Color3.fromRGB(210, 210, 215),
        SubText = Color3.fromRGB(120, 115, 130),
        Accent = Color3.fromRGB(160, 120, 230),
        Toggle = Color3.fromRGB(38, 34, 50),
        Input = Color3.fromRGB(28, 25, 38),
        Stroke = Color3.fromRGB(60, 40, 90),
        TabActive = Color3.fromRGB(127, 2, 195),
        TabInactive = Color3.fromRGB(24, 21, 32),
        TabHover = Color3.fromRGB(35, 30, 48),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabTextInactive = Color3.fromRGB(100, 95, 115),
        RowHover = Color3.fromRGB(28, 25, 38),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(80, 40, 120)
    },
    Midnight = {
        Primary = Color3.fromRGB(0, 100, 220),
        PrimaryDark = Color3.fromRGB(0, 70, 160),
        Background = Color3.fromRGB(10, 10, 16),
        Secondary = Color3.fromRGB(18, 18, 28),
        TitleBar = Color3.fromRGB(14, 14, 22),
        Text = Color3.fromRGB(200, 205, 215),
        SubText = Color3.fromRGB(100, 105, 125),
        Accent = Color3.fromRGB(80, 140, 230),
        Toggle = Color3.fromRGB(30, 30, 48),
        Input = Color3.fromRGB(22, 22, 36),
        Stroke = Color3.fromRGB(35, 45, 70),
        TabActive = Color3.fromRGB(0, 100, 220),
        TabInactive = Color3.fromRGB(18, 18, 28),
        TabHover = Color3.fromRGB(26, 28, 42),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabTextInactive = Color3.fromRGB(85, 90, 115),
        RowHover = Color3.fromRGB(24, 24, 38),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(40, 70, 130)
    },
    Rose = {
        Primary = Color3.fromRGB(190, 40, 85),
        PrimaryDark = Color3.fromRGB(140, 25, 60),
        Background = Color3.fromRGB(16, 11, 14),
        Secondary = Color3.fromRGB(26, 19, 22),
        TitleBar = Color3.fromRGB(20, 14, 18),
        Text = Color3.fromRGB(215, 205, 210),
        SubText = Color3.fromRGB(130, 110, 120),
        Accent = Color3.fromRGB(230, 120, 160),
        Toggle = Color3.fromRGB(42, 30, 36),
        Input = Color3.fromRGB(32, 24, 28),
        Stroke = Color3.fromRGB(70, 35, 50),
        TabActive = Color3.fromRGB(190, 40, 85),
        TabInactive = Color3.fromRGB(26, 19, 22),
        TabHover = Color3.fromRGB(38, 28, 32),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabTextInactive = Color3.fromRGB(110, 90, 100),
        RowHover = Color3.fromRGB(32, 24, 28),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(120, 40, 70)
    },
    Emerald = {
        Primary = Color3.fromRGB(0, 170, 100),
        PrimaryDark = Color3.fromRGB(0, 120, 70),
        Background = Color3.fromRGB(10, 16, 13),
        Secondary = Color3.fromRGB(16, 26, 20),
        TitleBar = Color3.fromRGB(12, 20, 16),
        Text = Color3.fromRGB(200, 220, 210),
        SubText = Color3.fromRGB(95, 125, 110),
        Accent = Color3.fromRGB(80, 220, 150),
        Toggle = Color3.fromRGB(25, 42, 34),
        Input = Color3.fromRGB(18, 32, 26),
        Stroke = Color3.fromRGB(30, 60, 45),
        TabActive = Color3.fromRGB(0, 170, 100),
        TabInactive = Color3.fromRGB(16, 26, 20),
        TabHover = Color3.fromRGB(22, 36, 28),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabTextInactive = Color3.fromRGB(80, 110, 95),
        RowHover = Color3.fromRGB(20, 32, 26),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(30, 100, 65)
    },
    Sunset = {
        Primary = Color3.fromRGB(220, 100, 20),
        PrimaryDark = Color3.fromRGB(160, 70, 10),
        Background = Color3.fromRGB(16, 13, 10),
        Secondary = Color3.fromRGB(28, 22, 16),
        TitleBar = Color3.fromRGB(22, 17, 12),
        Text = Color3.fromRGB(225, 215, 200),
        SubText = Color3.fromRGB(135, 120, 100),
        Accent = Color3.fromRGB(240, 160, 80),
        Toggle = Color3.fromRGB(45, 36, 26),
        Input = Color3.fromRGB(34, 28, 20),
        Stroke = Color3.fromRGB(70, 50, 30),
        TabActive = Color3.fromRGB(220, 100, 20),
        TabInactive = Color3.fromRGB(28, 22, 16),
        TabHover = Color3.fromRGB(40, 32, 22),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabTextInactive = Color3.fromRGB(115, 100, 80),
        RowHover = Color3.fromRGB(34, 28, 20),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(140, 70, 20)
    },
    Dark = {
        Primary = Color3.fromRGB(180, 180, 180),
        PrimaryDark = Color3.fromRGB(120, 120, 120),
        Background = Color3.fromRGB(12, 12, 12),
        Secondary = Color3.fromRGB(20, 20, 20),
        TitleBar = Color3.fromRGB(16, 16, 16),
        Text = Color3.fromRGB(200, 200, 200),
        SubText = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(160, 160, 160),
        Toggle = Color3.fromRGB(35, 35, 35),
        Input = Color3.fromRGB(26, 26, 26),
        Stroke = Color3.fromRGB(40, 40, 40),
        TabActive = Color3.fromRGB(50, 50, 50),
        TabInactive = Color3.fromRGB(20, 20, 20),
        TabHover = Color3.fromRGB(30, 30, 30),
        TabTextActive = Color3.fromRGB(220, 220, 220),
        TabTextInactive = Color3.fromRGB(80, 80, 80),
        RowHover = Color3.fromRGB(26, 26, 26),
        Close = Color3.fromRGB(160, 40, 40),
        ScrollBar = Color3.fromRGB(60, 60, 60)
    }
}

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpColor(a, b, t)
    return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t))
end

local function tween(obj, prop, val, dur)
    task.spawn(function()
        local start = obj[prop]
        local steps = math.max(1, math.floor(dur * 60))
        for i = 1, steps do
            local t = i / steps
            t = t * t * (3 - 2 * t)
            if typeof(start) == "Color3" then
                obj[prop] = lerpColor(start, val, t)
            elseif typeof(start) == "UDim2" then
                obj[prop] = UDim2.new(
                    lerp(start.X.Scale, val.X.Scale, t), lerp(start.X.Offset, val.X.Offset, t),
                    lerp(start.Y.Scale, val.Y.Scale, t), lerp(start.Y.Offset, val.Y.Offset, t)
                )
            elseif typeof(start) == "number" then
                obj[prop] = lerp(start, val, t)
            end
            RunService.Heartbeat:Wait()
        end
        obj[prop] = val
    end)
end

function WimplyUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Wimply.xyz"
    local size = config.Size or UDim2.new(0, isMobile and 340 or 420, 0, isMobile and 460 or 520)
    local minSize = config.MinSize or {X = 300, Y = 250}
    local themeName = config.Theme or "Amethyst"
    local minimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    local configFolder = config.ConfigFolder or "WimplyUI"
    local theme = Themes[themeName] or Themes.Amethyst
    local window = {
        theme = theme,
        themeName = themeName,
        tabs = {},
        tabOrder = {},
        flags = {},
        flagSetters = {},
        configFolder = configFolder,
        themedObjects = {},
        _dropdownOverlay = nil
    }

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "WimplyUI_" .. math.random(100000, 999999)
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
    if not Gui.Parent then Gui.Parent = Plr:WaitForChild("PlayerGui") end
    window.Gui = Gui

    local Main = Instance.new("Frame")
    Main.Size = size
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = theme.Stroke
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.3
    window.Main = Main
    table.insert(window.themedObjects, {obj = Main, prop = "BackgroundColor3", key = "Background"})
    table.insert(window.themedObjects, {obj = mainStroke, prop = "Color", key = "Stroke"})

    local dragging, dragStart, startPos = false, nil, nil
    local resizing, resizeStart, resizeSize = false, nil, nil

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local absPos = Main.AbsolutePosition
            local absSize = Main.AbsoluteSize
            local mx = input.Position.X - absPos.X
            local my = input.Position.Y - absPos.Y
            if mx > absSize.X - 20 and my > absSize.Y - 20 then
                resizing = true
                resizeStart = input.Position
                resizeSize = Main.Size
            elseif my < 38 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    resizing = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and dragStart then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
            if resizing and resizeStart then
                local delta = input.Position - resizeStart
                local newW = math.max(minSize.X, resizeSize.X.Offset + delta.X)
                local newH = math.max(minSize.Y, resizeSize.Y.Offset + delta.Y)
                Main.Size = UDim2.new(0, newW, 0, newH)
            end
        end
    end)

    local resizeHandle = Instance.new("TextLabel")
    resizeHandle.Size = UDim2.new(0, 12, 0, 12)
    resizeHandle.Position = UDim2.new(1, -14, 1, -14)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = "⋱"
    resizeHandle.TextColor3 = theme.SubText
    resizeHandle.TextSize = 10
    resizeHandle.Font = Enum.Font.Gotham
    resizeHandle.Parent = Main
    table.insert(window.themedObjects, {obj = resizeHandle, prop = "TextColor3", key = "SubText"})

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 38)
    TitleBar.BackgroundColor3 = theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    table.insert(window.themedObjects, {obj = TitleBar, prop = "BackgroundColor3", key = "TitleBar"})

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = UDim2.new(0, 0, 1, 0)
    sep.BackgroundColor3 = theme.Stroke
    sep.BackgroundTransparency = 0.6
    sep.BorderSizePixel = 0
    sep.Parent = TitleBar
    table.insert(window.themedObjects, {obj = sep, prop = "BackgroundColor3", key = "Stroke"})

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -85, 1, 0)
    TitleText.Position = UDim2.new(0, 14, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = theme.Accent
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 13
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    table.insert(window.themedObjects, {obj = TitleText, prop = "TextColor3", key = "Accent"})

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 26, 0, 26)
    MinBtn.Position = UDim2.new(1, -62, 0, 6)
    MinBtn.BackgroundColor3 = theme.Input
    MinBtn.Text = "–"
    MinBtn.TextColor3 = theme.SubText
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
    table.insert(window.themedObjects, {obj = MinBtn, prop = "BackgroundColor3", key = "Input"})
    table.insert(window.themedObjects, {obj = MinBtn, prop = "TextColor3", key = "SubText"})

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -32, 0, 6)
    CloseBtn.BackgroundColor3 = theme.Close
    CloseBtn.BackgroundTransparency = 0.4
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(220, 180, 180)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(1, -16, 0, 30)
    TabBar.Position = UDim2.new(0, 8, 0, 42)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.BorderSizePixel = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.Parent = Main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = TabBar

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    local tabSep = Instance.new("Frame")
    tabSep.Size = UDim2.new(1, 0, 0, 1)
    tabSep.Position = UDim2.new(0, 0, 0, 74)
    tabSep.BackgroundColor3 = theme.Stroke
    tabSep.BackgroundTransparency = 0.7
    tabSep.BorderSizePixel = 0
    tabSep.Parent = Main
    table.insert(window.themedObjects, {obj = tabSep, prop = "BackgroundColor3", key = "Stroke"})

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -16, 1, -82)
    ContentFrame.Position = UDim2.new(0, 8, 0, 78)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 2
    ContentFrame.ScrollBarImageColor3 = theme.ScrollBar
    ContentFrame.ScrollBarImageTransparency = 0.3
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = Main
    table.insert(window.themedObjects, {obj = ContentFrame, prop = "ScrollBarImageColor3", key = "ScrollBar"})

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 4)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = ContentFrame

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 8)
    end)

    window.TabBar = TabBar
    window.ContentFrame = ContentFrame

    local minimized = false
    local savedSize

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        ContentFrame.Visible = not minimized
        TabBar.Visible = not minimized
        tabSep.Visible = not minimized
        resizeHandle.Visible = not minimized
        if minimized then
            savedSize = Main.Size
            tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 38), 0.12)
        else
            tween(Main, "Size", savedSize or size, 0.12)
        end
        MinBtn.Text = minimized and "+" or "–"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 0), 0.12)
        task.wait(0.15)
        Gui:Destroy()
    end)

    if isMobile then
        local openBtn = Instance.new("TextButton")
        openBtn.Size = UDim2.new(0, 44, 0, 44)
        openBtn.Position = UDim2.new(0, 8, 0.5, -22)
        openBtn.BackgroundColor3 = theme.Primary
        openBtn.BackgroundTransparency = 0.2
        openBtn.Text = "W"
        openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 15
        openBtn.BorderSizePixel = 0
        openBtn.Parent = Gui
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
        table.insert(window.themedObjects, {obj = openBtn, prop = "BackgroundColor3", key = "Primary"})

        local mobDrag, mobStart, mobPos = false, nil, nil
        local moved = false

        openBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                mobDrag = true
                moved = false
                mobStart = input.Position
                mobPos = openBtn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        mobDrag = false
                        if not moved then
                            Main.Visible = not Main.Visible
                        end
                    end
                end)
            end
        end)

        openBtn.InputChanged:Connect(function(input)
            if mobDrag and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - mobStart
                if delta.Magnitude > 5 then moved = true end
                openBtn.Position = UDim2.new(mobPos.X.Scale, mobPos.X.Offset + delta.X, mobPos.Y.Scale, mobPos.Y.Offset + delta.Y)
            end
        end)

        openBtn.MouseButton1Click:Connect(function()
            if not moved then
                Main.Visible = not Main.Visible
            end
        end)
    else
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == minimizeKey then
                Main.Visible = not Main.Visible
            end
        end)
    end

    local currentTabName = nil

    local function switchTab(name)
        currentTabName = name
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then child.Visible = false end
        end
        for tabName, tabData in pairs(window.tabs) do
            if tabName == name then
                tabData.btn.BackgroundColor3 = window.theme.TabActive
                tabData.btn.TextColor3 = window.theme.TabTextActive
                for _, el in ipairs(tabData.elements) do el.Visible = true end
            else
                tabData.btn.BackgroundColor3 = window.theme.TabInactive
                tabData.btn.TextColor3 = window.theme.TabTextInactive
            end
        end
        ContentFrame.CanvasPosition = Vector2.new(0, 0)
    end

    function window:SetTheme(name)
        local newTheme = Themes[name]
        if not newTheme then return end
        self.theme = newTheme
        self.themeName = name
        for _, entry in ipairs(self.themedObjects) do
            if entry.obj and entry.obj.Parent then
                pcall(function() entry.obj[entry.prop] = newTheme[entry.key] end)
            end
        end
        if currentTabName then
            switchTab(currentTabName)
        end
    end

    function window:SaveConfig(name)
        name = name or "default"
        local data = {}
        for flag, val in pairs(self.flags) do
            if typeof(val) == "EnumItem" then
                data[flag] = {_type = "keycode", _val = val.Name}
            elseif typeof(val) == "table" then
                data[flag] = {_type = "table", _val = val}
            else
                data[flag] = val
            end
        end
        data["_theme"] = self.themeName
        pcall(function()
            if not isfolder(self.configFolder) then makefolder(self.configFolder) end
            writefile(self.configFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end)
    end

    function window:LoadConfig(name)
        name = name or "default"
        local ok, raw = pcall(function()
            return readfile(self.configFolder .. "/" .. name .. ".json")
        end)
        if not ok then return false end
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok2 then return false end
        if data["_theme"] then
            self:SetTheme(data["_theme"])
        end
        for flag, val in pairs(data) do
            if flag == "_theme" then continue end
            if typeof(val) == "table" and val._type == "keycode" then
                val = Enum.KeyCode[val._val]
            elseif typeof(val) == "table" and val._type == "table" then
                val = val._val
            end
            self.flags[flag] = val
            if self.flagSetters[flag] then
                pcall(function() self.flagSetters[flag](val) end)
            end
        end
        return true
    end

    function window:GetConfigs()
        local configs = {}
        pcall(function()
            if isfolder(self.configFolder) then
                for _, file in ipairs(listfiles(self.configFolder)) do
                    local name = file:match("([^/\\]+)%.json$")
                    if name then table.insert(configs, name) end
                end
            end
        end)
        return configs
    end

    function window:DeleteConfig(name)
        pcall(function()
            delfile(self.configFolder .. "/" .. name .. ".json")
        end)
    end

    function window:SetAutoStart(name)
        pcall(function()
            if not isfolder(self.configFolder) then makefolder(self.configFolder) end
            writefile(self.configFolder .. "/_autostart.txt", name)
        end)
    end

    function window:GetAutoStart()
        local ok, name = pcall(function()
            return readfile(self.configFolder .. "/_autostart.txt")
        end)
        if ok and name and name ~= "" then return name end
        return nil
    end

    function window:AutoLoad()
        local auto = self:GetAutoStart()
        if auto then
            return self:LoadConfig(auto)
        end
        return false
    end

    function window:AddTab(config)
        config = config or {}
        local name = config.Title or "Tab"
        local tab = {elements = {}, addOrder = 0}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, math.max(55, #name * 7 + 18), 0, 26)
        btn.BackgroundColor3 = window.theme.TabInactive
        btn.Text = name
        btn.TextColor3 = window.theme.TabTextInactive
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = TabBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        tab.btn = btn

        btn.MouseEnter:Connect(function()
            if currentTabName ~= name then
                tween(btn, "BackgroundColor3", window.theme.TabHover, 0.1)
                tween(btn, "TextColor3", window.theme.Text, 0.1)
            end
        end)

        btn.MouseLeave:Connect(function()
            if currentTabName ~= name then
                tween(btn, "BackgroundColor3", window.theme.TabInactive, 0.1)
                tween(btn, "TextColor3", window.theme.TabTextInactive, 0.1)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)

        window.tabs[name] = tab
        table.insert(window.tabOrder, name)

        local function makeRow(height)
            tab.addOrder = tab.addOrder + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, height or 36)
            row.BackgroundColor3 = window.theme.Secondary
            row.BorderSizePixel = 0
            row.LayoutOrder = tab.addOrder
            row.Visible = false
            row.Parent = ContentFrame
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            table.insert(tab.elements, row)
            table.insert(window.themedObjects, {obj = row, prop = "BackgroundColor3", key = "Secondary"})

            row.MouseEnter:Connect(function()
                tween(row, "BackgroundColor3", window.theme.RowHover, 0.08)
            end)
            row.MouseLeave:Connect(function()
                tween(row, "BackgroundColor3", window.theme.Secondary, 0.08)
            end)

            return row
        end

        local tabObj = {}

        function tabObj:AddToggle(config)
            config = config or {}
            local row = makeRow(34)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -56, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Title or "Toggle"
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 32, 0, 16)
            toggleBg.Position = UDim2.new(1, -42, 0.5, -8)
            toggleBg.BackgroundColor3 = (config.Default and window.theme.Primary) or window.theme.Toggle
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = row
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 12, 0, 12)
            circle.Position = config.Default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BorderSizePixel = 0
            circle.Parent = toggleBg
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            local state = config.Default or false
            local callback = config.Callback or function() end
            local flag = config.Flag

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = row

            local function set(v, skipCb)
                state = v
                tween(toggleBg, "BackgroundColor3", state and window.theme.Primary or window.theme.Toggle, 0.12)
                tween(circle, "Position", state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), 0.12)
                if flag then window.flags[flag] = state end
                if not skipCb then callback(state) end
            end

            clickBtn.MouseButton1Click:Connect(function() set(not state) end)
            if flag then
                window.flags[flag] = state
                window.flagSetters[flag] = function(v) set(v, false) end
            end

            local obj = {}
            function obj:Set(v) set(v) end
            function obj:Get() return state end
            return obj
        end

        function tabObj:AddDropdown(config)
            config = config or {}
            local label = config.Title or "Dropdown"
            local options = config.Options or {}
            local multi = config.MultiSelect or false
            local activateOnSelect = config.ActivateOnSelect or false
            local default = config.Default
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(34)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local selected
            if multi then
                selected = default or {}
            else
                selected = default or options[1] or ""
            end

            local function getDisplay()
                if multi then
                    if #selected == 0 then return "None" end
                    return table.concat(selected, ", ")
                end
                return tostring(selected)
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.5, -14, 0, 22)
            btn.Position = UDim2.new(0.5, 4, 0.5, -11)
            btn.BackgroundColor3 = window.theme.Input
            btn.Text = getDisplay()
            btn.TextColor3 = window.theme.Accent
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 10
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = btn, prop = "TextColor3", key = "Accent"})

            if flag then window.flags[flag] = selected end

            local dropOpen = false

            local function closeDropdown()
                if window._dropdownOverlay then
                    window._dropdownOverlay:Destroy()
                    window._dropdownOverlay = nil
                end
                dropOpen = false
            end

            local function openDropdown()
                closeDropdown()
                dropOpen = true

                local overlay = Instance.new("Frame")
                overlay.Size = UDim2.new(1, 0, 1, 0)
                overlay.BackgroundTransparency = 1
                overlay.ZIndex = 100
                overlay.Parent = Main
                window._dropdownOverlay = overlay

                local bg = Instance.new("TextButton")
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundTransparency = 0.7
                bg.BackgroundColor3 = Color3.new(0, 0, 0)
                bg.Text = ""
                bg.ZIndex = 100
                bg.Parent = overlay
                bg.MouseButton1Click:Connect(closeDropdown)

                local listH = math.min(#options * 28 + 4, 180)
                local absBtn = btn.AbsolutePosition
                local absMain = Main.AbsolutePosition

                local list = Instance.new("ScrollingFrame")
                list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, listH)
                list.Position = UDim2.new(0, absBtn.X - absMain.X, 0, absBtn.Y - absMain.Y + btn.AbsoluteSize.Y + 2)
                list.BackgroundColor3 = window.theme.TitleBar
                list.BorderSizePixel = 0
                list.ScrollBarThickness = 2
                list.ScrollBarImageColor3 = window.theme.ScrollBar
                list.CanvasSize = UDim2.new(0, 0, 0, #options * 28 + 4)
                list.ZIndex = 101
                list.Parent = overlay
                Instance.new("UICorner", list).CornerRadius = UDim.new(0, 5)
                local ls = Instance.new("UIStroke", list)
                ls.Color = window.theme.Stroke
                ls.Thickness = 1

                local ll = Instance.new("UIListLayout")
                ll.Padding = UDim.new(0, 2)
                ll.SortOrder = Enum.SortOrder.LayoutOrder
                ll.Parent = list
                Instance.new("UIPadding", list).PaddingTop = UDim.new(0, 2)

                for _, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, -4, 0, 26)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = ""
                    optBtn.AutoButtonColor = false
                    optBtn.ZIndex = 102
                    optBtn.Parent = list

                    local optLbl = Instance.new("TextLabel")
                    optLbl.Size = UDim2.new(1, -28, 1, 0)
                    optLbl.Position = UDim2.new(0, 8, 0, 0)
                    optLbl.BackgroundTransparency = 1
                    optLbl.Text = opt
                    optLbl.Font = Enum.Font.Gotham
                    optLbl.TextSize = 10
                    optLbl.TextXAlignment = Enum.TextXAlignment.Left
                    optLbl.ZIndex = 102
                    optLbl.Parent = optBtn

                    local isSelected = false
                    if multi then
                        isSelected = table.find(selected, opt) ~= nil
                    else
                        isSelected = selected == opt
                    end
                    optLbl.TextColor3 = isSelected and window.theme.Primary or window.theme.Text

                    if multi then
                        local check = Instance.new("TextLabel")
                        check.Size = UDim2.new(0, 16, 0, 16)
                        check.Position = UDim2.new(1, -22, 0.5, -8)
                        check.BackgroundTransparency = 1
                        check.Text = isSelected and "✓" or ""
                        check.TextColor3 = window.theme.Primary
                        check.Font = Enum.Font.GothamBold
                        check.TextSize = 12
                        check.ZIndex = 102
                        check.Parent = optBtn

                        optBtn.MouseButton1Click:Connect(function()
                            local idx = table.find(selected, opt)
                            if idx then
                                table.remove(selected, idx)
                                check.Text = ""
                                optLbl.TextColor3 = window.theme.Text
                            else
                                table.insert(selected, opt)
                                check.Text = "✓"
                                optLbl.TextColor3 = window.theme.Primary
                            end
                            btn.Text = getDisplay()
                            if flag then window.flags[flag] = selected end
                            callback(selected)
                        end)
                    else
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            btn.Text = getDisplay()
                            if flag then window.flags[flag] = selected end
                            if activateOnSelect then
                                callback(selected)
                            else
                                callback(selected)
                            end
                            closeDropdown()
                        end)
                    end

                    optBtn.MouseEnter:Connect(function()
                        tween(optBtn, "BackgroundTransparency", 0, 0.06)
                        optBtn.BackgroundColor3 = window.theme.RowHover
                    end)
                    optBtn.MouseLeave:Connect(function()
                        tween(optBtn, "BackgroundTransparency", 1, 0.06)
                    end)
                end
            end

            btn.MouseButton1Click:Connect(function()
                if dropOpen then
                    closeDropdown()
                else
                    openDropdown()
                end
            end)

            if flag then
                window.flagSetters[flag] = function(v)
                    selected = v
                    btn.Text = getDisplay()
                    callback(v)
                end
            end

            local obj = {}
            function obj:Set(val)
                selected = val
                btn.Text = getDisplay()
                if flag then window.flags[flag] = selected end
                callback(selected)
            end
            function obj:Get() return selected end
            function obj:Refresh(newOpts)
                options = newOpts
            end
            return obj
        end

        function tabObj:AddSlider(config)
            config = config or {}
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(44)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 0, 18)
            lbl.Position = UDim2.new(0, 10, 0, 2)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Title or "Slider"
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 40, 0, 18)
            valLabel.Position = UDim2.new(1, -50, 0, 2)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = window.theme.Accent
            valLabel.Font = Enum.Font.GothamMedium
            valLabel.TextSize = 11
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = row
            table.insert(window.themedObjects, {obj = valLabel, prop = "TextColor3", key = "Accent"})

            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -20, 0, 6)
            sliderBg.Position = UDim2.new(0, 10, 0, 30)
            sliderBg.BackgroundColor3 = window.theme.Toggle
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = row
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            table.insert(window.themedObjects, {obj = sliderBg, prop = "BackgroundColor3", key = "Toggle"})

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = window.theme.Primary
            fill.BorderSizePixel = 0
            fill.Parent = sliderBg
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            table.insert(window.themedObjects, {obj = fill, prop = "BackgroundColor3", key = "Primary"})

            local value = default
            if flag then window.flags[flag] = value end

            local sliding = false

            local function update(input)
                local pos = input.Position.X
                local absPos = sliderBg.AbsolutePosition.X
                local absSize = sliderBg.AbsoluteSize.X
                local pct = math.clamp((pos - absPos) / absSize, 0, 1)
                local raw = min + (max - min) * pct
                value = math.floor(raw / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(value)
                if flag then window.flags[flag] = value end
                callback(value)
            end

            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            if flag then
                window.flagSetters[flag] = function(v)
                    value = math.clamp(v, min, max)
                    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    valLabel.Text = tostring(value)
                    callback(value)
                end
            end

            local obj = {}
            function obj:Set(v)
                value = math.clamp(v, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(value)
                if flag then window.flags[flag] = value end
                callback(value)
            end
            function obj:Get() return value end
            return obj
        end

        function tabObj:AddButton(config)
            config = config or {}
            local callback = config.Callback or function() end

            local row = makeRow(32)
            row.BackgroundTransparency = 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = window.theme.Primary
            btn.BackgroundTransparency = 0.15
            btn.Text = config.Title or "Button"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 11
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Primary"})

            btn.MouseEnter:Connect(function()
                tween(btn, "BackgroundTransparency", 0, 0.1)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, "BackgroundTransparency", 0.15, 0.1)
            end)

            btn.MouseButton1Click:Connect(function()
                tween(btn, "BackgroundTransparency", 0.5, 0.06)
                task.wait(0.06)
                tween(btn, "BackgroundTransparency", 0.15, 0.1)
                callback()
            end)
        end

        function tabObj:AddInput(config)
            config = config or {}
            local flag = config.Flag
            local callback = config.Callback or function() end
            local default = config.Default or ""

            local row = makeRow(34)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Title or "Input"
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.55, -10, 0, 22)
            box.Position = UDim2.new(0.45, 0, 0.5, -11)
            box.BackgroundColor3 = window.theme.Input
            box.Text = default
            box.PlaceholderText = config.Placeholder or "..."
            box.PlaceholderColor3 = window.theme.SubText
            box.TextColor3 = window.theme.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 10
            box.ClearTextOnFocus = false
            box.BorderSizePixel = 0
            box.Parent = row
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
            Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = box, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = box, prop = "TextColor3", key = "Text"})

            if flag then window.flags[flag] = default end

            box.FocusLost:Connect(function()
                if flag then window.flags[flag] = box.Text end
                callback(box.Text)
            end)

            if flag then
                window.flagSetters[flag] = function(v)
                    box.Text = tostring(v)
                    callback(v)
                end
            end

            local obj = {}
            function obj:Set(v) box.Text = tostring(v); if flag then window.flags[flag] = v end; callback(v) end
            function obj:Get() return box.Text end
            return obj
        end

        function tabObj:AddParagraph(config)
            config = config or {}
            local titleText = config.Title or ""
            local contentText = config.Content or ""
            local lines = math.ceil(#contentText / 50)
            local height = (titleText ~= "" and 18 or 0) + math.max(20, lines * 14) + 8
            local row = makeRow(height)

            local ttl
            if titleText ~= "" then
                ttl = Instance.new("TextLabel")
                ttl.Size = UDim2.new(1, -16, 0, 16)
                ttl.Position = UDim2.new(0, 8, 0, 3)
                ttl.BackgroundTransparency = 1
                ttl.Text = titleText
                ttl.TextColor3 = window.theme.Accent
                ttl.Font = Enum.Font.GothamMedium
                ttl.TextSize = 11
                ttl.TextXAlignment = Enum.TextXAlignment.Left
                ttl.Parent = row
                table.insert(window.themedObjects, {obj = ttl, prop = "TextColor3", key = "Accent"})
            end

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -16, 1, titleText ~= "" and -20 or -6)
            desc.Position = UDim2.new(0, 8, 0, titleText ~= "" and 19 or 3)
            desc.BackgroundTransparency = 1
            desc.Text = contentText
            desc.TextColor3 = window.theme.SubText
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 10
            desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.Parent = row
            table.insert(window.themedObjects, {obj = desc, prop = "TextColor3", key = "SubText"})

            local obj = {}
            function obj:SetTitle(t)
                if ttl then ttl.Text = t end
            end
            function obj:SetDesc(t)
                desc.Text = t
                local newLines = math.ceil(#t / 50)
                local newH = (titleText ~= "" and 18 or 0) + math.max(20, newLines * 14) + 8
                row.Size = UDim2.new(1, 0, 0, newH)
            end
            return obj
        end

        function tabObj:AddKeybind(config)
            config = config or {}
            local flag = config.Flag
            local callback = config.Callback or function() end
            local currentKey = config.Default or Enum.KeyCode.Unknown

            local row = makeRow(34)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -90, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Title or "Keybind"
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 22)
            btn.Position = UDim2.new(1, -80, 0.5, -11)
            btn.BackgroundColor3 = window.theme.Input
            btn.Text = currentKey.Name or "None"
            btn.TextColor3 = window.theme.Accent
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 10
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = btn, prop = "TextColor3", key = "Accent"})

            local listening = false
            if flag then window.flags[flag] = currentKey end

            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
                tween(btn, "BackgroundColor3", window.theme.Primary, 0.1)
            end)

            UIS.InputBegan:Connect(function(input, gpe)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        btn.Text = currentKey.Name
                        if flag then window.flags[flag] = currentKey end
                        listening = false
                        tween(btn, "BackgroundColor3", window.theme.Input, 0.1)
                    end
                    return
                end
                if not gpe and input.KeyCode == currentKey then
                    callback(currentKey)
                end
            end)

            if flag then
                window.flagSetters[flag] = function(v)
                    if typeof(v) == "EnumItem" then
                        currentKey = v
                        btn.Text = v.Name
                    end
                end
            end

            local obj = {}
            function obj:Set(key) currentKey = key; btn.Text = key.Name; if flag then window.flags[flag] = key end end
            function obj:Get() return currentKey end
            return obj
        end

        return tabObj
    end

    function window:AddConfigTab(config)
        config = config or {}
        local tabObj = self:AddTab({ Title = config.Title or "Settings" })

        tabObj:AddParagraph({ Title = "Configuration", Content = "Save and load your settings." })

        local configInput
        local configDropdown
        local autoStartDropdown

        configInput = tabObj:AddInput({
            Title = "Config Name",
            Placeholder = "my_config",
            Default = "default",
            Flag = "_configName"
        })

        tabObj:AddButton({
            Title = "Save Config",
            Callback = function()
                local name = self.flags["_configName"] or "default"
                if name == "" then name = "default" end
                self:SaveConfig(name)
            end
        })

        local configs = self:GetConfigs()
        if #configs == 0 then configs = {"default"} end

        configDropdown = tabObj:AddDropdown({
            Title = "Load Config",
            Options = configs,
            Default = configs[1],
            Flag = "_configSelect",
            ActivateOnSelect = true,
            Callback = function(v)
                self:LoadConfig(v)
                local refreshed = self:GetConfigs()
                if #refreshed == 0 then refreshed = {"default"} end
                configDropdown:Refresh(refreshed)
            end
        })

        autoStartDropdown = tabObj:AddDropdown({
            Title = "Auto Load Config",
            Options = configs,
            Default = self:GetAutoStart() or configs[1],
            Flag = "_autoStart",
            Callback = function(v)
                self:SetAutoStart(v)
            end
        })

        tabObj:AddButton({
            Title = "Delete Selected Config",
            Callback = function()
                local name = self.flags["_configSelect"] or "default"
                self:DeleteConfig(name)
            end
        })

        tabObj:AddButton({
            Title = "Refresh Config List",
            Callback = function()
                local refreshed = self:GetConfigs()
                if #refreshed == 0 then refreshed = {"default"} end
                configDropdown:Refresh(refreshed)
                autoStartDropdown:Refresh(refreshed)
            end
        })

        tabObj:AddParagraph({ Title = "Theme", Content = "Change the visual appearance." })

        tabObj:AddDropdown({
            Title = "Theme",
            Options = {"Amethyst", "Midnight", "Rose", "Emerald", "Sunset", "Dark"},
            Default = self.themeName,
            Callback = function(v) self:SetTheme(v) end
        })

        return tabObj
    end

    function window:SelectTab(idx)
        if type(idx) == "number" then
            local name = window.tabOrder[idx]
            if name then switchTab(name) end
        elseif type(idx) == "string" then
            if window.tabs[idx] then switchTab(idx) end
        end
    end

    function window:Destroy()
        Gui:Destroy()
    end

    return window
end

WimplyUI.Themes = Themes

return WimplyUI
