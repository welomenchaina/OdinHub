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
        Primary = Color3.fromRGB(147, 2, 225),
        Background = Color3.fromRGB(18, 15, 25),
        Secondary = Color3.fromRGB(28, 24, 38),
        TitleBar = Color3.fromRGB(25, 20, 35),
        Text = Color3.fromRGB(220, 220, 220),
        SubText = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(180, 140, 255),
        Toggle = Color3.fromRGB(50, 45, 65),
        Input = Color3.fromRGB(35, 30, 50),
        Stroke = Color3.fromRGB(147, 2, 225),
        Close = Color3.fromRGB(180, 40, 40),
        ScrollBar = Color3.fromRGB(147, 2, 225)
    },
    Midnight = {
        Primary = Color3.fromRGB(0, 120, 255),
        Background = Color3.fromRGB(12, 12, 20),
        Secondary = Color3.fromRGB(22, 22, 35),
        TitleBar = Color3.fromRGB(18, 18, 28),
        Text = Color3.fromRGB(220, 220, 230),
        SubText = Color3.fromRGB(140, 140, 160),
        Accent = Color3.fromRGB(100, 160, 255),
        Toggle = Color3.fromRGB(40, 40, 60),
        Input = Color3.fromRGB(30, 30, 45),
        Stroke = Color3.fromRGB(0, 120, 255),
        Close = Color3.fromRGB(200, 50, 50),
        ScrollBar = Color3.fromRGB(0, 120, 255)
    },
    Rose = {
        Primary = Color3.fromRGB(220, 50, 100),
        Background = Color3.fromRGB(22, 14, 18),
        Secondary = Color3.fromRGB(35, 24, 28),
        TitleBar = Color3.fromRGB(30, 18, 24),
        Text = Color3.fromRGB(230, 220, 225),
        SubText = Color3.fromRGB(160, 140, 150),
        Accent = Color3.fromRGB(255, 140, 180),
        Toggle = Color3.fromRGB(55, 40, 48),
        Input = Color3.fromRGB(42, 30, 36),
        Stroke = Color3.fromRGB(220, 50, 100),
        Close = Color3.fromRGB(200, 50, 50),
        ScrollBar = Color3.fromRGB(220, 50, 100)
    },
    Emerald = {
        Primary = Color3.fromRGB(0, 200, 120),
        Background = Color3.fromRGB(12, 20, 16),
        Secondary = Color3.fromRGB(20, 32, 26),
        TitleBar = Color3.fromRGB(16, 26, 20),
        Text = Color3.fromRGB(220, 235, 225),
        SubText = Color3.fromRGB(140, 165, 150),
        Accent = Color3.fromRGB(100, 255, 180),
        Toggle = Color3.fromRGB(35, 55, 45),
        Input = Color3.fromRGB(28, 42, 34),
        Stroke = Color3.fromRGB(0, 200, 120),
        Close = Color3.fromRGB(200, 50, 50),
        ScrollBar = Color3.fromRGB(0, 200, 120)
    },
    Sunset = {
        Primary = Color3.fromRGB(255, 120, 30),
        Background = Color3.fromRGB(22, 16, 12),
        Secondary = Color3.fromRGB(36, 26, 20),
        TitleBar = Color3.fromRGB(28, 20, 14),
        Text = Color3.fromRGB(240, 225, 215),
        SubText = Color3.fromRGB(170, 150, 135),
        Accent = Color3.fromRGB(255, 180, 100),
        Toggle = Color3.fromRGB(60, 45, 35),
        Input = Color3.fromRGB(45, 34, 26),
        Stroke = Color3.fromRGB(255, 120, 30),
        Close = Color3.fromRGB(200, 50, 50),
        ScrollBar = Color3.fromRGB(255, 120, 30)
    },
    Dark = {
        Primary = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(25, 25, 25),
        TitleBar = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(230, 230, 230),
        SubText = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(200, 200, 200),
        Toggle = Color3.fromRGB(45, 45, 45),
        Input = Color3.fromRGB(35, 35, 35),
        Stroke = Color3.fromRGB(80, 80, 80),
        Close = Color3.fromRGB(200, 50, 50),
        ScrollBar = Color3.fromRGB(100, 100, 100)
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
        local steps = math.floor(dur * 60)
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
    local configFile = config.ConfigFile or "default"
    local acrylic = config.Acrylic ~= false

    local theme = Themes[themeName] or Themes.Amethyst
    local window = {theme = theme, tabs = {}, flags = {}, configFolder = configFolder, configFile = configFile, themedObjects = {}}

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
    Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = theme.Stroke
    mainStroke.Thickness = 2
    window.Main = Main
    table.insert(window.themedObjects, {obj = Main, prop = "BackgroundColor3", key = "Background"})
    table.insert(window.themedObjects, {obj = mainStroke, prop = "Color", key = "Stroke"})

    -- Dragging
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
            elseif my < 40 then
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

    -- Resize handle
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 14, 0, 14)
    resizeHandle.Position = UDim2.new(1, -16, 1, -16)
    resizeHandle.BackgroundColor3 = theme.Primary
    resizeHandle.BackgroundTransparency = 0.5
    resizeHandle.BorderSizePixel = 0
    resizeHandle.Parent = Main
    Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 3)
    table.insert(window.themedObjects, {obj = resizeHandle, prop = "BackgroundColor3", key = "Primary"})

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)
    table.insert(window.themedObjects, {obj = TitleBar, prop = "BackgroundColor3", key = "TitleBar"})

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -90, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = theme.Accent
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    table.insert(window.themedObjects, {obj = TitleText, prop = "TextColor3", key = "Accent"})

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.BackgroundColor3 = theme.Input
    MinBtn.Text = "—"
    MinBtn.TextColor3 = theme.SubText
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
    table.insert(window.themedObjects, {obj = MinBtn, prop = "BackgroundColor3", key = "Input"})

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = theme.Close
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    -- Tab bar
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(1, -20, 0, 32)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.BorderSizePixel = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.Parent = Main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = TabBar

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    -- Content
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -90)
    ContentFrame.Position = UDim2.new(0, 10, 0, 82)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.ScrollBarImageColor3 = theme.ScrollBar
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = Main
    table.insert(window.themedObjects, {obj = ContentFrame, prop = "ScrollBarImageColor3", key = "ScrollBar"})

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = ContentFrame

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)

    window.TabBar = TabBar
    window.ContentFrame = ContentFrame

    -- Minimize
    local minimized = false
    local savedSize

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        ContentFrame.Visible = not minimized
        TabBar.Visible = not minimized
        resizeHandle.Visible = not minimized
        if minimized then
            savedSize = Main.Size
            tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 40), 0.15)
        else
            tween(Main, "Size", savedSize or size, 0.15)
        end
        MinBtn.Text = minimized and "+" or "—"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, "Size", UDim2.new(0, Main.Size.X.Offset, 0, 0), 0.15)
        task.wait(0.2)
        Gui:Destroy()
    end)

    -- Mobile toggle
    if isMobile then
        local openBtn = Instance.new("TextButton")
        openBtn.Size = UDim2.new(0, 50, 0, 50)
        openBtn.Position = UDim2.new(0, 10, 0.5, -25)
        openBtn.BackgroundColor3 = theme.Primary
        openBtn.BackgroundTransparency = 0.3
        openBtn.Text = "W"
        openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 16
        openBtn.BorderSizePixel = 0
        openBtn.Parent = Gui
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
        table.insert(window.themedObjects, {obj = openBtn, prop = "BackgroundColor3", key = "Primary"})

        openBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)
    else
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == minimizeKey then
                Main.Visible = not Main.Visible
            end
        end)
    end

    -- Theme switching
    function window:SetTheme(name)
        local newTheme = Themes[name]
        if not newTheme then return end
        self.theme = newTheme
        for _, entry in ipairs(self.themedObjects) do
            if entry.obj and entry.obj.Parent then
                pcall(function()
                    entry.obj[entry.prop] = newTheme[entry.key]
                end)
            end
        end
    end

    -- Tab switching
    local function switchTab(name)
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then child.Visible = false end
        end
        for tabName, tabData in pairs(window.tabs) do
            if tabName == name then
                tabData.btn.BackgroundColor3 = window.theme.Primary
                tabData.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                for _, el in ipairs(tabData.elements) do el.Visible = true end
            else
                tabData.btn.BackgroundColor3 = window.theme.Input
                tabData.btn.TextColor3 = window.theme.SubText
            end
        end
    end

    -- Config
    function window:SaveConfig()
        local data = {}
        for flag, val in pairs(self.flags) do
            data[flag] = val
        end
        pcall(function()
            if not isfolder(self.configFolder) then makefolder(self.configFolder) end
            writefile(self.configFolder .. "/" .. self.configFile .. ".json", HttpService:JSONEncode(data))
        end)
    end

    function window:LoadConfig()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.configFolder .. "/" .. self.configFile .. ".json"))
        end)
        if ok and data then
            return data
        end
        return nil
    end

    -- AddTab
    function window:AddTab(config)
        config = config or {}
        local name = config.Title or "Tab"
        local tab = {elements = {}, addOrder = 0}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, math.max(60, #name * 8 + 20), 0, 28)
        btn.BackgroundColor3 = window.theme.Input
        btn.Text = name
        btn.TextColor3 = window.theme.SubText
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.Parent = TabBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        tab.btn = btn

        table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Input"})

        btn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)

        window.tabs[name] = tab

        local function makeRow(height)
            tab.addOrder = tab.addOrder + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, height or 40)
            row.BackgroundColor3 = window.theme.Secondary
            row.BorderSizePixel = 0
            row.LayoutOrder = tab.addOrder
            row.Visible = false
            row.Parent = ContentFrame
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            table.insert(tab.elements, row)
            table.insert(window.themedObjects, {obj = row, prop = "BackgroundColor3", key = "Secondary"})
            return row
        end

        local tabObj = {}

        function tabObj:AddToggle(config)
            config = config or {}
            local label = config.Title or "Toggle"
            local default = config.Default or false
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(36)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 36, 0, 18)
            toggleBg.Position = UDim2.new(1, -48, 0.5, -9)
            toggleBg.BackgroundColor3 = default and window.theme.Primary or window.theme.Toggle
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = row
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BorderSizePixel = 0
            circle.Parent = toggleBg
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            local state = default

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = row

            local function set(v)
                state = v
                tween(toggleBg, "BackgroundColor3", state and window.theme.Primary or window.theme.Toggle, 0.15)
                tween(circle, "Position", state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), 0.15)
                if flag then window.flags[flag] = state end
                callback(state)
            end

            clickBtn.MouseButton1Click:Connect(function()
                set(not state)
            end)

            if flag then window.flags[flag] = state end

            local toggle = {}
            function toggle:Set(v) set(v) end
            function toggle:Get() return state end
            return toggle
        end

        function tabObj:AddDropdown(config)
            config = config or {}
            local label = config.Title or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1] or ""
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(36)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local idx = 1
            for i, v in ipairs(options) do
                if v == default then idx = i end
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 110, 0, 24)
            btn.Position = UDim2.new(1, -122, 0.5, -12)
            btn.BackgroundColor3 = window.theme.Input
            btn.Text = options[idx] or ""
            btn.TextColor3 = window.theme.Accent
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.BorderSizePixel = 0
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = btn, prop = "TextColor3", key = "Accent"})

            local current = options[idx] or ""
            if flag then window.flags[flag] = current end

            btn.MouseButton1Click:Connect(function()
                idx = idx % #options + 1
                current = options[idx]
                btn.Text = current
                if flag then window.flags[flag] = current end
                callback(current)
            end)

            local dropdown = {}
            function dropdown:Set(val)
                for i, v in ipairs(options) do
                    if v == val then idx = i; current = val; btn.Text = val; break end
                end
                if flag then window.flags[flag] = current end
                callback(current)
            end
            function dropdown:Get() return current end
            return dropdown
        end

        function tabObj:AddSlider(config)
            config = config or {}
            local label = config.Title or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(50)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -60, 0, 20)
            lbl.Position = UDim2.new(0, 12, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 50, 0, 20)
            valLabel.Position = UDim2.new(1, -60, 0, 4)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = window.theme.Accent
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 11
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = row
            table.insert(window.themedObjects, {obj = valLabel, prop = "TextColor3", key = "Accent"})

            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -24, 0, 8)
            sliderBg.Position = UDim2.new(0, 12, 0, 32)
            sliderBg.BackgroundColor3 = window.theme.Toggle
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = row
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            table.insert(window.themedObjects, {obj = sliderBg, prop = "BackgroundColor3", key = "Toggle"})

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
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

            local slider = {}
            function slider:Set(v)
                value = math.clamp(v, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(value)
                if flag then window.flags[flag] = value end
                callback(value)
            end
            function slider:Get() return value end
            return slider
        end

        function tabObj:AddButton(config)
            config = config or {}
            local label = config.Title or "Button"
            local callback = config.Callback or function() end

            local row = makeRow(36)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -16, 1, -8)
            btn.Position = UDim2.new(0, 8, 0, 4)
            btn.BackgroundColor3 = window.theme.Primary
            btn.Text = label
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.BorderSizePixel = 0
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Primary"})

            btn.MouseButton1Click:Connect(function()
                tween(btn, "BackgroundColor3", Color3.fromRGB(255, 255, 255), 0.1)
                task.wait(0.1)
                tween(btn, "BackgroundColor3", window.theme.Primary, 0.1)
                callback()
            end)
        end

        function tabObj:AddInput(config)
            config = config or {}
            local label = config.Title or "Input"
            local placeholder = config.Placeholder or "Type here..."
            local default = config.Default or ""
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(36)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.55, -12, 0, 24)
            box.Position = UDim2.new(0.45, 0, 0.5, -12)
            box.BackgroundColor3 = window.theme.Input
            box.Text = default
            box.PlaceholderText = placeholder
            box.PlaceholderColor3 = window.theme.SubText
            box.TextColor3 = window.theme.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 11
            box.ClearTextOnFocus = false
            box.BorderSizePixel = 0
            box.Parent = row
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 8)
            table.insert(window.themedObjects, {obj = box, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = box, prop = "TextColor3", key = "Text"})

            if flag then window.flags[flag] = default end

            box.FocusLost:Connect(function()
                if flag then window.flags[flag] = box.Text end
                callback(box.Text)
            end)

            local input = {}
            function input:Set(v) box.Text = v; if flag then window.flags[flag] = v end; callback(v) end
            function input:Get() return box.Text end
            return input
        end

        function tabObj:AddParagraph(config)
            config = config or {}
            local title = config.Title or ""
            local content = config.Content or ""

            local textLen = #content
            local height = math.max(45, 20 + math.ceil(textLen / 45) * 16)
            local row = makeRow(height)

            if title ~= "" then
                local ttl = Instance.new("TextLabel")
                ttl.Size = UDim2.new(1, -20, 0, 18)
                ttl.Position = UDim2.new(0, 10, 0, 4)
                ttl.BackgroundTransparency = 1
                ttl.Text = title
                ttl.TextColor3 = window.theme.Accent
                ttl.Font = Enum.Font.GothamBold
                ttl.TextSize = 12
                ttl.TextXAlignment = Enum.TextXAlignment.Left
                ttl.Parent = row
                table.insert(window.themedObjects, {obj = ttl, prop = "TextColor3", key = "Accent"})
            end

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -20, 1, title ~= "" and -24 or -8)
            desc.Position = UDim2.new(0, 10, 0, title ~= "" and 22 or 4)
            desc.BackgroundTransparency = 1
            desc.Text = content
            desc.TextColor3 = window.theme.SubText
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 11
            desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.Parent = row
            table.insert(window.themedObjects, {obj = desc, prop = "TextColor3", key = "SubText"})

            local para = {}
            function para:SetTitle(t) if row:FindFirstChild("TextLabel") then end end
            function para:SetDesc(t)
                desc.Text = t
                local newH = math.max(45, 20 + math.ceil(#t / 45) * 16)
                row.Size = UDim2.new(1, 0, 0, newH)
            end
            return para
        end

        function tabObj:AddKeybind(config)
            config = config or {}
            local label = config.Title or "Keybind"
            local default = config.Default or Enum.KeyCode.Unknown
            local flag = config.Flag
            local callback = config.Callback or function() end

            local row = makeRow(36)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -100, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = window.theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            table.insert(window.themedObjects, {obj = lbl, prop = "TextColor3", key = "Text"})

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 0, 24)
            btn.Position = UDim2.new(1, -92, 0.5, -12)
            btn.BackgroundColor3 = window.theme.Input
            btn.Text = default.Name or "None"
            btn.TextColor3 = window.theme.Accent
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.BorderSizePixel = 0
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            table.insert(window.themedObjects, {obj = btn, prop = "BackgroundColor3", key = "Input"})
            table.insert(window.themedObjects, {obj = btn, prop = "TextColor3", key = "Accent"})

            local currentKey = default
            local listening = false
            if flag then window.flags[flag] = currentKey end

            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input, gpe)
                if not listening then
                    if input.KeyCode == currentKey then
                        callback(currentKey)
                    end
                    return
                end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    btn.Text = currentKey.Name
                    if flag then window.flags[flag] = currentKey end
                    listening = false
                end
            end)

            local keybind = {}
            function keybind:Set(key) currentKey = key; btn.Text = key.Name; if flag then window.flags[flag] = key end end
            function keybind:Get() return currentKey end
            return keybind
        end

        return tabObj
    end

    function window:SelectTab(idx)
        local i = 0
        for name, _ in pairs(self.tabs) do
            i = i + 1
            if i == idx then
                switchTab(name)
                return
            end
        end
    end

    function window:Destroy()
        Gui:Destroy()
    end

    return window
end

WimplyUI.Themes = Themes

return WimplyUI
