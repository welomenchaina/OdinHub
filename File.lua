local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DEFAULT_IMAGE = "rbxassetid://7072706960"

local COLORS = {
	Background     = Color3.fromRGB(18, 18, 20),
	Sidebar        = Color3.fromRGB(22, 22, 26),
	SidebarActive  = Color3.fromRGB(30, 30, 36),
	Panel          = Color3.fromRGB(26, 26, 30),
	Section        = Color3.fromRGB(30, 30, 36),
	Accent         = Color3.fromRGB(255, 255, 255),
	AccentDim      = Color3.fromRGB(160, 160, 170),
	Toggle         = Color3.fromRGB(80, 160, 255),
	ToggleOff      = Color3.fromRGB(50, 50, 60),
	Slider         = Color3.fromRGB(80, 160, 255),
	SliderTrack    = Color3.fromRGB(40, 40, 50),
	Dropdown       = Color3.fromRGB(30, 30, 38),
	DropdownBorder = Color3.fromRGB(50, 50, 62),
	TextMain       = Color3.fromRGB(235, 235, 240),
	TextDim        = Color3.fromRGB(120, 120, 135),
	TextLabel      = Color3.fromRGB(180, 180, 195),
	Divider        = Color3.fromRGB(40, 40, 50),
	Input          = Color3.fromRGB(22, 22, 28),
	InputBorder    = Color3.fromRGB(55, 55, 68),
}

local function tween(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function makeInstance(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	inst.Parent = parent
	return inst
end

local function corner(parent, radius)
	makeInstance("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function stroke(parent, color, thickness)
	makeInstance("UIStroke", {Color = color or COLORS.Divider, Thickness = thickness or 1}, parent)
end

local function padding(parent, top, right, bottom, left)
	makeInstance("UIPadding", {
		PaddingTop    = UDim.new(0, top    or 8),
		PaddingRight  = UDim.new(0, right  or 8),
		PaddingBottom = UDim.new(0, bottom or 8),
		PaddingLeft   = UDim.new(0, left   or 8),
	}, parent)
end

local function listLayout(parent, dir, spacing, align)
	makeInstance("UIListLayout", {
		FillDirection     = dir   or Enum.FillDirection.Vertical,
		SortOrder         = Enum.SortOrder.LayoutOrder,
		Padding           = UDim.new(0, spacing or 6),
		HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
	}, parent)
end

local function draggable(frame, handle)
	handle = handle or frame
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = input.Position
			startPos  = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

function Library.new(config)
	config = config or {}
	local self = setmetatable({}, Library)
	self.Title      = config.Title   or "Hub"
	self.Image      = config.Image   or DEFAULT_IMAGE
	self.Tabs       = {}
	self.ActiveTab  = nil
	self.Minimized  = false
	self._loaded    = false
	self._loadNow   = false

	self._gui = makeInstance("ScreenGui", {
		Name             = "MolchunLib",
		ResetOnSpawn     = false,
		ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset   = true,
	}, (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")))

	self:_buildLoading()
	self:_scheduleLoad()
	return self
end

function Library:_buildLoading()
	local overlay = makeInstance("Frame", {
		Name            = "LoadOverlay",
		Size            = UDim2.fromScale(1, 1),
		BackgroundColor3= Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		ZIndex          = 100,
	}, self._gui)

	local vignette = makeInstance("ImageLabel", {
		Size            = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image           = "rbxassetid://5699893404",
		ImageColor3     = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.2,
		ScaleType       = Enum.ScaleType.Stretch,
		ZIndex          = 101,
	}, overlay)

	local imgHolder = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0.5, 0.5),
		Position        = UDim2.fromScale(0.5, 0.5),
		Size            = UDim2.fromOffset(140, 140),
		BackgroundColor3= Color3.fromRGB(25, 25, 30),
		ZIndex          = 102,
	}, overlay)
	corner(imgHolder, 24)
	stroke(imgHolder, Color3.fromRGB(60, 60, 75), 1.5)

	local img = makeInstance("ImageLabel", {
		Size            = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image           = self.Image,
		ScaleType       = Enum.ScaleType.Fit,
		ZIndex          = 103,
	}, imgHolder)
	corner(img, 24)

	imgHolder.Size = UDim2.fromOffset(0, 0)
	imgHolder.BackgroundTransparency = 1
	tween(imgHolder, {Size = UDim2.fromOffset(140, 140), BackgroundTransparency = 0}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	self._loadOverlay = overlay
end

function Library:_scheduleLoad()
	task.spawn(function()
		local elapsed = 0
		while elapsed < 2 do
			if self._loadNow then break end
			elapsed = elapsed + task.wait(0.05)
		end
		self:_finishLoad()
	end)
end

function Library:LoadNow()
	self._loadNow = true
end

function Library:_finishLoad()
	if self._loaded then return end
	self._loaded = true
	tween(self._loadOverlay, {BackgroundTransparency = 1}, 0.4)
	for _, v in ipairs(self._loadOverlay:GetDescendants()) do
		if v:IsA("GuiObject") then
			tween(v, {BackgroundTransparency = 1, ImageTransparency = 1}, 0.4)
		end
	end
	task.delay(0.45, function()
		self._loadOverlay:Destroy()
		self:_buildMain()
	end)
end

function Library:_buildMain()
	local SIDEBAR_EXPANDED = 160
	local SIDEBAR_COLLAPSED = 48
	local WIN_W = 580
	local WIN_H = 420

	local win = makeInstance("Frame", {
		Name            = "MainWindow",
		AnchorPoint     = Vector2.new(0.5, 0.5),
		Position        = UDim2.fromScale(0.5, 0.5),
		Size            = UDim2.fromOffset(WIN_W, WIN_H),
		BackgroundColor3= COLORS.Background,
		ClipsDescendants= true,
	}, self._gui)
	corner(win, 10)
	stroke(win, Color3.fromRGB(45, 45, 55), 1)

	win.Size = UDim2.fromOffset(0, 0)
	win.BackgroundTransparency = 1
	tween(win, {Size = UDim2.fromOffset(WIN_W, WIN_H), BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	draggable(win)

	local sidebar = makeInstance("Frame", {
		Name            = "Sidebar",
		Size            = UDim2.new(0, SIDEBAR_EXPANDED, 1, 0),
		BackgroundColor3= COLORS.Sidebar,
	}, win)

	local sideTop = makeInstance("Frame", {
		Name            = "SideTop",
		Size            = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
	}, sidebar)

	local logoImg = makeInstance("ImageLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 10, 0.5, 0),
		Size            = UDim2.fromOffset(26, 26),
		BackgroundTransparency = 1,
		Image           = self.Image,
		ScaleType       = Enum.ScaleType.Fit,
	}, sideTop)
	corner(logoImg, 6)

	local titleLabel = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 44, 0.5, 0),
		Size            = UDim2.new(1, -54, 0, 20),
		BackgroundTransparency = 1,
		Text            = self.Title,
		TextColor3      = COLORS.TextMain,
		TextSize        = 14,
		Font            = Enum.Font.GothamBold,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, sideTop)

	local divTop = makeInstance("Frame", {
		Position        = UDim2.new(0, 0, 1, 0),
		Size            = UDim2.new(1, 0, 0, 1),
		BackgroundColor3= COLORS.Divider,
		BorderSizePixel = 0,
	}, sideTop)

	local tabScroll = makeInstance("ScrollingFrame", {
		Position        = UDim2.new(0, 0, 0, 51),
		Size            = UDim2.new(1, 0, 1, -100),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize      = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize= Enum.AutomaticSize.Y,
	}, sidebar)
	padding(tabScroll, 6, 0, 6, 0)
	listLayout(tabScroll, Enum.FillDirection.Vertical, 2)

	local sideBottom = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0, 1),
		Position        = UDim2.new(0, 0, 1, 0),
		Size            = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
	}, sidebar)

	local divBot = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 1),
		BackgroundColor3= COLORS.Divider,
		BorderSizePixel = 0,
	}, sideBottom)

	local avatarImg = makeInstance("ImageLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 10, 0.5, 0),
		Size            = UDim2.fromOffset(26, 26),
		BackgroundTransparency = 1,
		Image           = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png",
	}, sideBottom)
	corner(avatarImg, 13)

	local userLabel = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 44, 0.5, 0),
		Size            = UDim2.new(1, -60, 0, 16),
		BackgroundTransparency = 1,
		Text            = LocalPlayer.Name,
		TextColor3      = COLORS.TextDim,
		TextSize        = 12,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
		ClipsDescendants= true,
	}, sideBottom)

	local minimizeBtn = makeInstance("TextButton", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, -8, 0.5, 0),
		Size            = UDim2.fromOffset(22, 22),
		BackgroundColor3= COLORS.Section,
		Text            = "«",
		TextColor3      = COLORS.TextDim,
		TextSize        = 12,
		Font            = Enum.Font.GothamBold,
		BorderSizePixel = 0,
	}, sideBottom)
	corner(minimizeBtn, 6)

	local content = makeInstance("Frame", {
		Name            = "Content",
		Position        = UDim2.new(0, SIDEBAR_EXPANDED, 0, 0),
		Size            = UDim2.new(1, -SIDEBAR_EXPANDED, 1, 0),
		BackgroundColor3= COLORS.Panel,
		BorderSizePixel = 0,
	}, win)

	local contentScroll = makeInstance("ScrollingFrame", {
		Name            = "ContentScroll",
		Size            = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75),
		CanvasSize      = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize= Enum.AutomaticSize.Y,
	}, content)
	padding(contentScroll, 10, 10, 10, 10)

	local contentLayout = makeInstance("UIGridLayout", {
		CellPadding     = UDim2.fromOffset(8, 8),
		CellSize        = UDim2.new(0.5, -4, 0, 0),
		FillDirection   = Enum.FillDirection.Horizontal,
		SortOrder       = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment= Enum.HorizontalAlignment.Left,
		VerticalAlignment  = Enum.VerticalAlignment.Top,
	}, contentScroll)
	contentLayout.CellSize = UDim2.new(1, 0, 0, 0)

	self._tabContainer  = tabScroll
	self._contentScroll = contentScroll
	self._contentParent = contentScroll
	self._sidebar       = sidebar
	self._titleLabel    = titleLabel
	self._win           = win
	self._minimizeBtn   = minimizeBtn
	self._content       = content
	self._SIDEBAR_EXPANDED  = SIDEBAR_EXPANDED
	self._SIDEBAR_COLLAPSED = SIDEBAR_COLLAPSED
	self._WIN_W         = WIN_W
	self._logoImg       = logoImg
	self._userLabel     = userLabel
	self._avatarImg     = avatarImg

	contentLayout:Destroy()
	makeInstance("UIListLayout", {
		FillDirection   = Enum.FillDirection.Vertical,
		SortOrder       = Enum.SortOrder.LayoutOrder,
		Padding         = UDim.new(0, 8),
	}, contentScroll)

	minimizeBtn.MouseButton1Click:Connect(function()
		self:_toggleMinimize()
	end)

	for _, tab in ipairs(self.Tabs) do
		self:_renderTab(tab)
	end
	if self.Tabs[1] then
		self:_selectTab(self.Tabs[1])
	end
end

function Library:_toggleMinimize()
	self.Minimized = not self.Minimized
	local sb = self._sidebar
	local cont = self._content
	local win = self._win
	local collapsed = self._SIDEBAR_COLLAPSED
	local expanded  = self._SIDEBAR_EXPANDED
	local WIN_W     = self._WIN_W

	if self.Minimized then
		tween(sb, {Size = UDim2.new(0, collapsed, 1, 0)}, 0.22)
		tween(cont, {Position = UDim2.new(0, collapsed, 0, 0), Size = UDim2.new(1, -collapsed, 1, 0)}, 0.22)
		tween(self._titleLabel, {TextTransparency = 1}, 0.1)
		tween(self._userLabel, {TextTransparency = 1}, 0.1)
		self._minimizeBtn.Text = "»"
	else
		tween(sb, {Size = UDim2.new(0, expanded, 1, 0)}, 0.22)
		tween(cont, {Position = UDim2.new(0, expanded, 0, 0), Size = UDim2.new(1, -expanded, 1, 0)}, 0.22)
		tween(self._titleLabel, {TextTransparency = 0}, 0.2)
		tween(self._userLabel, {TextTransparency = 0}, 0.2)
		self._minimizeBtn.Text = "«"
	end
end

function Library:AddTab(config)
	config = config or {}
	local tab = {
		Name     = config.Name    or "Tab",
		Icon     = config.Icon    or "rbxassetid://7072706960",
		Sections = {},
		_btn     = nil,
	}
	table.insert(self.Tabs, tab)
	if self._tabContainer then
		self:_renderTab(tab)
		if #self.Tabs == 1 then
			self:_selectTab(tab)
		end
	end
	return tab
end

function Library:_renderTab(tab)
	local btn = makeInstance("TextButton", {
		Size            = UDim2.new(1, 0, 0, 36),
		BackgroundColor3= COLORS.Sidebar,
		BackgroundTransparency = 1,
		Text            = "",
		BorderSizePixel = 0,
	}, self._tabContainer)
	corner(btn, 7)

	local iconImg = makeInstance("ImageLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 12, 0.5, 0),
		Size            = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Image           = tab.Icon,
		ImageColor3     = COLORS.TextDim,
	}, btn)

	local lbl = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 38, 0.5, 0),
		Size            = UDim2.new(1, -48, 0, 20),
		BackgroundTransparency = 1,
		Text            = tab.Name,
		TextColor3      = COLORS.TextDim,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, btn)

	local indicator = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 2, 0.5, 0),
		Size            = UDim2.fromOffset(3, 18),
		BackgroundColor3= COLORS.Toggle,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, btn)
	corner(indicator, 2)

	tab._btn = btn
	tab._icon = iconImg
	tab._label = lbl
	tab._indicator = indicator

	btn.MouseButton1Click:Connect(function()
		self:_selectTab(tab)
	end)
	btn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			tween(btn, {BackgroundTransparency = 0.85}, 0.12)
			btn.BackgroundColor3 = COLORS.SidebarActive
		end
	end)
	btn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			tween(btn, {BackgroundTransparency = 1}, 0.12)
		end
	end)
end

function Library:_selectTab(tab)
	if self.ActiveTab then
		local prev = self.ActiveTab
		tween(prev._btn, {BackgroundTransparency = 1}, 0.15)
		tween(prev._label, {TextColor3 = COLORS.TextDim}, 0.15)
		tween(prev._icon, {ImageColor3 = COLORS.TextDim}, 0.15)
		tween(prev._indicator, {BackgroundTransparency = 1}, 0.15)
		for _, sec in ipairs(prev.Sections) do
			if sec._frame then
				sec._frame.Visible = false
			end
		end
	end

	self.ActiveTab = tab
	tween(tab._btn, {BackgroundTransparency = 0.82}, 0.15)
	tab._btn.BackgroundColor3 = COLORS.SidebarActive
	tween(tab._label, {TextColor3 = COLORS.TextMain}, 0.15)
	tween(tab._icon, {ImageColor3 = COLORS.Toggle}, 0.15)
	tween(tab._indicator, {BackgroundTransparency = 0}, 0.15)
	for _, sec in ipairs(tab.Sections) do
		if sec._frame then
			sec._frame.Visible = true
		end
	end
end

function Library:AddSection(tab, config)
	config = config or {}
	local section = {
		Name     = config.Name or "Section",
		Tab      = tab,
		Expanded = true,
		Items    = {},
		_frame   = nil,
		_body    = nil,
	}
	table.insert(tab.Sections, section)

	if self._contentParent then
		self:_renderSection(section)
	end
	return section
end

function Library:_renderSection(section)
	local frame = makeInstance("Frame", {
		Name            = section.Name,
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundColor3= COLORS.Section,
		BorderSizePixel = 0,
		Visible         = (self.ActiveTab == section.Tab),
	}, self._contentParent)
	corner(frame, 8)
	stroke(frame, COLORS.Divider, 1)

	local header = makeInstance("TextButton", {
		Size            = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Text            = "",
		BorderSizePixel = 0,
	}, frame)

	local headerLabel = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 14, 0.5, 0),
		Size            = UDim2.new(1, -50, 0, 18),
		BackgroundTransparency = 1,
		Text            = section.Name,
		TextColor3      = COLORS.TextDim,
		TextSize        = 12,
		Font            = Enum.Font.GothamBold,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, header)

	local chevron = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, -14, 0.5, 0),
		Size            = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Text            = "v",
		TextColor3      = COLORS.TextDim,
		TextSize        = 11,
		Font            = Enum.Font.GothamBold,
		TextXAlignment  = Enum.TextXAlignment.Center,
	}, header)

	local divider = makeInstance("Frame", {
		Position        = UDim2.new(0, 14, 0, 35),
		Size            = UDim2.new(1, -28, 0, 1),
		BackgroundColor3= COLORS.Divider,
		BorderSizePixel = 0,
	}, frame)

	local body = makeInstance("Frame", {
		Name            = "Body",
		Position        = UDim2.new(0, 0, 0, 36),
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants= false,
	}, frame)
	padding(body, 8, 12, 10, 12)
	listLayout(body, Enum.FillDirection.Vertical, 8)

	section._frame   = frame
	section._body    = body
	section._chevron = chevron
	section._divider = divider

	header.MouseButton1Click:Connect(function()
		section.Expanded = not section.Expanded
		if section.Expanded then
			body.Visible = true
			divider.Visible = true
			chevron.Text = "v"
		else
			body.Visible = false
			divider.Visible = false
			chevron.Text = ">"
		end
	end)

	for _, item in ipairs(section.Items) do
		self:_renderItem(section, item)
	end
end

function Library:_renderItem(section, item)
	local body = section._body
	if item.Type == "Toggle" then
		self:_renderToggle(body, item)
	elseif item.Type == "Slider" then
		self:_renderSlider(body, item)
	elseif item.Type == "Dropdown" then
		self:_renderDropdown(body, item)
	elseif item.Type == "Input" then
		self:_renderInput(body, item)
	elseif item.Type == "Button" then
		self:_renderButton(body, item)
	elseif item.Type == "Paragraph" then
		self:_renderParagraph(body, item)
	elseif item.Type == "ColorPicker" then
		self:_renderColorPicker(body, item)
	end
end

function Library:_addItem(section, item)
	table.insert(section.Items, item)
	if section._body then
		self:_renderItem(section, item)
	end
	return item
end

function Library:MakeToggle(section, config)
	config = config or {}
	local item = {
		Type     = "Toggle",
		Name     = config.Name    or "Toggle",
		Default  = config.Default or false,
		Callback = config.Callback or function() end,
		Value    = config.Default or false,
	}
	return self:_addItem(section, item)
end

function Library:_renderToggle(parent, item)
	local row = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
	}, parent)

	local lbl = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 0, 0.5, 0),
		Size            = UDim2.new(1, -52, 1, 0),
		BackgroundTransparency = 1,
		Text            = item.Name,
		TextColor3      = COLORS.TextLabel,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, row)

	local trackBg = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, 0, 0.5, 0),
		Size            = UDim2.fromOffset(42, 22),
		BackgroundColor3= item.Value and COLORS.Toggle or COLORS.ToggleOff,
		BorderSizePixel = 0,
	}, row)
	corner(trackBg, 11)

	local knob = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = item.Value and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size            = UDim2.fromOffset(18, 18),
		BackgroundColor3= Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, trackBg)
	corner(knob, 9)

	local function setVal(val)
		item.Value = val
		tween(trackBg, {BackgroundColor3 = val and COLORS.Toggle or COLORS.ToggleOff}, 0.15)
		tween(knob, {Position = val and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.15)
		pcall(item.Callback, val)
	end

	local clickArea = makeInstance("TextButton", {
		Size            = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text            = "",
		ZIndex          = trackBg.ZIndex + 5,
	}, trackBg)

	clickArea.MouseButton1Click:Connect(function()
		setVal(not item.Value)
	end)

	item.Set = setVal
end

function Library:MakeSlider(section, config)
	config = config or {}
	local item = {
		Type     = "Slider",
		Name     = config.Name    or "Slider",
		Min      = config.Min     or 0,
		Max      = config.Max     or 100,
		Default  = config.Default or 0,
		Decimals = config.Decimals or 0,
		Suffix   = config.Suffix  or "",
		Callback = config.Callback or function() end,
		Value    = config.Default or 0,
	}
	return self:_addItem(section, item)
end

function Library:_renderSlider(parent, item)
	local wrap = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1,
	}, parent)

	local topRow = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
	}, wrap)

	local lbl = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 0, 0.5, 0),
		Size            = UDim2.new(0.7, 0, 1, 0),
		BackgroundTransparency = 1,
		Text            = item.Name,
		TextColor3      = COLORS.TextLabel,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, topRow)

	local valLabel = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, 0, 0.5, 0),
		Size            = UDim2.new(0.3, 0, 1, 0),
		BackgroundTransparency = 1,
		Text            = tostring(item.Value) .. item.Suffix,
		TextColor3      = COLORS.TextDim,
		TextSize        = 12,
		Font            = Enum.Font.GothamBold,
		TextXAlignment  = Enum.TextXAlignment.Right,
	}, topRow)

	local track = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0, 0),
		Position        = UDim2.new(0, 0, 0, 26),
		Size            = UDim2.new(1, 0, 0, 5),
		BackgroundColor3= COLORS.SliderTrack,
		BorderSizePixel = 0,
	}, wrap)
	corner(track, 3)

	local pct = (item.Value - item.Min) / (item.Max - item.Min)

	local fill = makeInstance("Frame", {
		Size            = UDim2.new(pct, 0, 1, 0),
		BackgroundColor3= COLORS.Slider,
		BorderSizePixel = 0,
	}, track)
	corner(fill, 3)

	local thumb = makeInstance("Frame", {
		AnchorPoint     = Vector2.new(0.5, 0.5),
		Position        = UDim2.new(pct, 0, 0.5, 0),
		Size            = UDim2.fromOffset(13, 13),
		BackgroundColor3= Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex          = track.ZIndex + 2,
	}, track)
	corner(thumb, 7)

	local dragging = false

	local function updateSlider(mouseX)
		local absPos = track.AbsolutePosition.X
		local absSize = track.AbsoluteSize.X
		local rel = math.clamp((mouseX - absPos) / absSize, 0, 1)
		local raw = item.Min + rel * (item.Max - item.Min)
		local mult = 10 ^ item.Decimals
		item.Value = math.round(raw * mult) / mult
		fill.Size = UDim2.new(rel, 0, 1, 0)
		thumb.Position = UDim2.new(rel, 0, 0.5, 0)
		valLabel.Text = tostring(item.Value) .. item.Suffix
		pcall(item.Callback, item.Value)
	end

	local hitArea = makeInstance("TextButton", {
		Size            = UDim2.new(1, 0, 0, 18),
		Position        = UDim2.new(0, 0, 0, -6),
		BackgroundTransparency = 1,
		Text            = "",
		ZIndex          = track.ZIndex + 3,
	}, track)

	hitArea.MouseButton1Down:Connect(function()
		dragging = true
		updateSlider(UserInputService:GetMouseLocation().X)
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	item.Set = function(val)
		item.Value = math.clamp(val, item.Min, item.Max)
		local r = (item.Value - item.Min) / (item.Max - item.Min)
		fill.Size = UDim2.new(r, 0, 1, 0)
		thumb.Position = UDim2.new(r, 0, 0.5, 0)
		valLabel.Text = tostring(item.Value) .. item.Suffix
	end
end

function Library:MakeDropdown(section, config)
	config = config or {}
	local item = {
		Type     = "Dropdown",
		Name     = config.Name    or "Dropdown",
		Options  = config.Options or {},
		Default  = config.Default,
		Callback = config.Callback or function() end,
		Value    = config.Default or (config.Options and config.Options[1]),
	}
	return self:_addItem(section, item)
end

function Library:_renderDropdown(parent, item)
	local wrap = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		ClipsDescendants= false,
		ZIndex          = 5,
	}, parent)

	local lbl = makeInstance("TextLabel", {
		Size            = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text            = item.Name,
		TextColor3      = COLORS.TextLabel,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, wrap)

	local box = makeInstance("TextButton", {
		Position        = UDim2.new(0, 0, 0, 22),
		Size            = UDim2.new(1, 0, 0, 26),
		BackgroundColor3= COLORS.Dropdown,
		Text            = "",
		BorderSizePixel = 0,
		ClipsDescendants= false,
		ZIndex          = 6,
	}, wrap)
	corner(box, 6)
	stroke(box, COLORS.DropdownBorder, 1)

	local selLabel = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 10, 0.5, 0),
		Size            = UDim2.new(1, -30, 1, 0),
		BackgroundTransparency = 1,
		Text            = tostring(item.Value or "Select..."),
		TextColor3      = COLORS.TextMain,
		TextSize        = 12,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
		ZIndex          = 7,
	}, box)

	local arrow = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, -10, 0.5, 0),
		Size            = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		Text            = "v",
		TextColor3      = COLORS.TextDim,
		TextSize        = 11,
		Font            = Enum.Font.GothamBold,
		ZIndex          = 7,
	}, box)

	local dropdown = makeInstance("Frame", {
		Position        = UDim2.new(0, 0, 1, 4),
		Size            = UDim2.new(1, 0, 0, 0),
		BackgroundColor3= COLORS.Dropdown,
		Visible         = false,
		ClipsDescendants= true,
		ZIndex          = 20,
	}, box)
	corner(dropdown, 6)
	stroke(dropdown, COLORS.DropdownBorder, 1)

	local optList = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex          = 21,
	}, dropdown)
	padding(optList, 4, 0, 4, 0)
	listLayout(optList, Enum.FillDirection.Vertical, 2)

	local open = false
	local TARGET_H = #item.Options * 28 + 8

	local function buildOptions()
		for _, child in ipairs(optList:GetChildren()) do
			if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
		end
		for _, opt in ipairs(item.Options) do
			local optBtn = makeInstance("TextButton", {
				Size            = UDim2.new(1, 0, 0, 26),
				BackgroundColor3= COLORS.Dropdown,
				BackgroundTransparency = 1,
				Text            = tostring(opt),
				TextColor3      = opt == item.Value and COLORS.TextMain or COLORS.TextDim,
				TextSize        = 12,
				Font            = Enum.Font.Gotham,
				BorderSizePixel = 0,
				ZIndex          = 22,
			}, optList)

			optBtn.MouseEnter:Connect(function()
				tween(optBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = COLORS.SidebarActive}, 0.1)
				tween(optBtn, {TextColor3 = COLORS.TextMain}, 0.1)
			end)
			optBtn.MouseLeave:Connect(function()
				tween(optBtn, {BackgroundTransparency = 1}, 0.1)
				if opt ~= item.Value then
					tween(optBtn, {TextColor3 = COLORS.TextDim}, 0.1)
				end
			end)
			optBtn.MouseButton1Click:Connect(function()
				item.Value = opt
				selLabel.Text = tostring(opt)
				pcall(item.Callback, opt)
				open = false
				tween(dropdown, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
				task.delay(0.18, function() dropdown.Visible = false end)
				buildOptions()
			end)
		end
	end

	buildOptions()

	box.MouseButton1Click:Connect(function()
		open = not open
		if open then
			dropdown.Visible = true
			tween(dropdown, {Size = UDim2.new(1, 0, 0, math.min(TARGET_H, 120))}, 0.18)
		else
			tween(dropdown, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
			task.delay(0.16, function() dropdown.Visible = false end)
		end
	end)

	item.Set = function(val)
		item.Value = val
		selLabel.Text = tostring(val)
		buildOptions()
	end
	item.AddOption = function(opt)
		table.insert(item.Options, opt)
		TARGET_H = #item.Options * 28 + 8
		buildOptions()
	end
end

function Library:MakeInput(section, config)
	config = config or {}
	local item = {
		Type        = "Input",
		Name        = config.Name       or "Input",
		Placeholder = config.Placeholder or "...",
		Default     = config.Default    or "",
		Callback    = config.Callback   or function() end,
		Value       = config.Default    or "",
	}
	return self:_addItem(section, item)
end

function Library:_renderInput(parent, item)
	local wrap = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
	}, parent)

	local lbl = makeInstance("TextLabel", {
		Size            = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text            = item.Name,
		TextColor3      = COLORS.TextLabel,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, wrap)

	local inputBox = makeInstance("Frame", {
		Position        = UDim2.new(0, 0, 0, 22),
		Size            = UDim2.new(1, 0, 0, 26),
		BackgroundColor3= COLORS.Input,
		BorderSizePixel = 0,
	}, wrap)
	corner(inputBox, 6)
	stroke(inputBox, COLORS.InputBorder, 1)

	local textBox = makeInstance("TextBox", {
		Size            = UDim2.new(1, -16, 1, 0),
		Position        = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text            = item.Default,
		PlaceholderText = item.Placeholder,
		PlaceholderColor3 = COLORS.TextDim,
		TextColor3      = COLORS.TextMain,
		TextSize        = 12,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
		ClearTextOnFocus= false,
		BorderSizePixel = 0,
	}, inputBox)

	textBox.FocusLost:Connect(function(enter)
		item.Value = textBox.Text
		pcall(item.Callback, textBox.Text, enter)
	end)

	textBox.Focused:Connect(function()
		tween(inputBox, {BackgroundColor3 = COLORS.SidebarActive}, 0.12)
	end)
	textBox.FocusLost:Connect(function()
		tween(inputBox, {BackgroundColor3 = COLORS.Input}, 0.12)
	end)

	item.Set = function(val)
		item.Value = val
		textBox.Text = val
	end
	item.Get = function() return textBox.Text end
end

function Library:MakeButton(section, config)
	config = config or {}
	local item = {
		Type     = "Button",
		Name     = config.Name    or "Button",
		Callback = config.Callback or function() end,
	}
	return self:_addItem(section, item)
end

function Library:_renderButton(parent, item)
	local btn = makeInstance("TextButton", {
		Size            = UDim2.new(1, 0, 0, 30),
		BackgroundColor3= Color3.fromRGB(45, 45, 58),
		Text            = item.Name,
		TextColor3      = COLORS.TextMain,
		TextSize        = 13,
		Font            = Enum.Font.GothamBold,
		BorderSizePixel = 0,
	}, parent)
	corner(btn, 7)
	stroke(btn, Color3.fromRGB(60, 60, 75), 1)

	btn.MouseButton1Click:Connect(function()
		tween(btn, {BackgroundColor3 = COLORS.Toggle}, 0.08)
		task.delay(0.15, function()
			tween(btn, {BackgroundColor3 = Color3.fromRGB(45, 45, 58)}, 0.15)
		end)
		pcall(item.Callback)
	end)
	btn.MouseEnter:Connect(function()
		tween(btn, {BackgroundColor3 = Color3.fromRGB(55, 55, 68)}, 0.1)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundColor3 = Color3.fromRGB(45, 45, 58)}, 0.1)
	end)
end

function Library:MakeParagraph(section, config)
	config = config or {}
	local item = {
		Type    = "Paragraph",
		Title   = config.Title or "",
		Content = config.Content or "",
	}
	return self:_addItem(section, item)
end

function Library:_renderParagraph(parent, item)
	local wrap = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, parent)
	listLayout(wrap, Enum.FillDirection.Vertical, 4)

	if item.Title ~= "" then
		makeInstance("TextLabel", {
			Size            = UDim2.new(1, 0, 0, 0),
			AutomaticSize   = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text            = item.Title,
			TextColor3      = COLORS.TextMain,
			TextSize        = 13,
			Font            = Enum.Font.GothamBold,
			TextXAlignment  = Enum.TextXAlignment.Left,
			TextWrapped     = true,
		}, wrap)
	end

	makeInstance("TextLabel", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text            = item.Content,
		TextColor3      = COLORS.TextDim,
		TextSize        = 12,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
		TextWrapped     = true,
	}, wrap)
end

function Library:MakeColorPicker(section, config)
	config = config or {}
	local item = {
		Type     = "ColorPicker",
		Name     = config.Name    or "Color",
		Default  = config.Default or Color3.fromRGB(255, 80, 80),
		Callback = config.Callback or function() end,
		Value    = config.Default or Color3.fromRGB(255, 80, 80),
	}
	return self:_addItem(section, item)
end

function Library:_renderColorPicker(parent, item)
	local row = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
	}, parent)

	local lbl = makeInstance("TextLabel", {
		AnchorPoint     = Vector2.new(0, 0.5),
		Position        = UDim2.new(0, 0, 0.5, 0),
		Size            = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text            = item.Name,
		TextColor3      = COLORS.TextLabel,
		TextSize        = 13,
		Font            = Enum.Font.Gotham,
		TextXAlignment  = Enum.TextXAlignment.Left,
	}, row)

	local preview = makeInstance("TextButton", {
		AnchorPoint     = Vector2.new(1, 0.5),
		Position        = UDim2.new(1, 0, 0.5, 0),
		Size            = UDim2.fromOffset(28, 18),
		BackgroundColor3= item.Value,
		Text            = "",
		BorderSizePixel = 0,
	}, row)
	corner(preview, 5)
	stroke(preview, COLORS.DropdownBorder, 1)

	item.Set = function(color)
		item.Value = color
		preview.BackgroundColor3 = color
		pcall(item.Callback, color)
	end
end

function Library:Notify(config)
	config = config or {}
	local title   = config.Title   or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 3

	local screen = self._gui
	local container = screen:FindFirstChild("NotifContainer")
	if not container then
		container = makeInstance("Frame", {
			Name            = "NotifContainer",
			AnchorPoint     = Vector2.new(1, 1),
			Position        = UDim2.new(1, -16, 1, -16),
			Size            = UDim2.new(0, 260, 1, -32),
			BackgroundTransparency = 1,
			ZIndex          = 200,
		}, screen)
		makeInstance("UIListLayout", {
			FillDirection       = Enum.FillDirection.Vertical,
			VerticalAlignment   = Enum.VerticalAlignment.Bottom,
			SortOrder           = Enum.SortOrder.LayoutOrder,
			Padding             = UDim.new(0, 8),
		}, container)
	end

	local notif = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundColor3= COLORS.Section,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex          = 201,
	}, container)
	corner(notif, 8)
	stroke(notif, COLORS.Divider, 1)

	local inner = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex          = 202,
	}, notif)
	padding(inner, 10, 12, 10, 12)
	listLayout(inner, Enum.FillDirection.Vertical, 4)

	local bar = makeInstance("Frame", {
		Size            = UDim2.new(1, 0, 0, 2),
		BackgroundColor3= COLORS.Toggle,
		BorderSizePixel = 0,
		ZIndex          = 203,
	}, inner)
	corner(bar, 1)

	makeInstance("TextLabel", {
		Size            = UDim2.new(1, 0, 0, 0),
		AutomaticSize   = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text            = title,
		TextColor3      = COLORS.TextMain,
		TextSize        = 13,
		Font            = Enum.Font.GothamBold,
		TextXAlignment  = Enum.TextXAlignment.Left,
		TextWrapped     = true,
		ZIndex          = 203,
	}, inner)

	if content ~= "" then
		makeInstance("TextLabel", {
			Size            = UDim2.new(1, 0, 0, 0),
			AutomaticSize   = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text            = content,
			TextColor3      = COLORS.TextDim,
			TextSize        = 12,
			Font            = Enum.Font.Gotham,
			TextXAlignment  = Enum.TextXAlignment.Left,
			TextWrapped     = true,
			ZIndex          = 203,
		}, inner)
	end

	tween(notif, {BackgroundTransparency = 0}, 0.2)
	task.delay(duration, function()
		tween(notif, {BackgroundTransparency = 1}, 0.3)
		for _, v in ipairs(notif:GetDescendants()) do
			if v:IsA("GuiObject") then
				tween(v, {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}, 0.3)
			end
		end
		task.delay(0.35, function() notif:Destroy() end)
	end)
end

function Library:Destroy()
	if self._gui then
		self._gui:Destroy()
	end
end

return Library
