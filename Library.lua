local OdinLib = {}
OdinLib.__index = OdinLib

local DefaultTheme = {
	Background = Color3.fromRGB(18, 18, 22),
	Sidebar = Color3.fromRGB(13, 13, 16),
	Content = Color3.fromRGB(22, 22, 26),
	ElementBackground = Color3.fromRGB(28, 28, 34),
	Primary = Color3.fromRGB(180, 150, 90),
	Secondary = Color3.fromRGB(60, 110, 160),
	TextPrimary = Color3.fromRGB(230, 230, 235),
	TextSecondary = Color3.fromRGB(150, 150, 160),
	TextDisabled = Color3.fromRGB(90, 90, 100),
	Border = Color3.fromRGB(35, 35, 42),
	Hover = Color3.fromRGB(32, 32, 38),
	Active = Color3.fromRGB(38, 38, 48),
	Success = Color3.fromRGB(80, 180, 100),
	Warning = Color3.fromRGB(230, 170, 80),
	Error = Color3.fromRGB(230, 80, 80),
}

local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then obj[k] = v end
	end
	if props.Parent then obj.Parent = props.Parent end
	return obj
end

function OdinLib.new(config)
	local self = setmetatable({}, OdinLib)
	self.Title = config.Title or "Name Not Chosen"
	self.Theme = config.Theme or DefaultTheme
	self.Size = config.Size or UDim2.new(0, 750, 0, 550)
	self.Keybind = config.Keybind or Enum.KeyCode.RightControl
	self.Tabs = {}
	self.CurrentTab = nil
	self.Visible = true
	self.SettingsOpen = false
	self:CreateGui()
	self:SetupKeybind()
	self:SetupMobile()
	return self
end


function OdinLib:CreateGui()
	self.ScreenGui = Create("ScreenGui", {Name = "OdinLibrary", ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, Parent = game:GetService("CoreGui")})
	self.MainFrame = Create("Frame", {Name = "MainFrame", Size = self.Size, Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = self.Theme.Background, BorderSizePixel = 0, Parent = self.ScreenGui})
	Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = self.MainFrame})
	self:CreateTopBar()
	self:CreateSidebar()
	self:CreateContentArea()
	self:CreateConsole()
	self:CreateUserPanel()
	self:MakeDraggable()
end

function OdinLib:CreateTopBar()
	self.TopBar = Create("Frame", {Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = self.TopBar})
	Create("Frame", {Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 1, -6), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.TopBar})
	self.TitleLabel = Create("TextLabel", {Name = "Title", Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = self.Title, TextColor3 = self.Theme.TextPrimary, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TopBar})
	local closeBtn = Create("TextButton", {Name = "CloseButton", Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -33, 0, 3.5), BackgroundColor3 = self.Theme.Content, Text = "X", TextColor3 = self.Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamBold, Parent = self.TopBar})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = closeBtn})
	closeBtn.MouseButton1Click:Connect(function() self:ToggleVisibility() end)
end

function OdinLib:CreateSidebar()
	self.Sidebar = Create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 200, 1, -135), Position = UDim2.new(0, 0, 0, 35), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	local searchFrame = Create("Frame", {Name = "SearchFrame", Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = self.Sidebar})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = searchFrame})
	self.SearchBox = Create("TextBox", {Name = "SearchBox", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 28, 0, 0), BackgroundTransparency = 1, PlaceholderText = "Search tabs", PlaceholderColor3 = self.Theme.TextDisabled, Text = "", TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = searchFrame})
	Create("ImageLabel", {Name = "SearchIcon", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 8, 0.5, -7), BackgroundTransparency = 1, Image = "rbxassetid://7072721559", ImageColor3 = self.Theme.TextSecondary, Parent = searchFrame})
	self.TabContainer = Create("ScrollingFrame", {Name = "TabContainer", Size = UDim2.new(1, -10, 1, -52), Position = UDim2.new(0, 5, 0, 47), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.Sidebar})
	local tabLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = self.TabContainer})
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8) end)
	self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local searchText = self.SearchBox.Text:lower()
		for _, tab in pairs(self.Tabs) do tab.Button.Visible = searchText == "" or tab.Name:lower():find(searchText) end
	end)
end

function OdinLib:CreateUserPanel()
	local userPanel = Create("Frame", {Name = "UserPanel", Size = UDim2.new(0, 200, 0, 95), Position = UDim2.new(0, 0, 1, -95), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	local settingsContainer = Create("Frame", {Name = "SettingsContainer", Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, ClipsDescendants = true, Parent = userPanel})
	local settingsBtn = Create("TextButton", {Name = "SettingsButton", Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Text = "", Parent = settingsContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = settingsBtn})
	Create("ImageLabel", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 8, 0.5, -8), BackgroundTransparency = 1, Image = "rbxassetid://7072717697", ImageColor3 = self.Theme.TextSecondary, Parent = settingsBtn})
	Create("TextLabel", {Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 28, 0, 0), BackgroundTransparency = 1, Text = "Settings", TextColor3 = self.Theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = settingsBtn})
	local arrow = Create("ImageLabel", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -18, 0.5, -5), BackgroundTransparency = 1, Image = "rbxassetid://7072706796", ImageColor3 = self.Theme.TextSecondary, Rotation = 0, Parent = settingsBtn})
	local keybindFrame = Create("Frame", {Name = "KeybindFrame", Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 32), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = settingsContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keybindFrame})
	Create("TextLabel", {Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = "Toggle Key", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = keybindFrame})
	self.KeybindButton = Create("TextButton", {Size = UDim2.new(0.5, -8, 0, 24), Position = UDim2.new(0.5, 4, 0.5, -12), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = self.Keybind.Name, TextColor3 = self.Theme.Primary, TextSize = 10, Font = Enum.Font.GothamBold, Parent = keybindFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = self.KeybindButton})
	self.KeybindButton.MouseButton1Click:Connect(function()
		self.KeybindButton.Text = "..."
		local conn; conn = game:GetService("UserInputService").InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				self.Keybind = input.KeyCode
				self.KeybindButton.Text = input.KeyCode.Name
				conn:Disconnect()
			end
		end)
	end)
	settingsBtn.MouseButton1Click:Connect(function()
		self.SettingsOpen = not self.SettingsOpen
		game:GetService("TweenService"):Create(settingsContainer, TweenInfo.new(0.2), {Size = self.SettingsOpen and UDim2.new(1, -20, 0, 64) or UDim2.new(1, -20, 0, 28)}):Play()
		game:GetService("TweenService"):Create(arrow, TweenInfo.new(0.2), {Rotation = self.SettingsOpen and 180 or 0}):Play()
	end)
	local userInfo = Create("Frame", {Name = "UserInfo", Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = userPanel})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = userInfo})
	local avatar = Create("ImageLabel", {Name = "Avatar", Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 7, 0.5, -18), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Image = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=150&h=150", Parent = userInfo})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = avatar})
	Create("TextLabel", {Size = UDim2.new(1, -50, 0, 14), Position = UDim2.new(0, 48, 0, 8), BackgroundTransparency = 1, Text = "Welcome,", TextColor3 = self.Theme.TextDisabled, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = userInfo})
	Create("TextLabel", {Size = UDim2.new(1, -50, 0, 18), Position = UDim2.new(0, 48, 0, 22), BackgroundTransparency = 1, Text = game.Players.LocalPlayer.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = userInfo})
	self.UserPanel = userPanel
end

function OdinLib:ToggleVisibility()
	self.Visible = not self.Visible
	self.MainFrame.Visible = self.Visible
end

function OdinLib:CreateContentArea()
	self.ContentArea = Create("Frame", {Name = "ContentArea", Size = UDim2.new(1, -210, 1, -140), Position = UDim2.new(0, 205, 0, 40), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = self.MainFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = self.ContentArea})
	self.ContentScroll = Create("ScrollingFrame", {Name = "ContentScroll", Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.ContentArea})
	local contentLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = self.ContentScroll})
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 8) end)
end

function OdinLib:CreateConsole()
	self.Console = Create("Frame", {Name = "Console", Size = UDim2.new(1, -210, 0, 90), Position = UDim2.new(0, 205, 1, -95), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = self.Console})
	self.ConsoleScroll = Create("ScrollingFrame", {Name = "ConsoleScroll", Size = UDim2.new(1, -16, 1, -8), Position = UDim2.new(0, 8, 0, 4), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.Console})
	local consoleLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = self.ConsoleScroll})
	consoleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.ConsoleScroll.CanvasSize = UDim2.new(0, 0, 0, consoleLayout.AbsoluteContentSize.Y)
		self.ConsoleScroll.CanvasPosition = Vector2.new(0, consoleLayout.AbsoluteContentSize.Y)
	end)
end

function OdinLib:MakeDraggable()
	local dragging, dragInput, mousePos, framePos
	self.TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = self.MainFrame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	self.TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			self.MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end

function OdinLib:SetupKeybind()
	game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == self.Keybind then self:ToggleVisibility() end
	end)
end

function OdinLib:SetupMobile()
	if game:GetService("UserInputService").TouchEnabled then
		local toggleBtn = Create("TextButton", {Name = "MobileToggle", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0, 100), BackgroundColor3 = self.Theme.Primary, Text = "☰", TextColor3 = self.Theme.Background, TextSize = 24, Font = Enum.Font.GothamBold, Parent = self.ScreenGui})
		Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = toggleBtn})
		toggleBtn.MouseButton1Click:Connect(function() self:ToggleVisibility() end)
		local dragging, dragInput, startPos
		toggleBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				startPos = input.Position
				input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
			end
		end)
		toggleBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				toggleBtn.Position = UDim2.new(0, input.Position.X - 25, 0, input.Position.Y - 25)
			end
		end)
	end
end

function OdinLib:AddTab(config)
	local tab = {Name = config.Name or "Tab", Icon = config.Icon or "rbxassetid://7072707375", Elements = {}}
	tab.Button = Create("TextButton", {Name = config.Name, Size = UDim2.new(1, -10, 0, 38), BackgroundColor3 = self.Theme.Content, BackgroundTransparency = 0.6, BorderSizePixel = 0, Text = "", Parent = self.TabContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = tab.Button})
	tab.Icon = Create("ImageLabel", {Name = "Icon", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9), BackgroundTransparency = 1, Image = tab.Icon, ImageColor3 = self.Theme.TextSecondary, Parent = tab.Button})
	tab.Label = Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -38, 0.6, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Text = tab.Name, TextColor3 = self.Theme.TextSecondary, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = tab.Button})
	Create("TextLabel", {Name = "Subtext", Size = UDim2.new(1, -38, 0.4, 0), Position = UDim2.new(0, 32, 0.6, 0), BackgroundTransparency = 1, Text = config.Subtext or "", TextColor3 = self.Theme.TextDisabled, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = tab.Button})
	tab.Button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
	tab.Button.MouseEnter:Connect(function() if self.CurrentTab ~= tab then tab.Button.BackgroundTransparency = 0.4 end end)
	tab.Button.MouseLeave:Connect(function() if self.CurrentTab ~= tab then tab.Button.BackgroundTransparency = 0.6 end end)
	table.insert(self.Tabs, tab)
	if not self.CurrentTab then self:SelectTab(tab) end
	self:UpdateTabContainerSize()
	return tab
end

function OdinLib:UpdateTabContainerSize()
	local tabCount = #self.Tabs
	local tabHeight = 38
	local padding = 4
	local searchHeight = 47
	local totalTabHeight = (tabCount * tabHeight) + ((tabCount - 1) * padding)
	local availableHeight = self.Sidebar.AbsoluteSize.Y - searchHeight
	if totalTabHeight < availableHeight then
		self.TabContainer.Size = UDim2.new(1, -10, 0, totalTabHeight + 8)
		self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	else
		self.TabContainer.Size = UDim2.new(1, -10, 1, -searchHeight)
	end
end

function OdinLib:SelectTab(tab)
	if self.CurrentTab then
		self.CurrentTab.Button.BackgroundTransparency = 0.6
		self.CurrentTab.Icon.ImageColor3 = self.Theme.TextSecondary
		self.CurrentTab.Label.TextColor3 = self.Theme.TextSecondary
	end
	self.CurrentTab = tab
	tab.Button.BackgroundTransparency = 0
	tab.Icon.ImageColor3 = self.Theme.Primary
	tab.Label.TextColor3 = self.Theme.TextPrimary
	for _, child in pairs(self.ContentScroll:GetChildren()) do if child:IsA("GuiObject") then child.Visible = false end end
	for _, element in pairs(tab.Elements) do
		if element.Frame.Parent ~= self.ContentScroll then element.Frame.Parent = self.ContentScroll end
		element.Frame.Visible = true
	end
end

function OdinLib:AddToggle(tab, config)
	local element = {Type = "Toggle", Name = config.Name or "Toggle", Value = config.Default or false, Callback = config.Callback or function() end}
	element.Frame = Create("Frame", {Name = "ToggleElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = element.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = element.Frame})
	element.Toggle = Create("TextButton", {Name = "ToggleButton", Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = element.Value and self.Theme.Primary or self.Theme.Border, BorderSizePixel = 0, Text = "", Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = element.Toggle})
	element.Circle = Create("Frame", {Name = "Circle", Size = UDim2.new(0, 16, 0, 16), Position = element.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = element.Toggle})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = element.Circle})
	local function toggle()
		element.Value = not element.Value
		game:GetService("TweenService"):Create(element.Toggle, TweenInfo.new(0.15), {BackgroundColor3 = element.Value and self.Theme.Primary or self.Theme.Border}):Play()
		game:GetService("TweenService"):Create(element.Circle, TweenInfo.new(0.15), {Position = element.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
		element.Callback(element.Value)
	end
	element.Toggle.MouseButton1Click:Connect(toggle)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddSlider(tab, config)
	local element = {Type = "Slider", Name = config.Name or "Slider", Min = config.Min or 0, Max = config.Max or 100, Default = config.Default or config.Min or 0, Increment = config.Increment or 1, Callback = config.Callback or function() end}
	element.Value = element.Default
	element.Frame = Create("Frame", {Name = "SliderElement", Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -100, 0, 20), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Text = element.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = element.Frame})
	element.ValueBox = Create("TextBox", {Name = "ValueBox", Size = UDim2.new(0, 60, 0, 24), Position = UDim2.new(1, -70, 0, 4), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = tostring(element.Value), TextColor3 = self.Theme.Primary, TextSize = 11, Font = Enum.Font.GothamBold, Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = element.ValueBox})
	local sliderBack = Create("Frame", {Name = "SliderBack", Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 34), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBack})
	element.SliderFill = Create("Frame", {Name = "SliderFill", Size = UDim2.new((element.Value - element.Min) / (element.Max - element.Min), 0, 1, 0), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Parent = sliderBack})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = element.SliderFill})
	element.SliderButton = Create("TextButton", {Name = "SliderButton", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((element.Value - element.Min) / (element.Max - element.Min), -7, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Text = "", Parent = sliderBack})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = element.SliderButton})
	local dragging = false
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		local value = math.clamp(math.floor((element.Min + (pos * (element.Max - element.Min))) / element.Increment + 0.5) * element.Increment, element.Min, element.Max)
		element.Value = value
		element.ValueBox.Text = tostring(value)
		element.SliderFill.Size = UDim2.new(pos, 0, 1, 0)
		element.SliderButton.Position = UDim2.new(pos, -7, 0.5, -7)
		element.Callback(value)
	end
	element.SliderButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider(input) end end)
	element.SliderButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	sliderBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider(input) end end)
	game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
	game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	element.ValueBox.FocusLost:Connect(function()
		local value = tonumber(element.ValueBox.Text)
		if value then
			value = math.clamp(math.floor(value / element.Increment + 0.5) * element.Increment, element.Min, element.Max)
			element.Value = value
			element.ValueBox.Text = tostring(value)
			local pos = (value - element.Min) / (element.Max - element.Min)
			element.SliderFill.Size = UDim2.new(pos, 0, 1, 0)
			element.SliderButton.Position = UDim2.new(pos, -7, 0.5, -7)
			element.Callback(value)
		else element.ValueBox.Text = tostring(element.Value) end
	end)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddDropdown(tab, config)
	local element = {Type = "Dropdown", Name = config.Name or "Dropdown", Options = config.Options or {"Option 1", "Option 2"}, Default = config.Default or (config.Options and config.Options[1]) or "Option 1", Callback = config.Callback or function() end, Open = false}
	element.Value = element.Default
	element.Frame = Create("Frame", {Name = "DropdownElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false, ClipsDescendants = false, ZIndex = 1})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = element.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = element.Frame})
	local dropdownButton = Create("TextButton", {Name = "DropdownButton", Size = UDim2.new(0.55, -10, 0, 28), Position = UDim2.new(0.45, 0, 0.5, -14), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = "", ZIndex = 2, Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = dropdownButton})
	element.SelectedLabel = Create("TextLabel", {Name = "SelectedLabel", Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = element.Value, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = dropdownButton})
	element.Arrow = Create("ImageLabel", {Name = "Arrow", Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -18, 0.5, -5), BackgroundTransparency = 1, Image = "rbxassetid://7072706796", ImageColor3 = self.Theme.TextSecondary, Rotation = 0, ZIndex = 2, Parent = dropdownButton})
	element.DropdownContainer = Create("Frame", {Name = "DropdownContainer", Size = UDim2.new(0.55, -10, 0, 0), Position = UDim2.new(0.45, 0, 1, 4), BackgroundTransparency = 1, Visible = false, ClipsDescendants = false, ZIndex = 200, Parent = element.Frame})
	element.OptionsFrame = Create("ScrollingFrame", {Name = "OptionsFrame", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 201, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = element.DropdownContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.OptionsFrame})
	local optionsLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = element.OptionsFrame})
	Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = element.OptionsFrame})
	for _, option in pairs(element.Options) do
		local optionButton = Create("TextButton", {Name = option, Size = UDim2.new(1, -8, 0, 24), BackgroundColor3 = self.Theme.Content, BackgroundTransparency = 0.5, BorderSizePixel = 0, Text = option, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, ZIndex = 202, Parent = element.OptionsFrame})
		Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = optionButton})
		optionButton.MouseButton1Click:Connect(function()
			element.Value = option
			element.SelectedLabel.Text = option
			element.Open = false
			element.DropdownContainer.Visible = false
			game:GetService("TweenService"):Create(element.Arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
			element.Callback(option)
		end)
		optionButton.MouseEnter:Connect(function() optionButton.BackgroundTransparency = 0.2 end)
		optionButton.MouseLeave:Connect(function() optionButton.BackgroundTransparency = 0.5 end)
	end
	optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		element.OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y + 8)
		element.DropdownContainer.Size = UDim2.new(0.55, -10, 0, math.min(optionsLayout.AbsoluteContentSize.Y + 8, 120))
	end)
	dropdownButton.MouseButton1Click:Connect(function()
		element.Open = not element.Open
		element.DropdownContainer.Visible = element.Open
		game:GetService("TweenService"):Create(element.Arrow, TweenInfo.new(0.15), {Rotation = element.Open and 180 or 0}):Play()
	end)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddInput(tab, config)
	local element = {Type = "Input", Name = config.Name or "Input", Placeholder = config.Placeholder or "Enter text...", Default = config.Default or "", Callback = config.Callback or function() end}
	element.Value = element.Default
	element.Frame = Create("Frame", {Name = "InputElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = element.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = element.Frame})
	element.InputBox = Create("TextBox", {Name = "InputBox", Size = UDim2.new(0.55, -10, 0, 28), Position = UDim2.new(0.45, 0, 0.5, -14), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = element.Value, PlaceholderText = element.Placeholder, PlaceholderColor3 = self.Theme.TextDisabled, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.InputBox})
	Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = element.InputBox})
	element.InputBox.FocusLost:Connect(function() element.Value = element.InputBox.Text element.Callback(element.InputBox.Text) end)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddButton(tab, config)
	local element = {Type = "Button", Name = config.Name or "Button", Callback = config.Callback or function() end}
	element.Frame = Create("Frame", {Name = "ButtonElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	element.Button = Create("TextButton", {Name = "Button", Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0.5, -16), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Text = element.Name, TextColor3 = self.Theme.Background, TextSize = 12, Font = Enum.Font.GothamBold, Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Button})
	element.Button.MouseButton1Click:Connect(function() element.Callback() end)
	element.Button.MouseEnter:Connect(function() game:GetService("TweenService"):Create(element.Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(math.min(255, self.Theme.Primary.R * 255 * 1.15), math.min(255, self.Theme.Primary.G * 255 * 1.15), math.min(255, self.Theme.Primary.B * 255 * 1.15))}):Play() end)
	element.Button.MouseLeave:Connect(function() game:GetService("TweenService"):Create(element.Button, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Primary}):Play() end)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddColorPicker(tab, config)
	local element = {Type = "ColorPicker", Name = config.Name or "Color Picker", Default = config.Default or Color3.fromRGB(255, 255, 255), Callback = config.Callback or function() end}
	element.Value = element.Default
	element.Frame = Create("Frame", {Name = "ColorPickerElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = element.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = element.Frame})
	element.ColorDisplay = Create("TextButton", {Name = "ColorDisplay", Size = UDim2.new(0, 60, 0, 28), Position = UDim2.new(1, -70, 0.5, -14), BackgroundColor3 = element.Value, BorderSizePixel = 0, Text = "", Parent = element.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.ColorDisplay})
	element.ColorDisplay.MouseButton1Click:Connect(function() element.Callback(element.Value) end)
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddLabel(tab, config)
	local element = {Type = "Label", Text = config.Text or "Label"}
	element.Frame = Create("Frame", {Name = "LabelElement", Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = element.Frame})
	element.Label = Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = element.Text, TextColor3 = self.Theme.TextSecondary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = element.Frame})
	function element:SetText(text) element.Text = text element.Label.Text = text end
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:AddDivider(tab, config)
	local element = {Type = "Divider", Text = config.Text or nil}
	element.Frame = Create("Frame", {Name = "DividerElement", Size = UDim2.new(1, 0, 0, element.Text and 32 or 8), BackgroundTransparency = 1, Parent = self.ContentScroll, Visible = false})
	if element.Text then Create("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = element.Text, TextColor3 = self.Theme.TextDisabled, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = element.Frame}) end
	Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = element.Text and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Parent = element.Frame})
	table.insert(tab.Elements, element)
	return element
end

function OdinLib:Log(message, logType)
	local color = self.Theme.TextSecondary
	if logType == "success" then color = self.Theme.Success elseif logType == "warning" then color = self.Theme.Warning elseif logType == "error" then color = self.Theme.Error end
	Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = os.date("[%H:%M:%S]") .. " " .. message, TextColor3 = color, TextSize = 10, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.ConsoleScroll})
end

return OdinLib
