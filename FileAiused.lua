--[[
	MolchunLib - UI Library
	Config system: writefile/readfile/listfiles (exploit env)
	Saves: Toggles, Sliders, Dropdowns, Inputs, ColorPickers
	Usage:
		local Library = loadstring(game:HttpGet("..."))()
		local win = Library.new({
			Title        = "My Hub",
			Image        = "rbxassetid://...",
			ConfigFolder = "MyHub",
		})
		win:LoadNow()
		local tab = win:AddTab({ Name = "Combat", Icon = "rbxassetid://..." })
		local sec = win:AddSection(tab, { Name = "Aimbot" })
		win:MakeToggle(sec, { Name = "Enable", Default = false, Flag = "AimbotEnable", Callback = function(v) end })
		win:MakeSlider(sec, { Name = "FOV", Min=1, Max=360, Default=90, Flag="AimbotFOV", Callback = function(v) end })
		win:InitConfig()  -- call AFTER all elements
]]

local Library = {}
Library.__index = Library

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

local DEFAULT_IMAGE  = "rbxassetid://7072706960"
local DEFAULT_FOLDER = "MolchunHub"

local COLORS = {
	Background     = Color3.fromRGB(18, 18, 20),
	Sidebar        = Color3.fromRGB(22, 22, 26),
	SidebarActive  = Color3.fromRGB(30, 30, 36),
	Panel          = Color3.fromRGB(26, 26, 30),
	Section        = Color3.fromRGB(30, 30, 36),
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
	Danger         = Color3.fromRGB(220, 70, 70),
}

-- ──────────────────────────────────────────────
-- Helpers
-- ──────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(
		t or 0.18,
		style or Enum.EasingStyle.Quad,
		dir   or Enum.EasingDirection.Out
	), props):Play()
end

local function make(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	inst.Parent = parent
	return inst
end

local function corner(p, r)
	make("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function stroke(p, c, t)
	make("UIStroke", { Color = c or COLORS.Divider, Thickness = t or 1 }, p)
end

local function pad(p, top, right, bot, left)
	make("UIPadding", {
		PaddingTop    = UDim.new(0, top   or 8),
		PaddingRight  = UDim.new(0, right or 8),
		PaddingBottom = UDim.new(0, bot   or 8),
		PaddingLeft   = UDim.new(0, left  or 8),
	}, p)
end

local function vlist(p, spacing)
	make("UIListLayout", {
		FillDirection       = Enum.FillDirection.Vertical,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		Padding             = UDim.new(0, spacing or 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
	}, p)
end

local function draggable(frame, handle)
	handle = handle or frame
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = i.Position
			startPos  = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- ──────────────────────────────────────────────
-- File system (exploit environment APIs)
-- ──────────────────────────────────────────────
local FS = {}

function FS.ensureFolder(path)
	if not isfolder(path) then
		pcall(makefolder, path)
	end
end

function FS.write(path, data)
	pcall(writefile, path, data)
end

function FS.read(path)
	local ok, data = pcall(readfile, path)
	return ok and data or nil
end

function FS.list(path)
	local ok, files = pcall(listfiles, path)
	return ok and files or {}
end

function FS.delete(path)
	pcall(delfile, path)
end

-- ──────────────────────────────────────────────
-- JSON encode/decode (uses HttpService internally)
-- ──────────────────────────────────────────────
local function jsonEncode(val)
	local t = type(val)
	if t == "nil"     then return "null"
	elseif t == "boolean" then return tostring(val)
	elseif t == "number"  then return tostring(val)
	elseif t == "string"  then
		return '"' .. val
			:gsub('\\', '\\\\')
			:gsub('"',  '\\"')
			:gsub('\n', '\\n')
			:gsub('\r', '\\r')
			:gsub('\t', '\\t') .. '"'
	elseif t == "table" then
		local isArr = (#val > 0)
		local parts = {}
		if isArr then
			for _, v in ipairs(val) do
				parts[#parts + 1] = jsonEncode(v)
			end
			return "[" .. table.concat(parts, ",") .. "]"
		else
			for k, v in pairs(val) do
				parts[#parts + 1] = '"' .. tostring(k) .. '":' .. jsonEncode(v)
			end
			return "{" .. table.concat(parts, ",") .. "}"
		end
	end
	return "null"
end

local function jsonDecode(s)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s)
	return ok and result or nil
end

-- ──────────────────────────────────────────────
-- Library.new
-- ──────────────────────────────────────────────
function Library.new(config)
	config = config or {}
	local self           = setmetatable({}, Library)
	self.Title           = config.Title        or "Hub"
	self.Image           = config.Image        or DEFAULT_IMAGE
	self.ConfigFolder    = config.ConfigFolder or DEFAULT_FOLDER
	self.Tabs            = {}
	self.ActiveTab       = nil
	self.Minimized       = false
	self._loaded         = false
	self._loadNow        = false
	self._flags          = {}
	self._configInited   = false

	self._rootPath    = self.ConfigFolder
	self._configsPath = self.ConfigFolder .. "/configs"

	self._gui = make("ScreenGui", {
		Name           = "MolchunLib",
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	}, RunService:IsStudio()
		and LocalPlayer:WaitForChild("PlayerGui")
		or  game:GetService("CoreGui"))

	self:_buildLoading()
	self:_scheduleLoad()
	return self
end

-- ──────────────────────────────────────────────
-- Loading screen
-- ──────────────────────────────────────────────
function Library:_buildLoading()
	local overlay = make("Frame", {
		Name             = "LoadOverlay",
		Size             = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		ZIndex           = 100,
	}, self._gui)

	make("ImageLabel", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image                = "rbxassetid://5699893404",
		ImageColor3          = Color3.fromRGB(0, 0, 0),
		ImageTransparency    = 0.2,
		ScaleType            = Enum.ScaleType.Stretch,
		ZIndex               = 101,
	}, overlay)

	local holder = make("Frame", {
		AnchorPoint          = Vector2.new(0.5, 0.5),
		Position             = UDim2.fromScale(0.5, 0.5),
		Size                 = UDim2.fromOffset(0, 0),
		BackgroundColor3     = Color3.fromRGB(25, 25, 30),
		BackgroundTransparency = 1,
		ZIndex               = 102,
	}, overlay)
	corner(holder, 24)
	stroke(holder, Color3.fromRGB(60, 60, 75), 1.5)

	local img = make("ImageLabel", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image                = self.Image,
		ScaleType            = Enum.ScaleType.Fit,
		ZIndex               = 103,
	}, holder)
	corner(img, 24)

	tween(holder,
		{ Size = UDim2.fromOffset(140, 140), BackgroundTransparency = 0 },
		0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	self._loadOverlay = overlay
end

function Library:_scheduleLoad()
	task.spawn(function()
		local e = 0
		while e < 2 do
			if self._loadNow then break end
			e = e + task.wait(0.05)
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
	tween(self._loadOverlay, { BackgroundTransparency = 1 }, 0.4)
	for _, v in ipairs(self._loadOverlay:GetDescendants()) do
		if v:IsA("GuiObject") then
			tween(v, { BackgroundTransparency = 1, ImageTransparency = 1 }, 0.4)
		end
	end
	task.delay(0.45, function()
		self._loadOverlay:Destroy()
		self:_buildMain()
	end)
end

-- ──────────────────────────────────────────────
-- Main window
-- ──────────────────────────────────────────────
function Library:_buildMain()
	local SIDE_EXP = 160
	local SIDE_COL = 48
	local WIN_W    = 580
	local WIN_H    = 420

	local win = make("Frame", {
		Name             = "MainWindow",
		AnchorPoint      = Vector2.new(0.5, 0.5),
		Position         = UDim2.fromScale(0.5, 0.5),
		Size             = UDim2.fromOffset(0, 0),
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, self._gui)
	corner(win, 10)
	stroke(win, Color3.fromRGB(45, 45, 55), 1)
	tween(win,
		{ Size = UDim2.fromOffset(WIN_W, WIN_H), BackgroundTransparency = 0 },
		0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	draggable(win)

	-- sidebar
	local sidebar = make("Frame", {
		Name             = "Sidebar",
		Size             = UDim2.new(0, SIDE_EXP, 1, 0),
		BackgroundColor3 = COLORS.Sidebar,
	}, win)

	-- sidebar top bar
	local sideTop = make("Frame", {
		Name = "SideTop", Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1,
	}, sidebar)

	local logoImg = make("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1,
		Image = self.Image, ScaleType = Enum.ScaleType.Fit,
	}, sideTop)
	corner(logoImg, 6)

	local titleLabel = make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 44, 0.5, 0),
		Size = UDim2.new(1, -54, 0, 20), BackgroundTransparency = 1,
		Text = self.Title, TextColor3 = COLORS.TextMain,
		TextSize = 14, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, sideTop)

	make("Frame", {
		Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = COLORS.Divider, BorderSizePixel = 0,
	}, sideTop)

	-- tab scroll area
	local tabScroll = make("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 51),
		Size     = UDim2.new(1, 0, 1, -100),
		BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, sidebar)
	pad(tabScroll, 6, 0, 6, 0)
	vlist(tabScroll, 2)

	-- sidebar bottom (user info + minimize)
	local sideBottom = make("Frame", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1,
	}, sidebar)

	make("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = COLORS.Divider, BorderSizePixel = 0,
	}, sideBottom)

	local avatarImg = make("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1,
		Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
			.. LocalPlayer.UserId .. "&width=150&height=150&format=png",
	}, sideBottom)
	corner(avatarImg, 13)

	local userLabel = make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 44, 0.5, 0),
		Size = UDim2.new(1, -60, 0, 16), BackgroundTransparency = 1,
		Text = LocalPlayer.Name, TextColor3 = COLORS.TextDim,
		TextSize = 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	}, sideBottom)

	local minimizeBtn = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(22, 22), BackgroundColor3 = COLORS.Section,
		Text = "«", TextColor3 = COLORS.TextDim,
		TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
	}, sideBottom)
	corner(minimizeBtn, 6)

	-- content area
	local content = make("Frame", {
		Name = "Content",
		Position = UDim2.new(0, SIDE_EXP, 0, 0),
		Size     = UDim2.new(1, -SIDE_EXP, 1, 0),
		BackgroundColor3 = COLORS.Panel, BorderSizePixel = 0,
	}, win)

	local contentScroll = make("ScrollingFrame", {
		Name = "ContentScroll", Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75),
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, content)
	pad(contentScroll, 10, 10, 10, 10)
	vlist(contentScroll, 8)

	-- store refs
	self._tabContainer  = tabScroll
	self._contentScroll = contentScroll
	self._contentParent = contentScroll
	self._sidebar       = sidebar
	self._titleLabel    = titleLabel
	self._userLabel     = userLabel
	self._win           = win
	self._minimizeBtn   = minimizeBtn
	self._content       = content
	self._SIDE_EXP      = SIDE_EXP
	self._SIDE_COL      = SIDE_COL

	minimizeBtn.MouseButton1Click:Connect(function() self:_toggleMinimize() end)

	for _, tab in ipairs(self.Tabs) do self:_renderTab(tab) end
	if self.Tabs[1] then self:_selectTab(self.Tabs[1]) end
end

function Library:_toggleMinimize()
	self.Minimized = not self.Minimized
	local exp = self._SIDE_EXP
	local col = self._SIDE_COL
	if self.Minimized then
		tween(self._sidebar, { Size = UDim2.new(0, col, 1, 0) }, 0.22)
		tween(self._content, { Position = UDim2.new(0, col, 0, 0), Size = UDim2.new(1, -col, 1, 0) }, 0.22)
		tween(self._titleLabel, { TextTransparency = 1 }, 0.1)
		tween(self._userLabel,  { TextTransparency = 1 }, 0.1)
		self._minimizeBtn.Text = "»"
	else
		tween(self._sidebar, { Size = UDim2.new(0, exp, 1, 0) }, 0.22)
		tween(self._content, { Position = UDim2.new(0, exp, 0, 0), Size = UDim2.new(1, -exp, 1, 0) }, 0.22)
		tween(self._titleLabel, { TextTransparency = 0 }, 0.2)
		tween(self._userLabel,  { TextTransparency = 0 }, 0.2)
		self._minimizeBtn.Text = "«"
	end
end

-- ──────────────────────────────────────────────
-- Tabs
-- ──────────────────────────────────────────────
function Library:AddTab(config)
	config = config or {}
	local tab = {
		Name     = config.Name or "Tab",
		Icon     = config.Icon or DEFAULT_IMAGE,
		Sections = {},
	}
	table.insert(self.Tabs, tab)
	if self._tabContainer then
		self:_renderTab(tab)
		if #self.Tabs == 1 then self:_selectTab(tab) end
	end
	return tab
end

function Library:_renderTab(tab)
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = COLORS.Sidebar, BackgroundTransparency = 1,
		Text = "", BorderSizePixel = 0,
	}, self._tabContainer)
	corner(btn, 7)

	local iconImg = make("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
		Image = tab.Icon, ImageColor3 = COLORS.TextDim,
	}, btn)

	local lbl = make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 38, 0.5, 0),
		Size = UDim2.new(1, -48, 0, 20), BackgroundTransparency = 1,
		Text = tab.Name, TextColor3 = COLORS.TextDim,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, btn)

	local indicator = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.fromOffset(3, 18), BackgroundColor3 = COLORS.Toggle,
		BackgroundTransparency = 1, BorderSizePixel = 0,
	}, btn)
	corner(indicator, 2)

	tab._btn       = btn
	tab._icon      = iconImg
	tab._label     = lbl
	tab._indicator = indicator

	btn.MouseButton1Click:Connect(function() self:_selectTab(tab) end)
	btn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			btn.BackgroundColor3 = COLORS.SidebarActive
			tween(btn, { BackgroundTransparency = 0.85 }, 0.12)
		end
	end)
	btn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			tween(btn, { BackgroundTransparency = 1 }, 0.12)
		end
	end)
end

function Library:_selectTab(tab)
	if self.ActiveTab then
		local p = self.ActiveTab
		tween(p._btn,       { BackgroundTransparency = 1 }, 0.15)
		tween(p._label,     { TextColor3 = COLORS.TextDim }, 0.15)
		tween(p._icon,      { ImageColor3 = COLORS.TextDim }, 0.15)
		tween(p._indicator, { BackgroundTransparency = 1 }, 0.15)
		for _, s in ipairs(p.Sections) do
			if s._frame then s._frame.Visible = false end
		end
	end
	self.ActiveTab = tab
	tween(tab._btn,       { BackgroundTransparency = 0.82 }, 0.15)
	tab._btn.BackgroundColor3 = COLORS.SidebarActive
	tween(tab._label,     { TextColor3 = COLORS.TextMain }, 0.15)
	tween(tab._icon,      { ImageColor3 = COLORS.Toggle }, 0.15)
	tween(tab._indicator, { BackgroundTransparency = 0 }, 0.15)
	for _, s in ipairs(tab.Sections) do
		if s._frame then s._frame.Visible = true end
	end
end

-- ──────────────────────────────────────────────
-- Sections
-- ──────────────────────────────────────────────
function Library:AddSection(tab, config)
	config = config or {}
	local section = {
		Name     = config.Name or "Section",
		Tab      = tab,
		Expanded = true,
		Items    = {},
	}
	table.insert(tab.Sections, section)
	if self._contentParent then self:_renderSection(section) end
	return section
end

function Library:_renderSection(section)
	local frame = make("Frame", {
		Name             = section.Name,
		Size             = UDim2.new(1, 0, 0, 0),
		AutomaticSize    = Enum.AutomaticSize.Y,
		BackgroundColor3 = COLORS.Section,
		BorderSizePixel  = 0,
		Visible          = (self.ActiveTab == section.Tab),
	}, self._contentParent)
	corner(frame, 8)
	stroke(frame, COLORS.Divider, 1)

	local header = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1, Text = "", BorderSizePixel = 0,
	}, frame)

	make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
		Size = UDim2.new(1, -50, 0, 18), BackgroundTransparency = 1,
		Text = section.Name, TextColor3 = COLORS.TextDim,
		TextSize = 12, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, header)

	local chevron = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
		Text = "v", TextColor3 = COLORS.TextDim,
		TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
	}, header)

	local divider = make("Frame", {
		Position = UDim2.new(0, 14, 0, 35), Size = UDim2.new(1, -28, 0, 1),
		BackgroundColor3 = COLORS.Divider, BorderSizePixel = 0,
	}, frame)

	local body = make("Frame", {
		Name = "Body", Position = UDim2.new(0, 0, 0, 36),
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, ClipsDescendants = false,
	}, frame)
	pad(body, 8, 12, 10, 12)
	vlist(body, 8)

	section._frame   = frame
	section._body    = body
	section._chevron = chevron
	section._divider = divider

	header.MouseButton1Click:Connect(function()
		section.Expanded = not section.Expanded
		body.Visible     = section.Expanded
		divider.Visible  = section.Expanded
		chevron.Text     = section.Expanded and "v" or ">"
	end)

	for _, item in ipairs(section.Items) do
		self:_renderItem(section, item)
	end
end

function Library:_renderItem(section, item)
	local b = section._body
	if     item.Type == "Toggle"      then self:_renderToggle(b, item)
	elseif item.Type == "Slider"      then self:_renderSlider(b, item)
	elseif item.Type == "Dropdown"    then self:_renderDropdown(b, item)
	elseif item.Type == "Input"       then self:_renderInput(b, item)
	elseif item.Type == "Button"      then self:_renderButton(b, item)
	elseif item.Type == "Paragraph"   then self:_renderParagraph(b, item)
	elseif item.Type == "ColorPicker" then self:_renderColorPicker(b, item)
	elseif item.Type == "ConfigEntry" then self:_renderConfigEntry(b, item)
	end
end

function Library:_addItem(section, item)
	table.insert(section.Items, item)
	if item.Flag and item.Flag ~= "" then
		self._flags[item.Flag] = item
	end
	if section._body then self:_renderItem(section, item) end
	return item
end

-- ──────────────────────────────────────────────
-- Toggle
-- ──────────────────────────────────────────────
function Library:MakeToggle(section, config)
	config = config or {}
	local item = {
		Type     = "Toggle",
		Name     = config.Name     or "Toggle",
		Default  = config.Default  or false,
		Flag     = config.Flag     or "",
		Callback = config.Callback or function() end,
		Value    = config.Default  or false,
	}
	return self:_addItem(section, item)
end

function Library:_renderToggle(parent, item)
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, parent)

	make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, -52, 1, 0), BackgroundTransparency = 1,
		Text = item.Name, TextColor3 = COLORS.TextLabel,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local track = make("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(42, 22),
		BackgroundColor3 = item.Value and COLORS.Toggle or COLORS.ToggleOff,
		BorderSizePixel = 0,
	}, row)
	corner(track, 11)

	local knob = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position    = item.Value and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size        = UDim2.fromOffset(18, 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel  = 0,
	}, track)
	corner(knob, 9)

	local function setVal(val, silent)
		item.Value = val
		tween(track, { BackgroundColor3 = val and COLORS.Toggle or COLORS.ToggleOff }, 0.15)
		tween(knob,  { Position = val and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }, 0.15)
		if not silent then pcall(item.Callback, val) end
	end

	local hit = make("TextButton", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		Text = "", ZIndex = track.ZIndex + 5,
	}, track)
	hit.MouseButton1Click:Connect(function() setVal(not item.Value) end)

	item.Set = setVal
end

-- ──────────────────────────────────────────────
-- Slider
-- ──────────────────────────────────────────────
function Library:MakeSlider(section, config)
	config = config or {}
	local item = {
		Type     = "Slider",
		Name     = config.Name     or "Slider",
		Min      = config.Min      or 0,
		Max      = config.Max      or 100,
		Default  = config.Default  or 0,
		Decimals = config.Decimals or 0,
		Suffix   = config.Suffix   or "",
		Flag     = config.Flag     or "",
		Callback = config.Callback or function() end,
		Value    = config.Default  or 0,
	}
	return self:_addItem(section, item)
end

function Library:_renderSlider(parent, item)
	local wrap   = make("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1 }, parent)
	local topRow = make("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1 }, wrap)

	make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1,
		Text = item.Name, TextColor3 = COLORS.TextLabel,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, topRow)

	local valLabel = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0.3, 0, 1, 0), BackgroundTransparency = 1,
		Text = tostring(item.Value) .. item.Suffix, TextColor3 = COLORS.TextDim,
		TextSize = 12, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, topRow)

	local track = make("Frame", {
		Position = UDim2.new(0, 0, 0, 26), Size = UDim2.new(1, 0, 0, 5),
		BackgroundColor3 = COLORS.SliderTrack, BorderSizePixel = 0,
	}, wrap)
	corner(track, 3)

	local pct  = math.clamp((item.Value - item.Min) / (item.Max - item.Min), 0, 1)
	local mult = 10 ^ item.Decimals

	local fill = make("Frame", {
		Size = UDim2.new(pct, 0, 1, 0),
		BackgroundColor3 = COLORS.Slider, BorderSizePixel = 0,
	}, track)
	corner(fill, 3)

	local thumb = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(pct, 0, 0.5, 0),
		Size = UDim2.fromOffset(13, 13), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0, ZIndex = track.ZIndex + 2,
	}, track)
	corner(thumb, 7)

	local dragging = false

	local function update(mouseX, silent)
		local rel = math.clamp(
			(mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		item.Value     = math.round((item.Min + rel * (item.Max - item.Min)) * mult) / mult
		fill.Size      = UDim2.new(rel, 0, 1, 0)
		thumb.Position = UDim2.new(rel, 0, 0.5, 0)
		valLabel.Text  = tostring(item.Value) .. item.Suffix
		if not silent then pcall(item.Callback, item.Value) end
	end

	local hit = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, -6),
		BackgroundTransparency = 1, Text = "", ZIndex = track.ZIndex + 3,
	}, track)

	hit.MouseButton1Down:Connect(function()
		dragging = true
		update(UserInputService:GetMouseLocation().X)
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			update(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	item.Set = function(val, silent)
		item.Value = math.clamp(val, item.Min, item.Max)
		local r    = (item.Value - item.Min) / (item.Max - item.Min)
		fill.Size      = UDim2.new(r, 0, 1, 0)
		thumb.Position = UDim2.new(r, 0, 0.5, 0)
		valLabel.Text  = tostring(item.Value) .. item.Suffix
		if not silent then pcall(item.Callback, item.Value) end
	end
end

-- ──────────────────────────────────────────────
-- Dropdown
-- ──────────────────────────────────────────────
function Library:MakeDropdown(section, config)
	config = config or {}
	local item = {
		Type     = "Dropdown",
		Name     = config.Name    or "Dropdown",
		Options  = config.Options or {},
		Default  = config.Default,
		Flag     = config.Flag    or "",
		Callback = config.Callback or function() end,
		Value    = config.Default or (config.Options and config.Options[1]),
	}
	return self:_addItem(section, item)
end

function Library:_renderDropdown(parent, item)
	local wrap = make("Frame", {
		Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1,
		ClipsDescendants = false, ZIndex = 5,
	}, parent)

	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
		Text = item.Name, TextColor3 = COLORS.TextLabel,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, wrap)

	local box = make("TextButton", {
		Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = COLORS.Dropdown, Text = "", BorderSizePixel = 0,
		ClipsDescendants = false, ZIndex = 6,
	}, wrap)
	corner(box, 6)
	stroke(box, COLORS.DropdownBorder, 1)

	local selLabel = make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1,
		Text = tostring(item.Value or "Select..."), TextColor3 = COLORS.TextMain,
		TextSize = 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
	}, box)

	make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
		Text = "v", TextColor3 = COLORS.TextDim,
		TextSize = 11, Font = Enum.Font.GothamBold, ZIndex = 7,
	}, box)

	local dropdown = make("Frame", {
		Position = UDim2.new(0, 0, 1, 4), Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = COLORS.Dropdown, Visible = false,
		ClipsDescendants = true, ZIndex = 20,
	}, box)
	corner(dropdown, 6)
	stroke(dropdown, COLORS.DropdownBorder, 1)

	local optList = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, ZIndex = 21,
	}, dropdown)
	pad(optList, 4, 0, 4, 0)
	vlist(optList, 2)

	local open = false
	local function targetH() return math.min(#item.Options * 28 + 8, 120) end

	local function buildOptions()
		for _, c in ipairs(optList:GetChildren()) do
			if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
		end
		for _, opt in ipairs(item.Options) do
			local ob = make("TextButton", {
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundColor3 = COLORS.Dropdown, BackgroundTransparency = 1,
				Text = tostring(opt),
				TextColor3 = (opt == item.Value) and COLORS.TextMain or COLORS.TextDim,
				TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0, ZIndex = 22,
			}, optList)
			ob.MouseEnter:Connect(function()
				tween(ob, { BackgroundTransparency = 0.7, BackgroundColor3 = COLORS.SidebarActive }, 0.1)
				tween(ob, { TextColor3 = COLORS.TextMain }, 0.1)
			end)
			ob.MouseLeave:Connect(function()
				tween(ob, { BackgroundTransparency = 1 }, 0.1)
				if opt ~= item.Value then tween(ob, { TextColor3 = COLORS.TextDim }, 0.1) end
			end)
			ob.MouseButton1Click:Connect(function()
				item.Value    = opt
				selLabel.Text = tostring(opt)
				pcall(item.Callback, opt)
				open = false
				tween(dropdown, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
				task.delay(0.16, function() dropdown.Visible = false end)
				buildOptions()
			end)
		end
	end
	buildOptions()

	box.MouseButton1Click:Connect(function()
		open = not open
		if open then
			dropdown.Visible = true
			tween(dropdown, { Size = UDim2.new(1, 0, 0, targetH()) }, 0.18)
		else
			tween(dropdown, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
			task.delay(0.16, function() dropdown.Visible = false end)
		end
	end)

	item.Set = function(val, silent)
		item.Value    = val
		selLabel.Text = tostring(val)
		buildOptions()
		if not silent then pcall(item.Callback, val) end
	end
	item.AddOption = function(opt)
		table.insert(item.Options, opt)
		buildOptions()
	end
end

-- ──────────────────────────────────────────────
-- Input
-- ──────────────────────────────────────────────
function Library:MakeInput(section, config)
	config = config or {}
	local item = {
		Type        = "Input",
		Name        = config.Name        or "Input",
		Placeholder = config.Placeholder or "...",
		Default     = config.Default     or "",
		Flag        = config.Flag        or "",
		Callback    = config.Callback    or function() end,
		Value       = config.Default     or "",
	}
	return self:_addItem(section, item)
end

function Library:_renderInput(parent, item)
	local wrap = make("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 }, parent)

	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
		Text = item.Name, TextColor3 = COLORS.TextLabel,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, wrap)

	local inputBox = make("Frame", {
		Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = COLORS.Input, BorderSizePixel = 0,
	}, wrap)
	corner(inputBox, 6)
	stroke(inputBox, COLORS.InputBorder, 1)

	local tb = make("TextBox", {
		Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1, Text = item.Default,
		PlaceholderText = item.Placeholder, PlaceholderColor3 = COLORS.TextDim,
		TextColor3 = COLORS.TextMain, TextSize = 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, BorderSizePixel = 0,
	}, inputBox)

	tb.FocusLost:Connect(function(enter)
		item.Value = tb.Text
		pcall(item.Callback, tb.Text, enter)
	end)
	tb.Focused:Connect(function()
		tween(inputBox, { BackgroundColor3 = COLORS.SidebarActive }, 0.12)
	end)
	tb.FocusLost:Connect(function()
		tween(inputBox, { BackgroundColor3 = COLORS.Input }, 0.12)
	end)

	item.Set = function(val, silent)
		item.Value = val
		tb.Text    = val
		if not silent then pcall(item.Callback, val) end
	end
	item.Get = function() return tb.Text end
end

-- ──────────────────────────────────────────────
-- Button
-- ──────────────────────────────────────────────
function Library:MakeButton(section, config)
	config = config or {}
	local item = {
		Type     = "Button",
		Name     = config.Name     or "Button",
		Callback = config.Callback or function() end,
	}
	return self:_addItem(section, item)
end

function Library:_renderButton(parent, item)
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(45, 45, 58),
		Text = item.Name, TextColor3 = COLORS.TextMain,
		TextSize = 13, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
	}, parent)
	corner(btn, 7)
	stroke(btn, Color3.fromRGB(60, 60, 75), 1)

	btn.MouseButton1Click:Connect(function()
		tween(btn, { BackgroundColor3 = COLORS.Toggle }, 0.08)
		task.delay(0.15, function()
			tween(btn, { BackgroundColor3 = Color3.fromRGB(45, 45, 58) }, 0.15)
		end)
		pcall(item.Callback)
	end)
	btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = Color3.fromRGB(55, 55, 68) }, 0.1) end)
	btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = Color3.fromRGB(45, 45, 58) }, 0.1) end)
end

-- ──────────────────────────────────────────────
-- Paragraph
-- ──────────────────────────────────────────────
function Library:MakeParagraph(section, config)
	config = config or {}
	local item = {
		Type    = "Paragraph",
		Title   = config.Title   or "",
		Content = config.Content or "",
	}
	return self:_addItem(section, item)
end

function Library:_renderParagraph(parent, item)
	local wrap = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, parent)
	vlist(wrap, 4)
	if item.Title ~= "" then
		make("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1, Text = item.Title, TextColor3 = COLORS.TextMain,
			TextSize = 13, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
		}, wrap)
	end
	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, Text = item.Content, TextColor3 = COLORS.TextDim,
		TextSize = 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
	}, wrap)
end

-- ──────────────────────────────────────────────
-- ColorPicker (preview swatch, no full picker yet)
-- ──────────────────────────────────────────────
function Library:MakeColorPicker(section, config)
	config = config or {}
	local item = {
		Type     = "ColorPicker",
		Name     = config.Name    or "Color",
		Default  = config.Default or Color3.fromRGB(255, 80, 80),
		Flag     = config.Flag    or "",
		Callback = config.Callback or function() end,
		Value    = config.Default or Color3.fromRGB(255, 80, 80),
	}
	return self:_addItem(section, item)
end

function Library:_renderColorPicker(parent, item)
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, parent)

	make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1,
		Text = item.Name, TextColor3 = COLORS.TextLabel,
		TextSize = 13, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local preview = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(28, 18), BackgroundColor3 = item.Value,
		Text = "", BorderSizePixel = 0,
	}, row)
	corner(preview, 5)
	stroke(preview, COLORS.DropdownBorder, 1)

	item.Set = function(color, silent)
		item.Value = color
		preview.BackgroundColor3 = color
		if not silent then pcall(item.Callback, color) end
	end
end

-- ──────────────────────────────────────────────
-- Config system
-- ──────────────────────────────────────────────
function Library:_ensureFolders()
	FS.ensureFolder(self._rootPath)
	FS.ensureFolder(self._configsPath)
end

function Library:_configPath(name)
	return self._configsPath .. "/" .. name .. ".json"
end

-- Collect all flagged values into a plain table
function Library:_collectValues()
	local data = {}
	for flag, item in pairs(self._flags) do
		if     item.Type == "Toggle"   then data[flag] = item.Value
		elseif item.Type == "Slider"   then data[flag] = item.Value
		elseif item.Type == "Dropdown" then data[flag] = item.Value
		elseif item.Type == "Input"    then data[flag] = item.Value
		elseif item.Type == "ColorPicker" then
			local c = item.Value
			data[flag] = { r = c.R, g = c.G, b = c.B }
		end
	end
	return data
end

-- Apply a plain table back to all flagged items
function Library:_applyValues(data)
	for flag, val in pairs(data) do
		local item = self._flags[flag]
		if item and item.Set then
			if item.Type == "ColorPicker" and type(val) == "table" then
				item.Set(Color3.new(
					tonumber(val.r) or 1,
					tonumber(val.g) or 1,
					tonumber(val.b) or 1
				), false)
			else
				item.Set(val, false)
			end
		end
	end
end

-- Public: Save a named config to disk
function Library:SaveConfig(name)
	name = (name ~= "" and name) or "default"
	self:_ensureFolders()
	FS.write(self:_configPath(name), jsonEncode(self:_collectValues()))
	self:Notify({ Title = "Config Saved", Content = '"' .. name .. '" saved.', Duration = 2.5 })
end

-- Public: Load a named config from disk and apply it
function Library:LoadConfig(name)
	local raw = FS.read(self:_configPath(name))
	if not raw then
		self:Notify({ Title = "Config Error", Content = '"' .. name .. '" not found.', Duration = 2.5 })
		return false
	end
	local data = jsonDecode(raw)
	if not data then
		self:Notify({ Title = "Config Error", Content = 'Parse failed: "' .. name .. '".', Duration = 2.5 })
		return false
	end
	self:_applyValues(data)
	self:Notify({ Title = "Config Loaded", Content = '"' .. name .. '" loaded.', Duration = 2.5 })
	return true
end

-- Public: Delete a named config from disk
function Library:DeleteConfig(name)
	FS.delete(self:_configPath(name))
	self:Notify({ Title = "Config Deleted", Content = '"' .. name .. '" deleted.', Duration = 2.5 })
end

-- Public: Returns list of saved config names (without .json)
function Library:ListConfigs()
	self:_ensureFolders()
	local names = {}
	for _, f in ipairs(FS.list(self._configsPath)) do
		local n = f:match("([^/\\]+)%.json$")
		if n then table.insert(names, n) end
	end
	return names
end

-- ──────────────────────────────────────────────
-- InitConfig — auto-builds the Config tab
-- Call this AFTER all your elements are registered
-- ──────────────────────────────────────────────
function Library:InitConfig(tabConfig)
	if self._configInited then return end
	self._configInited = true
	tabConfig = tabConfig or {}

	self:_ensureFolders()

	local tab = self:AddTab({
		Name = tabConfig.Name or "Config",
		Icon = tabConfig.Icon or DEFAULT_IMAGE,
	})

	-- ── Manager section ────────────────────────
	local mgrSec = self:AddSection(tab, { Name = "Config Manager" })

	local nameInput = self:MakeInput(mgrSec, {
		Name        = "Config Name",
		Placeholder = "my_config",
		Default     = "",
	})

	-- save
	self:MakeButton(mgrSec, {
		Name = "💾  Save Config",
		Callback = function()
			local n = (nameInput.Value ~= "") and nameInput.Value or "default"
			self:SaveConfig(n)
			self:_refreshConfigList()
		end,
	})

	-- refresh list
	self:MakeButton(mgrSec, {
		Name = "🔄  Refresh List",
		Callback = function() self:_refreshConfigList() end,
	})

	-- ── Saved configs section ──────────────────
	local listSec = self:AddSection(tab, { Name = "Saved Configs" })
	self._configListSec = listSec

	-- populate on next frame (UI may not exist yet)
	task.defer(function() self:_refreshConfigList() end)
end

-- Clears and rebuilds the Saved Configs section
function Library:_refreshConfigList()
	local section = self._configListSec
	if not section then return end

	-- wipe existing rendered children
	if section._body then
		for _, child in ipairs(section._body:GetChildren()) do
			if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
				child:Destroy()
			end
		end
	end
	section.Items = {}

	local configs = self:ListConfigs()

	if #configs == 0 then
		self:MakeParagraph(section, {
			Content = "No configs saved yet.",
		})
		return
	end

	for _, name in ipairs(configs) do
		self:_addConfigEntryItem(section, name)
	end
end

-- Adds a single config row item to a section
function Library:_addConfigEntryItem(section, name)
	local item = { Type = "ConfigEntry", ConfigName = name }
	table.insert(section.Items, item)
	if section._body then
		self:_renderConfigEntry(section._body, item)
	end
end

-- Renders a config entry row (name label + Load + Delete)
function Library:_renderConfigEntry(parent, item)
	local name = item.ConfigName

	local row = make("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = COLORS.Background, BorderSizePixel = 0,
	}, parent)
	corner(row, 7)
	stroke(row, COLORS.Divider, 1)

	make("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(1, -96, 1, 0), BackgroundTransparency = 1,
		Text = name, TextColor3 = COLORS.TextLabel,
		TextSize = 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	}, row)

	local loadBtn = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -48, 0.5, 0),
		Size = UDim2.fromOffset(40, 22), BackgroundColor3 = COLORS.Toggle,
		Text = "Load", TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 11, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
	}, row)
	corner(loadBtn, 5)

	local delBtn = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0),
		Size = UDim2.fromOffset(40, 22), BackgroundColor3 = COLORS.Danger,
		Text = "Del", TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 11, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
	}, row)
	corner(delBtn, 5)

	loadBtn.MouseButton1Click:Connect(function()
		self:LoadConfig(name)
	end)

	delBtn.MouseButton1Click:Connect(function()
		self:DeleteConfig(name)
		row:Destroy()
	end)

	loadBtn.MouseEnter:Connect(function() tween(loadBtn, { BackgroundColor3 = Color3.fromRGB(60, 130, 220) }, 0.1) end)
	loadBtn.MouseLeave:Connect(function() tween(loadBtn, { BackgroundColor3 = COLORS.Toggle }, 0.1) end)
	delBtn.MouseEnter:Connect(function()  tween(delBtn,  { BackgroundColor3 = Color3.fromRGB(200, 50, 50) }, 0.1) end)
	delBtn.MouseLeave:Connect(function()  tween(delBtn,  { BackgroundColor3 = COLORS.Danger }, 0.1) end)
end

-- ──────────────────────────────────────────────
-- Notifications
-- ──────────────────────────────────────────────
function Library:Notify(config)
	config = config or {}
	local title    = config.Title    or "Notification"
	local content  = config.Content  or ""
	local duration = config.Duration or 3

	local container = self._gui:FindFirstChild("NotifContainer")
	if not container then
		container = make("Frame", {
			Name = "NotifContainer",
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
			Size = UDim2.new(0, 260, 1, -32),
			BackgroundTransparency = 1, ZIndex = 200,
		}, self._gui)
		make("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Padding           = UDim.new(0, 8),
		}, container)
	end

	local notif = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = COLORS.Section, BorderSizePixel = 0,
		BackgroundTransparency = 1, ZIndex = 201,
	}, container)
	corner(notif, 8)
	stroke(notif, COLORS.Divider, 1)

	local inner = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, ZIndex = 202,
	}, notif)
	pad(inner, 10, 12, 10, 12)
	vlist(inner, 4)

	local bar = make("Frame", {
		Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = COLORS.Toggle,
		BorderSizePixel = 0, ZIndex = 203,
	}, inner)
	corner(bar, 1)

	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, Text = title, TextColor3 = COLORS.TextMain,
		TextSize = 13, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 203,
	}, inner)

	if content ~= "" then
		make("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1, Text = content, TextColor3 = COLORS.TextDim,
			TextSize = 12, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 203,
		}, inner)
	end

	tween(notif, { BackgroundTransparency = 0 }, 0.2)
	task.delay(duration, function()
		tween(notif, { BackgroundTransparency = 1 }, 0.3)
		for _, v in ipairs(notif:GetDescendants()) do
			if v:IsA("GuiObject") then
				tween(v, { BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1 }, 0.3)
			end
		end
		task.delay(0.35, function() notif:Destroy() end)
	end)
end

-- ──────────────────────────────────────────────
function Library:Destroy()
	if self._gui then self._gui:Destroy() end
end

return Library
