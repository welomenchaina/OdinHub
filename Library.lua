-- made by @hydrox.developer on Discord | https://discord.com (Remakes or extra additives $5)

if not game:IsLoaded() then
	repeat task.wait() until game:IsLoaded()
end

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

local LucideIcons = {
	["activity"] = "rbxassetid://10723343740",
	["airplay"] = "rbxassetid://10723345281",
	["alert-circle"] = "rbxassetid://10723346466",
	["alert-octagon"] = "rbxassetid://10723347230",
	["alert-triangle"] = "rbxassetid://10723348177",
	["align-center"] = "rbxassetid://10723353209",
	["align-justify"] = "rbxassetid://10723353825",
	["align-left"] = "rbxassetid://10723354311",
	["align-right"] = "rbxassetid://10723354778",
	["anchor"] = "rbxassetid://10723355288",
	["aperture"] = "rbxassetid://10723355867",
	["archive"] = "rbxassetid://10723356507",
	["arrow-down"] = "rbxassetid://10723356644",
	["arrow-down-left"] = "rbxassetid://10723357410",
	["arrow-down-right"] = "rbxassetid://10723357927",
	["arrow-left"] = "rbxassetid://10723358404",
	["arrow-right"] = "rbxassetid://10723358926",
	["arrow-up"] = "rbxassetid://10723359451",
	["arrow-up-left"] = "rbxassetid://10723359943",
	["arrow-up-right"] = "rbxassetid://10723360457",
	["at-sign"] = "rbxassetid://10723360962",
	["award"] = "rbxassetid://10723361508",
	["bar-chart"] = "rbxassetid://10723362393",
	["bar-chart-2"] = "rbxassetid://10723361962",
	["battery"] = "rbxassetid://10723362901",
	["battery-charging"] = "rbxassetid://10723363363",
	["bell"] = "rbxassetid://10723364227",
	["bell-off"] = "rbxassetid://10723363827",
	["bluetooth"] = "rbxassetid://10723364675",
	["bold"] = "rbxassetid://10723365086",
	["book"] = "rbxassetid://10723365584",
	["book-open"] = "rbxassetid://10723366054",
	["bookmark"] = "rbxassetid://10723366538",
	["box"] = "rbxassetid://10723367100",
	["briefcase"] = "rbxassetid://10723367555",
	["calendar"] = "rbxassetid://10723368199",
	["camera"] = "rbxassetid://10723368935",
	["camera-off"] = "rbxassetid://10723368661",
	["cast"] = "rbxassetid://10723369464",
	["check"] = "rbxassetid://10723369951",
	["check-circle"] = "rbxassetid://10723370472",
	["check-square"] = "rbxassetid://10723371024",
	["chevron-down"] = "rbxassetid://10723371563",
	["chevron-left"] = "rbxassetid://10723372054",
	["chevron-right"] = "rbxassetid://10723372584",
	["chevron-up"] = "rbxassetid://10723373087",
	["chevrons-down"] = "rbxassetid://10723373649",
	["chevrons-left"] = "rbxassetid://10723374154",
	["chevrons-right"] = "rbxassetid://10723374646",
	["chevrons-up"] = "rbxassetid://10723375150",
	["chrome"] = "rbxassetid://10723375614",
	["circle"] = "rbxassetid://10723376127",
	["clipboard"] = "rbxassetid://10723376670",
	["clock"] = "rbxassetid://10723377157",
	["cloud"] = "rbxassetid://10723378702",
	["cloud-drizzle"] = "rbxassetid://10723377596",
	["cloud-lightning"] = "rbxassetid://10723378019",
	["cloud-off"] = "rbxassetid://10723378406",
	["cloud-rain"] = "rbxassetid://10723379066",
	["cloud-snow"] = "rbxassetid://10723379513",
	["code"] = "rbxassetid://10723380023",
	["codepen"] = "rbxassetid://10723380527",
	["codesandbox"] = "rbxassetid://10723380997",
	["coffee"] = "rbxassetid://10723381452",
	["columns"] = "rbxassetid://10723381919",
	["command"] = "rbxassetid://10723382373",
	["compass"] = "rbxassetid://10723382835",
	["copy"] = "rbxassetid://10723383272",
	["corner-down-left"] = "rbxassetid://10723383706",
	["corner-down-right"] = "rbxassetid://10723384143",
	["corner-left-down"] = "rbxassetid://10723384606",
	["corner-left-up"] = "rbxassetid://10723385065",
	["corner-right-down"] = "rbxassetid://10723385503",
	["corner-right-up"] = "rbxassetid://10723385951",
	["corner-up-left"] = "rbxassetid://10723386396",
	["corner-up-right"] = "rbxassetid://10723386833",
	["cpu"] = "rbxassetid://10723387259",
	["credit-card"] = "rbxassetid://10723387673",
	["crop"] = "rbxassetid://10723388078",
	["crosshair"] = "rbxassetid://10723388518",
	["database"] = "rbxassetid://10723388982",
	["delete"] = "rbxassetid://10723389424",
	["disc"] = "rbxassetid://10723389842",
	["divide"] = "rbxassetid://10723390280",
	["divide-circle"] = "rbxassetid://10723390688",
	["divide-square"] = "rbxassetid://10723391134",
	["dollar-sign"] = "rbxassetid://10723391568",
	["download"] = "rbxassetid://10723392016",
	["download-cloud"] = "rbxassetid://10723391937",
	["dribbble"] = "rbxassetid://10723392460",
	["droplet"] = "rbxassetid://10723392889",
	["edit"] = "rbxassetid://10723393399",
	["edit-2"] = "rbxassetid://10723393862",
	["edit-3"] = "rbxassetid://10723394319",
	["external-link"] = "rbxassetid://10723394795",
	["eye"] = "rbxassetid://10723395271",
	["eye-off"] = "rbxassetid://10723395686",
	["facebook"] = "rbxassetid://10723396139",
	["fast-forward"] = "rbxassetid://10723396575",
	["feather"] = "rbxassetid://10723397002",
	["figma"] = "rbxassetid://10723397406",
	["file"] = "rbxassetid://10723404881",
	["file-minus"] = "rbxassetid://10723397838",
	["file-plus"] = "rbxassetid://10723398271",
	["file-text"] = "rbxassetid://10723398722",
	["film"] = "rbxassetid://10723399157",
	["filter"] = "rbxassetid://10723399599",
	["flag"] = "rbxassetid://10723400030",
	["folder"] = "rbxassetid://10723405508",
	["folder-minus"] = "rbxassetid://10723400457",
	["folder-plus"] = "rbxassetid://10723400925",
	["framer"] = "rbxassetid://10723401355",
	["frown"] = "rbxassetid://10723401796",
	["gift"] = "rbxassetid://10723402239",
	["git-branch"] = "rbxassetid://10723402651",
	["git-commit"] = "rbxassetid://10723403043",
	["git-merge"] = "rbxassetid://10723403453",
	["git-pull-request"] = "rbxassetid://10723403872",
	["github"] = "rbxassetid://10723404246",
	["gitlab"] = "rbxassetid://10723404660",
	["globe"] = "rbxassetid://10723405072",
	["grid"] = "rbxassetid://10723405971",
	["hard-drive"] = "rbxassetid://10723406424",
	["hash"] = "rbxassetid://10723406885",
	["headphones"] = "rbxassetid://10723407333",
	["heart"] = "rbxassetid://10723407805",
	["help-circle"] = "rbxassetid://10723408269",
	["hexagon"] = "rbxassetid://10723408741",
	["home"] = "rbxassetid://10723409171",
	["image"] = "rbxassetid://10723409615",
	["inbox"] = "rbxassetid://10723410036",
	["info"] = "rbxassetid://10723410474",
	["instagram"] = "rbxassetid://10723410913",
	["italic"] = "rbxassetid://10723411326",
	["key"] = "rbxassetid://10723411733",
	["layers"] = "rbxassetid://10723412183",
	["layout"] = "rbxassetid://10723412614",
	["life-buoy"] = "rbxassetid://10723413045",
	["link"] = "rbxassetid://10723413539",
	["link-2"] = "rbxassetid://10723414001",
	["linkedin"] = "rbxassetid://10723414446",
	["list"] = "rbxassetid://10723414921",
	["loader"] = "rbxassetid://10723415374",
	["lock"] = "rbxassetid://10723415814",
	["log-in"] = "rbxassetid://10723416242",
	["log-out"] = "rbxassetid://10723416685",
	["mail"] = "rbxassetid://10723417115",
	["map"] = "rbxassetid://10723417535",
	["map-pin"] = "rbxassetid://10723417980",
	["maximize"] = "rbxassetid://10723418439",
	["maximize-2"] = "rbxassetid://10723418896",
	["meh"] = "rbxassetid://10723419336",
	["menu"] = "rbxassetid://10723419783",
	["message-circle"] = "rbxassetid://10723420226",
	["message-square"] = "rbxassetid://10723420674",
	["mic"] = "rbxassetid://10723421130",
	["mic-off"] = "rbxassetid://10723421590",
	["minimize"] = "rbxassetid://10723422051",
	["minimize-2"] = "rbxassetid://10723422509",
	["minus"] = "rbxassetid://10723422950",
	["minus-circle"] = "rbxassetid://10723423400",
	["minus-square"] = "rbxassetid://10723423868",
	["monitor"] = "rbxassetid://10723424334",
	["moon"] = "rbxassetid://10723424749",
	["more-horizontal"] = "rbxassetid://10723425173",
	["more-vertical"] = "rbxassetid://10723425614",
	["mouse-pointer"] = "rbxassetid://10723426036",
	["move"] = "rbxassetid://10723426477",
	["music"] = "rbxassetid://10723426915",
	["navigation"] = "rbxassetid://10723427378",
	["navigation-2"] = "rbxassetid://10723427827",
	["octagon"] = "rbxassetid://10723428285",
	["package"] = "rbxassetid://10723428765",
	["paperclip"] = "rbxassetid://10723429217",
	["pause"] = "rbxassetid://10723429666",
	["pause-circle"] = "rbxassetid://10723430108",
	["pen-tool"] = "rbxassetid://10723430563",
	["percent"] = "rbxassetid://10723431003",
	["phone"] = "rbxassetid://10723432024",
	["phone-call"] = "rbxassetid://10723431452",
	["phone-forwarded"] = "rbxassetid://10723431896",
	["phone-incoming"] = "rbxassetid://10723432389",
	["phone-missed"] = "rbxassetid://10723432823",
	["phone-off"] = "rbxassetid://10723433288",
	["phone-outgoing"] = "rbxassetid://10723433739",
	["pie-chart"] = "rbxassetid://10723434191",
	["play"] = "rbxassetid://10723434640",
	["play-circle"] = "rbxassetid://10723435087",
	["plus"] = "rbxassetid://10723435542",
	["plus-circle"] = "rbxassetid://10723436036",
	["plus-square"] = "rbxassetid://10723436496",
	["pocket"] = "rbxassetid://10723436954",
	["power"] = "rbxassetid://10723437399",
	["printer"] = "rbxassetid://10723437856",
	["radio"] = "rbxassetid://10723438325",
	["refresh-ccw"] = "rbxassetid://10723438786",
	["refresh-cw"] = "rbxassetid://10723439241",
	["repeat"] = "rbxassetid://10723439710",
	["rewind"] = "rbxassetid://10723440156",
	["rotate-ccw"] = "rbxassetid://10723440606",
	["rotate-cw"] = "rbxassetid://10723441054",
	["rss"] = "rbxassetid://10723441499",
	["save"] = "rbxassetid://10723441925",
	["scissors"] = "rbxassetid://10723442360",
	["search"] = "rbxassetid://10723442802",
	["send"] = "rbxassetid://10723443239",
	["server"] = "rbxassetid://10723443698",
	["settings"] = "rbxassetid://10723444138",
	["share"] = "rbxassetid://10723444579",
	["share-2"] = "rbxassetid://10723445012",
	["shield"] = "rbxassetid://10723445473",
	["shield-off"] = "rbxassetid://10723445930",
	["shopping-bag"] = "rbxassetid://10723446382",
	["shopping-cart"] = "rbxassetid://10723446860",
	["shuffle"] = "rbxassetid://10723447313",
	["sidebar"] = "rbxassetid://10723447775",
	["skip-back"] = "rbxassetid://10723448220",
	["skip-forward"] = "rbxassetid://10723448663",
	["slack"] = "rbxassetid://10723449104",
	["slash"] = "rbxassetid://10723449546",
	["sliders"] = "rbxassetid://10723449993",
	["smartphone"] = "rbxassetid://10723450444",
	["smile"] = "rbxassetid://10723450881",
	["speaker"] = "rbxassetid://10723451324",
	["square"] = "rbxassetid://10723451774",
	["star"] = "rbxassetid://10723452219",
	["stop-circle"] = "rbxassetid://10723452654",
	["sun"] = "rbxassetid://10723453098",
	["sunrise"] = "rbxassetid://10723453537",
	["sunset"] = "rbxassetid://10723453986",
	["tablet"] = "rbxassetid://10723454422",
	["tag"] = "rbxassetid://10723454867",
	["target"] = "rbxassetid://10723455304",
	["terminal"] = "rbxassetid://10723455748",
	["thermometer"] = "rbxassetid://10723456186",
	["thumbs-down"] = "rbxassetid://10723456629",
	["thumbs-up"] = "rbxassetid://10723457088",
	["toggle-left"] = "rbxassetid://10723457532",
	["toggle-right"] = "rbxassetid://10723457975",
	["tool"] = "rbxassetid://10723458422",
	["trash"] = "rbxassetid://10723458895",
	["trash-2"] = "rbxassetid://10723459352",
	["trello"] = "rbxassetid://10723459788",
	["trending-down"] = "rbxassetid://10723460208",
	["trending-up"] = "rbxassetid://10723460652",
	["triangle"] = "rbxassetid://10723461085",
	["truck"] = "rbxassetid://10723461529",
	["tv"] = "rbxassetid://10723461971",
	["twitch"] = "rbxassetid://10723462407",
	["twitter"] = "rbxassetid://10723462842",
	["type"] = "rbxassetid://10723463279",
	["umbrella"] = "rbxassetid://10723463745",
	["underline"] = "rbxassetid://10723464203",
	["unlock"] = "rbxassetid://10723464644",
	["upload"] = "rbxassetid://10723465086",
	["upload-cloud"] = "rbxassetid://10723465523",
	["user"] = "rbxassetid://10723465976",
	["user-check"] = "rbxassetid://10723466412",
	["user-minus"] = "rbxassetid://10723466856",
	["user-plus"] = "rbxassetid://10723467297",
	["user-x"] = "rbxassetid://10723467738",
	["users"] = "rbxassetid://10723468187",
	["video"] = "rbxassetid://10723468638",
	["video-off"] = "rbxassetid://10723469087",
	["voicemail"] = "rbxassetid://10723469536",
	["volume"] = "rbxassetid://10723470050",
	["volume-1"] = "rbxassetid://10723469984",
	["volume-2"] = "rbxassetid://10723470512",
	["volume-x"] = "rbxassetid://10723470969",
	["watch"] = "rbxassetid://10723471411",
	["wifi"] = "rbxassetid://10723471866",
	["wifi-off"] = "rbxassetid://10723472289",
	["wind"] = "rbxassetid://10723472720",
	["x"] = "rbxassetid://10723473145",
	["x-circle"] = "rbxassetid://10723473576",
	["x-octagon"] = "rbxassetid://10723474039",
	["x-square"] = "rbxassetid://10723474479",
	["youtube"] = "rbxassetid://10723474922",
	["zap"] = "rbxassetid://10723475375",
	["zap-off"] = "rbxassetid://10723475812",
	["zoom-in"] = "rbxassetid://10723476242",
	["zoom-out"] = "rbxassetid://10723476681",
}

local function Create(c, p)
	local o = Instance.new(c)
	for k, v in pairs(p) do if k ~= "Parent" then o[k] = v end end
	if p.Parent then o.Parent = p.Parent end
	return o
end

local function GetIcon(name)
	return LucideIcons[name:lower()] or "rbxassetid://10723407805"
end

function OdinLib.new(cfg)
	local s = setmetatable({}, OdinLib)
	s.Title = cfg.Title or "Name Not Chosen"
	s.Theme = cfg.Theme or DefaultTheme
	s.Size = cfg.Size or UDim2.new(0, 750, 0, 550)
	s.Keybind = cfg.Keybind or Enum.KeyCode.RightControl
	s.Tabs = {}
	s.CurrentTab = nil
	s.Visible = true
	s.LoadoutName = "default"
	s.AnonymousMode = false
	s:CreateGui()
	s:SetupKeybind()
	s:SetupMobile()
	s:CreateSettingsTab()
	s:LoadConfig()
	task.wait()
	if #s.Tabs > 0 and not s.CurrentTab then s:SelectTab(s.Tabs[1]) end
	return s
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
	local cb = Create("TextButton", {Name = "CloseButton", Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -33, 0, 3.5), BackgroundColor3 = self.Theme.Content, Text = "X", TextColor3 = self.Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamBold, Parent = self.TopBar})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = cb})
	cb.MouseButton1Click:Connect(function() self:SaveConfig() self:Destroy() end)
end

function OdinLib:CreateSidebar()
	self.Sidebar = Create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 200, 1, -135), Position = UDim2.new(0, 0, 0, 35), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	local sf = Create("Frame", {Name = "SearchFrame", Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = self.Sidebar})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sf})
	self.SearchBox = Create("TextBox", {Name = "SearchBox", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 28, 0, 0), BackgroundTransparency = 1, PlaceholderText = "Search tabs", PlaceholderColor3 = self.Theme.TextDisabled, Text = "", TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = sf})
	Create("ImageLabel", {Name = "SearchIcon", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 8, 0.5, -7), BackgroundTransparency = 1, Image = "rbxassetid://7072721559", ImageColor3 = self.Theme.TextSecondary, Parent = sf})
	self.TabContainer = Create("ScrollingFrame", {Name = "TabContainer", Size = UDim2.new(1, -10, 1, -52), Position = UDim2.new(0, 5, 0, 47), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.Sidebar})
	local tl = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = self.TabContainer})
	tl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, tl.AbsoluteContentSize.Y + 8) end)
	self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local st = self.SearchBox.Text:lower()
		for _, t in pairs(self.Tabs) do t.Button.Visible = st == "" or t.Name:lower():find(st) end
	end)
end

function OdinLib:CreateUserPanel()
	local up = Create("Frame", {Name = "UserPanel", Size = UDim2.new(0, 200, 0, 95), Position = UDim2.new(0, 0, 1, -95), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	local sc = Create("Frame", {Name = "SettingsContainer", Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, ClipsDescendants = true, Parent = up})
	local sb = Create("TextButton", {Name = "SettingsButton", Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Text = "", Parent = sc})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sb})
	Create("ImageLabel", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 8, 0.5, -8), BackgroundTransparency = 1, Image = GetIcon("settings"), ImageColor3 = self.Theme.TextSecondary, Parent = sb})
	Create("TextLabel", {Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 28, 0, 0), BackgroundTransparency = 1, Text = "UI Settings", TextColor3 = self.Theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = sb})
	local ar = Create("ImageLabel", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -18, 0.5, -5), BackgroundTransparency = 1, Image = GetIcon("chevron-down"), ImageColor3 = self.Theme.TextSecondary, Rotation = 0, Parent = sb})
	local kf = Create("Frame", {Name = "KeybindFrame", Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 32), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = sc})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = kf})
	Create("TextLabel", {Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = "Toggle Key", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = kf})
	self.KeybindButton = Create("TextButton", {Size = UDim2.new(0.5, -8, 0, 24), Position = UDim2.new(0.5, 4, 0.5, -12), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = self.Keybind.Name, TextColor3 = self.Theme.Primary, TextSize = 10, Font = Enum.Font.GothamBold, Parent = kf})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = self.KeybindButton})
	self.KeybindButton.MouseButton1Click:Connect(function()
		self.KeybindButton.Text = "..."
		local cn; cn = game:GetService("UserInputService").InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Keyboard then
				self.Keybind = i.KeyCode
				self.KeybindButton.Text = i.KeyCode.Name
				cn:Disconnect()
			end
		end)
	end)
	local lf = Create("Frame", {Name = "LoadoutFrame", Size = UDim2.new(1, 0, 0, 64), Position = UDim2.new(0, 0, 0, 68), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = sc})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lf})
	Create("TextLabel", {Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 8, 0, 4), BackgroundTransparency = 1, Text = "Loadout Manager", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = lf})
	self.LoadoutInput = Create("TextBox", {Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 8, 0, 20), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = self.LoadoutName, PlaceholderText = "Loadout name", PlaceholderColor3 = self.Theme.TextDisabled, TextColor3 = self.Theme.TextPrimary, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = self.LoadoutInput})
	Create("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = self.LoadoutInput})
	local sav = Create("TextButton", {Size = UDim2.new(0.48, 0, 0, 18), Position = UDim2.new(0, 8, 1, -22), BackgroundColor3 = self.Theme.Success, BorderSizePixel = 0, Text = "Save", TextColor3 = self.Theme.Background, TextSize = 9, Font = Enum.Font.GothamBold, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = sav})
	local lod = Create("TextButton", {Size = UDim2.new(0.48, 0, 0, 18), Position = UDim2.new(0.52, 0, 1, -22), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Text = "Load", TextColor3 = self.Theme.Background, TextSize = 9, Font = Enum.Font.GothamBold, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = lod})
	sav.MouseButton1Click:Connect(function()
		local n = self.LoadoutInput.Text
		if n and n ~= "" then
			self.LoadoutName = n
			self:SaveConfig()
			self:Log("Saved: " .. n, "success")
		end
	end)
	lod.MouseButton1Click:Connect(function()
		local n = self.LoadoutInput.Text
		if n and n ~= "" then
			self.LoadoutName = n
			self:LoadConfig()
			self:Log("Loaded: " .. n, "success")
		end
	end)
	local anf = Create("Frame", {Name = "AnonFrame", Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 136), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = sc})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = anf})
	Create("TextLabel", {Size = UDim2.new(0.65, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = "Anonymous Mode", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = anf})
	local ant = Create("TextButton", {Name = "AnonToggle", Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -48, 0.5, -10), BackgroundColor3 = self.AnonymousMode and self.Theme.Primary or self.Theme.Border, BorderSizePixel = 0, Text = "", Parent = anf})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ant})
	local anc = Create("Frame", {Name = "Circle", Size = UDim2.new(0, 16, 0, 16), Position = self.AnonymousMode and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = ant})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = anc})
	ant.MouseButton1Click:Connect(function()
		self.AnonymousMode = not self.AnonymousMode
		game:GetService("TweenService"):Create(ant, TweenInfo.new(0.15), {BackgroundColor3 = self.AnonymousMode and self.Theme.Primary or self.Theme.Border}):Play()
		game:GetService("TweenService"):Create(anc, TweenInfo.new(0.15), {Position = self.AnonymousMode and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
		self:UpdateAnonymousMode()
		self:Log(self.AnonymousMode and "Anonymous mode enabled" or "Anonymous mode disabled", "success")
	end)
	sb.MouseButton1Click:Connect(function()
		self.SettingsOpen = not self.SettingsOpen
		game:GetService("TweenService"):Create(sc, TweenInfo.new(0.2), {Size = self.SettingsOpen and UDim2.new(1, -20, 0, 172) or UDim2.new(1, -20, 0, 28)}):Play()
		game:GetService("TweenService"):Create(ar, TweenInfo.new(0.2), {Rotation = self.SettingsOpen and 180 or 0}):Play()
	end)
	local ui = Create("Frame", {Name = "UserInfo", Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = up})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ui})
	self.AvatarImg = Create("ImageLabel", {Name = "Avatar", Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 7, 0.5, -18), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Image = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=150&h=150", Parent = ui})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = self.AvatarImg})
	Create("TextLabel", {Size = UDim2.new(1, -50, 0, 14), Position = UDim2.new(0, 48, 0, 8), BackgroundTransparency = 1, Text = "Welcome,", TextColor3 = self.Theme.TextDisabled, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = ui})
	self.UsernameLabel = Create("TextLabel", {Size = UDim2.new(1, -50, 0, 18), Position = UDim2.new(0, 48, 0, 22), BackgroundTransparency = 1, Text = game.Players.LocalPlayer.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = ui})
	self.StatusIndicator = Create("Frame", {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 35, 0, 29), BackgroundColor3 = self.Theme.Success, BorderSizePixel = 0, Parent = ui})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = self.StatusIndicator})
	self.UserPanel = up
end

function OdinLib:UpdateAnonymousMode()
	if self.AnonymousMode then
		self.AvatarImg.Image = "rbxassetid://0"
		self.AvatarImg.BackgroundColor3 = self.Theme.Border
		self.UsernameLabel.Text = "Anonymous"
	else
		self.AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=150&h=150"
		self.UsernameLabel.Text = game.Players.LocalPlayer.Name
	end
end

function OdinLib:CreateSettingsTab()
	local st = self:AddTab({Name = "UI Settings", Icon = "settings", Subtext = "Configure interface"})
	self:AddDivider(st, {Text = "KEYBIND"})
	self:AddLabel(st, {Text = "Change the toggle key for the UI"})
	local kb = Create("Frame", {Name = "KeybindFrame", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = kb})
	Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Toggle Key", TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = kb})
	local kbb = Create("TextButton", {Size = UDim2.new(0.45, 0, 0, 28), Position = UDim2.new(0.55, 0, 0.5, -14), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = self.Keybind.Name, TextColor3 = self.Theme.Primary, TextSize = 11, Font = Enum.Font.GothamBold, Parent = kb})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = kbb})
	table.insert(st.Elements, {Type = "Custom", Frame = kb})
	kbb.MouseButton1Click:Connect(function()
		kbb.Text = "..."
		local cn; cn = game:GetService("UserInputService").InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Keyboard then
				self.Keybind = i.KeyCode
				kbb.Text = i.KeyCode.Name
				self.KeybindButton.Text = i.KeyCode.Name
				cn:Disconnect()
			end
		end)
	end)
	self:AddDivider(st, {Text = "LOADOUT MANAGER"})
	self:AddLabel(st, {Text = "Save and load UI configurations"})
	local lf = Create("Frame", {Name = "LoadoutFrame", Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lf})
	Create("TextLabel", {Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Text = "Loadout Name", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = lf})
	local lin = Create("TextBox", {Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 24), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = self.LoadoutName, PlaceholderText = "Enter name", PlaceholderColor3 = self.Theme.TextDisabled, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lin})
	Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = lin})
	local sav = Create("TextButton", {Size = UDim2.new(0.48, 0, 0, 20), Position = UDim2.new(0, 10, 1, -26), BackgroundColor3 = self.Theme.Success, BorderSizePixel = 0, Text = "Save Config", TextColor3 = self.Theme.Background, TextSize = 10, Font = Enum.Font.GothamBold, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sav})
	local lod = Create("TextButton", {Size = UDim2.new(0.48, 0, 0, 20), Position = UDim2.new(0.52, 0, 1, -26), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Text = "Load Config", TextColor3 = self.Theme.Background, TextSize = 10, Font = Enum.Font.GothamBold, Parent = lf})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lod})
	table.insert(st.Elements, {Type = "Custom", Frame = lf})
	sav.MouseButton1Click:Connect(function()
		local n = lin.Text
		if n and n ~= "" then
			self.LoadoutName = n
			self.LoadoutInput.Text = n
			self:SaveConfig()
			self:Log("Saved: " .. n, "success")
		end
	end)
	lod.MouseButton1Click:Connect(function()
		local n = lin.Text
		if n and n ~= "" then
			self.LoadoutName = n
			self.LoadoutInput.Text = n
			self:LoadConfig()
			self:Log("Loaded: " .. n, "success")
		end
	end)
	self:AddDivider(st, {Text = "PRIVACY"})
	self:AddToggle(st, {Name = "Anonymous Mode", Default = false, Callback = function(v)
		self.AnonymousMode = v
		self:UpdateAnonymousMode()
		self:Log(v and "Anonymous mode enabled" or "Anonymous mode disabled", "success")
	end})
end

function OdinLib:ToggleVisibility()
	self.Visible = not self.Visible
	self.MainFrame.Visible = self.Visible
end

function OdinLib:Destroy()
	if self.ScreenGui then
		self.ScreenGui:Destroy()
		self.ScreenGui = nil
	end
end

function OdinLib:CreateContentArea()
	self.ContentArea = Create("Frame", {Name = "ContentArea", Size = UDim2.new(1, -210, 1, -140), Position = UDim2.new(0, 205, 0, 40), BackgroundColor3 = self.Theme.Content, BorderSizePixel = 0, Parent = self.MainFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = self.ContentArea})
	self.ContentScroll = Create("ScrollingFrame", {Name = "ContentScroll", Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.ContentArea})
	local cl = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = self.ContentScroll})
	cl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, cl.AbsoluteContentSize.Y + 8) end)
end

function OdinLib:CreateConsole()
	self.Console = Create("Frame", {Name = "Console", Size = UDim2.new(1, -210, 0, 90), Position = UDim2.new(0, 205, 1, -95), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0, Parent = self.MainFrame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = self.Console})
	self.ConsoleScroll = Create("ScrollingFrame", {Name = "ConsoleScroll", Size = UDim2.new(1, -16, 1, -8), Position = UDim2.new(0, 8, 0, 4), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = self.Console})
	local col = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = self.ConsoleScroll})
	col:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.ConsoleScroll.CanvasSize = UDim2.new(0, 0, 0, col.AbsoluteContentSize.Y)
		self.ConsoleScroll.CanvasPosition = Vector2.new(0, col.AbsoluteContentSize.Y)
	end)
end

function OdinLib:MakeDraggable()
	local d, di, mp, fp
	self.TopBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			d = true
			mp = i.Position
			fp = self.MainFrame.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
		end
	end)
	self.TopBar.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
	game:GetService("UserInputService").InputChanged:Connect(function(i)
		if i == di and d then
			local dt = i.Position - mp
			self.MainFrame.Position = UDim2.new(fp.X.Scale, fp.X.Offset + dt.X, fp.Y.Scale, fp.Y.Offset + dt.Y)
		end
	end)
end

function OdinLib:SetupKeybind()
	game:GetService("UserInputService").InputBegan:Connect(function(i, g)
		if not g and i.KeyCode == self.Keybind then self:ToggleVisibility() end
	end)
end

function OdinLib:SetupMobile()
	if game:GetService("UserInputService").TouchEnabled then
		local tb = Create("TextButton", {Name = "MobileToggle", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0, 100), BackgroundColor3 = self.Theme.Primary, Text = "☰", TextColor3 = self.Theme.Background, TextSize = 24, Font = Enum.Font.GothamBold, Parent = self.ScreenGui})
		Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = tb})
		tb.MouseButton1Click:Connect(function() self:ToggleVisibility() end)
		local d, di, sp
		tb.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch then
				d = true
				sp = i.Position
				i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
			end
		end)
		tb.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then di = i end end)
		game:GetService("UserInputService").InputChanged:Connect(function(i)
			if i == di and d then
				tb.Position = UDim2.new(0, i.Position.X - 25, 0, i.Position.Y - 25)
			end
		end)
	end
end

function OdinLib:AddTab(cfg)
	local t = {Name = cfg.Name or "Tab", Icon = GetIcon(cfg.Icon or "home"), Elements = {}}
	t.Button = Create("TextButton", {Name = cfg.Name, Size = UDim2.new(1, -10, 0, 38), BackgroundColor3 = self.Theme.Content, BackgroundTransparency = 0.6, BorderSizePixel = 0, Text = "", Parent = self.TabContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = t.Button})
	t.Icon = Create("ImageLabel", {Name = "Icon", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9), BackgroundTransparency = 1, Image = t.Icon, ImageColor3 = self.Theme.TextSecondary, Parent = t.Button})
	t.Label = Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -38, 0.6, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Text = t.Name, TextColor3 = self.Theme.TextSecondary, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = t.Button})
	Create("TextLabel", {Name = "Subtext", Size = UDim2.new(1, -38, 0.4, 0), Position = UDim2.new(0, 32, 0.6, 0), BackgroundTransparency = 1, Text = cfg.Subtext or "", TextColor3 = self.Theme.TextDisabled, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = t.Button})
	t.Button.MouseButton1Click:Connect(function() self:SelectTab(t) end)
	t.Button.MouseEnter:Connect(function() if self.CurrentTab ~= t then t.Button.BackgroundTransparency = 0.4 end end)
	t.Button.MouseLeave:Connect(function() if self.CurrentTab ~= t then t.Button.BackgroundTransparency = 0.6 end end)
	table.insert(self.Tabs, t)
	self:UpdateTabContainerSize()
	return t
end

function OdinLib:UpdateTabContainerSize()
	local tc = #self.Tabs
	local th = 38
	local pd = 4
	local sh = 47
	local tth = (tc * th) + ((tc - 1) * pd)
	local ah = self.Sidebar.AbsoluteSize.Y - sh
	if tth < ah then
		self.TabContainer.Size = UDim2.new(1, -10, 0, tth + 8)
		self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	else
		self.TabContainer.Size = UDim2.new(1, -10, 1, -sh)
	end
end

function OdinLib:SelectTab(t)
	if self.CurrentTab then
		self.CurrentTab.Button.BackgroundTransparency = 0.6
		self.CurrentTab.Icon.ImageColor3 = self.Theme.TextSecondary
		self.CurrentTab.Label.TextColor3 = self.Theme.TextSecondary
	end
	self.CurrentTab = t
	t.Button.BackgroundTransparency = 0
	t.Icon.ImageColor3 = self.Theme.Primary
	t.Label.TextColor3 = self.Theme.TextPrimary
	for _, c in pairs(self.ContentScroll:GetChildren()) do if c:IsA("GuiObject") then c.Visible = false end end
	for _, e in pairs(t.Elements) do
		if e.Frame.Parent ~= self.ContentScroll then e.Frame.Parent = self.ContentScroll end
		e.Frame.Visible = true
	end
end

function OdinLib:SaveConfig()
	local cfg = {Elements = {}, AnonymousMode = self.AnonymousMode}
	for _, t in pairs(self.Tabs) do
		for _, e in pairs(t.Elements) do
			if e.Type == "Toggle" or e.Type == "Slider" or e.Type == "Dropdown" or e.Type == "Input" or e.Type == "ColorPicker" then
				table.insert(cfg.Elements, {Name = e.Name, Type = e.Type, Value = e.Value})
			end
		end
	end
	writefile("odinlib_" .. self.LoadoutName .. ".json", game:GetService("HttpService"):JSONEncode(cfg))
end

function OdinLib:LoadConfig()
	local fn = "odinlib_" .. self.LoadoutName .. ".json"
	if not isfile(fn) then return end
	local s, cfg = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(fn)) end)
	if not s or not cfg or not cfg.Elements then return end
	if cfg.AnonymousMode ~= nil then
		self.AnonymousMode = cfg.AnonymousMode
		self:UpdateAnonymousMode()
	end
	for _, sv in pairs(cfg.Elements) do
		for _, t in pairs(self.Tabs) do
			for _, e in pairs(t.Elements) do
				if e.Name == sv.Name and e.Type == sv.Type then
					if e.Type == "Toggle" then
						e.Value = sv.Value
						game:GetService("TweenService"):Create(e.Toggle, TweenInfo.new(0.15), {BackgroundColor3 = e.Value and self.Theme.Primary or self.Theme.Border}):Play()
						game:GetService("TweenService"):Create(e.Circle, TweenInfo.new(0.15), {Position = e.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
						e.Callback(e.Value)
					elseif e.Type == "Slider" then
						e.Value = sv.Value
						e.ValueBox.Text = tostring(sv.Value)
						local ps = (sv.Value - e.Min) / (e.Max - e.Min)
						e.SliderFill.Size = UDim2.new(ps, 0, 1, 0)
						e.SliderButton.Position = UDim2.new(ps, -7, 0.5, -7)
						e.Callback(sv.Value)
					elseif e.Type == "Dropdown" then
						e.Value = sv.Value
						e.SelectedLabel.Text = sv.Value
						e.Callback(sv.Value)
					elseif e.Type == "Input" then
						e.Value = sv.Value
						e.InputBox.Text = sv.Value
						e.Callback(sv.Value)
					elseif e.Type == "ColorPicker" then
						e.Value = Color3.new(sv.Value.R, sv.Value.G, sv.Value.B)
						e.ColorDisplay.BackgroundColor3 = e.Value
						e.Callback(e.Value)
					end
					break
				end
			end
		end
	end
end

function OdinLib:AddToggle(t, cfg)
	local e = {Type = "Toggle", Name = cfg.Name or "Toggle", Value = cfg.Default or false, Callback = cfg.Callback or function() end}
	e.Frame = Create("Frame", {Name = "ToggleElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = e.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = e.Frame})
	e.Toggle = Create("TextButton", {Name = "ToggleButton", Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = e.Value and self.Theme.Primary or self.Theme.Border, BorderSizePixel = 0, Text = "", Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = e.Toggle})
	e.Circle = Create("Frame", {Name = "Circle", Size = UDim2.new(0, 16, 0, 16), Position = e.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = e.Toggle})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = e.Circle})
	local function tog()
		e.Value = not e.Value
		game:GetService("TweenService"):Create(e.Toggle, TweenInfo.new(0.15), {BackgroundColor3 = e.Value and self.Theme.Primary or self.Theme.Border}):Play()
		game:GetService("TweenService"):Create(e.Circle, TweenInfo.new(0.15), {Position = e.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
		e.Callback(e.Value)
	end
	e.Toggle.MouseButton1Click:Connect(tog)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddSlider(t, cfg)
	local e = {Type = "Slider", Name = cfg.Name or "Slider", Min = cfg.Min or 0, Max = cfg.Max or 100, Default = cfg.Default or cfg.Min or 0, Increment = cfg.Increment or 1, Callback = cfg.Callback or function() end}
	e.Value = e.Default
	e.Frame = Create("Frame", {Name = "SliderElement", Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	local top = Create("Frame", {Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 4), BackgroundTransparency = 1, Parent = e.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.6, 0, 1, 0), BackgroundTransparency = 1, Text = e.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = top})
	e.ValueBox = Create("TextBox", {Name = "ValueBox", Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -70, 0, 0), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = tostring(e.Value), TextColor3 = self.Theme.Primary, TextSize = 11, Font = Enum.Font.GothamBold, Parent = top})
	Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = e.ValueBox})
	local sb = Create("Frame", {Name = "SliderBack", Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 1, -12), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sb})
	e.SliderFill = Create("Frame", {Name = "SliderFill", Size = UDim2.new((e.Value - e.Min) / (e.Max - e.Min), 0, 1, 0), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Parent = sb})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = e.SliderFill})
	e.SliderButton = Create("TextButton", {Name = "SliderButton", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((e.Value - e.Min) / (e.Max - e.Min), -7, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Text = "", Parent = sb})
	Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = e.SliderButton})
	local dr = false
	local function upd(i)
		local p = math.clamp((i.Position.X - sb.AbsolutePosition.X) / sb.AbsoluteSize.X, 0, 1)
		local v = math.clamp(math.floor((e.Min + (p * (e.Max - e.Min))) / e.Increment + 0.5) * e.Increment, e.Min, e.Max)
		e.Value = v
		e.ValueBox.Text = tostring(v)
		e.SliderFill.Size = UDim2.new(p, 0, 1, 0)
		e.SliderButton.Position = UDim2.new(p, -7, 0.5, -7)
		e.Callback(v)
	end
	e.SliderButton.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true upd(i) end end)
	e.SliderButton.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end end)
	sb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true upd(i) end end)
	game:GetService("UserInputService").InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
	game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end end)
	e.ValueBox.FocusLost:Connect(function()
		local v = tonumber(e.ValueBox.Text)
		if v then
			v = math.clamp(math.floor(v / e.Increment + 0.5) * e.Increment, e.Min, e.Max)
			e.Value = v
			e.ValueBox.Text = tostring(v)
			local p = (v - e.Min) / (e.Max - e.Min)
			e.SliderFill.Size = UDim2.new(p, 0, 1, 0)
			e.SliderButton.Position = UDim2.new(p, -7, 0.5, -7)
			e.Callback(v)
		else e.ValueBox.Text = tostring(e.Value) end
	end)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddDropdown(t, cfg)
	local e = {Type = "Dropdown", Name = cfg.Name or "Dropdown", Options = cfg.Options or {"Option 1", "Option 2"}, Default = cfg.Default or (cfg.Options and cfg.Options[1]) or "Option 1", Callback = cfg.Callback or function() end, Open = false}
	e.Value = e.Default
	e.Frame = Create("Frame", {Name = "DropdownElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false, ClipsDescendants = false, ZIndex = 1})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = e.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = e.Frame})
	local db = Create("TextButton", {Name = "DropdownButton", Size = UDim2.new(0.55, -10, 0, 28), Position = UDim2.new(0.45, 0, 0.5, -14), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = "", ZIndex = 2, Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = db})
	e.SelectedLabel = Create("TextLabel", {Name = "SelectedLabel", Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = e.Value, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = db})
	e.Arrow = Create("ImageLabel", {Name = "Arrow", Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -18, 0.5, -5), BackgroundTransparency = 1, Image = GetIcon("chevron-down"), ImageColor3 = self.Theme.TextSecondary, Rotation = 0, ZIndex = 2, Parent = db})
	e.DropdownContainer = Create("Frame", {Name = "DropdownContainer", Size = UDim2.new(0.55, -10, 0, 0), Position = UDim2.new(0.45, 0, 1, 4), BackgroundTransparency = 1, Visible = false, ClipsDescendants = false, ZIndex = 200, Parent = e.Frame})
	e.OptionsFrame = Create("ScrollingFrame", {Name = "OptionsFrame", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 201, ScrollBarThickness = 3, ScrollBarImageColor3 = self.Theme.Primary, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = e.DropdownContainer})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.OptionsFrame})
	local ol = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = e.OptionsFrame})
	Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = e.OptionsFrame})
	for _, o in pairs(e.Options) do
		local ob = Create("TextButton", {Name = o, Size = UDim2.new(1, -8, 0, 24), BackgroundColor3 = self.Theme.Content, BackgroundTransparency = 0.5, BorderSizePixel = 0, Text = o, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, ZIndex = 202, Parent = e.OptionsFrame})
		Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = ob})
		ob.MouseButton1Click:Connect(function()
			e.Value = o
			e.SelectedLabel.Text = o
			e.Open = false
			e.DropdownContainer.Visible = false
			game:GetService("TweenService"):Create(e.Arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
			e.Callback(o)
		end)
		ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.2 end)
		ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 0.5 end)
	end
	ol:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		e.OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, ol.AbsoluteContentSize.Y + 8)
		e.DropdownContainer.Size = UDim2.new(0.55, -10, 0, math.min(ol.AbsoluteContentSize.Y + 8, 120))
	end)
	db.MouseButton1Click:Connect(function()
		e.Open = not e.Open
		e.DropdownContainer.Visible = e.Open
		game:GetService("TweenService"):Create(e.Arrow, TweenInfo.new(0.15), {Rotation = e.Open and 180 or 0}):Play()
	end)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddInput(t, cfg)
	local e = {Type = "Input", Name = cfg.Name or "Input", Placeholder = cfg.Placeholder or "Enter text...", Default = cfg.Default or "", Callback = cfg.Callback or function() end}
	e.Value = e.Default
	e.Frame = Create("Frame", {Name = "InputElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = e.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = e.Frame})
	e.InputBox = Create("TextBox", {Name = "InputBox", Size = UDim2.new(0.55, -10, 0, 28), Position = UDim2.new(0.45, 0, 0.5, -14), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Text = e.Value, PlaceholderText = e.Placeholder, PlaceholderColor3 = self.Theme.TextDisabled, TextColor3 = self.Theme.TextPrimary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.InputBox})
	Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = e.InputBox})
	e.InputBox.FocusLost:Connect(function() e.Value = e.InputBox.Text e.Callback(e.InputBox.Text) end)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddButton(t, cfg)
	local e = {Type = "Button", Name = cfg.Name or "Button", Callback = cfg.Callback or function() end}
	e.Frame = Create("Frame", {Name = "ButtonElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	e.Button = Create("TextButton", {Name = "Button", Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0.5, -16), BackgroundColor3 = self.Theme.Primary, BorderSizePixel = 0, Text = e.Name, TextColor3 = self.Theme.Background, TextSize = 12, Font = Enum.Font.GothamBold, Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Button})
	e.Button.MouseButton1Click:Connect(function() e.Callback() end)
	e.Button.MouseEnter:Connect(function() game:GetService("TweenService"):Create(e.Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(math.min(255, self.Theme.Primary.R * 255 * 1.15), math.min(255, self.Theme.Primary.G * 255 * 1.15), math.min(255, self.Theme.Primary.B * 255 * 1.15))}):Play() end)
	e.Button.MouseLeave:Connect(function() game:GetService("TweenService"):Create(e.Button, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Primary}):Play() end)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddColorPicker(t, cfg)
	local e = {Type = "ColorPicker", Name = cfg.Name or "Color Picker", Default = cfg.Default or Color3.fromRGB(255, 255, 255), Callback = cfg.Callback or function() end}
	e.Value = e.Default
	e.Frame = Create("Frame", {Name = "ColorPickerElement", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	Create("TextLabel", {Name = "Label", Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = e.Name, TextColor3 = self.Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = e.Frame})
	e.ColorDisplay = Create("TextButton", {Name = "ColorDisplay", Size = UDim2.new(0, 60, 0, 28), Position = UDim2.new(1, -70, 0.5, -14), BackgroundColor3 = e.Value, BorderSizePixel = 0, Text = "", Parent = e.Frame})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.ColorDisplay})
	e.ColorDisplay.MouseButton1Click:Connect(function() e.Callback(e.Value) end)
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddLabel(t, cfg)
	local e = {Type = "Label", Text = cfg.Text or "Label"}
	e.Frame = Create("Frame", {Name = "LabelElement", Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = self.Theme.ElementBackground, BorderSizePixel = 0, Parent = self.ContentScroll, Visible = false})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = e.Frame})
	e.Label = Create("TextLabel", {Name = "Label", Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = e.Text, TextColor3 = self.Theme.TextSecondary, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = e.Frame})
	function e:SetText(tx) e.Text = tx e.Label.Text = tx end
	table.insert(t.Elements, e)
	return e
end

function OdinLib:AddDivider(t, cfg)
	local e = {Type = "Divider", Text = cfg.Text or nil}
	e.Frame = Create("Frame", {Name = "DividerElement", Size = UDim2.new(1, 0, 0, e.Text and 32 or 8), BackgroundTransparency = 1, Parent = self.ContentScroll, Visible = false})
	if e.Text then Create("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = e.Text, TextColor3 = self.Theme.TextDisabled, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = e.Frame}) end
	Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = e.Text and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = self.Theme.Border, BorderSizePixel = 0, Parent = e.Frame})
	table.insert(t.Elements, e)
	return e
end

function OdinLib:Log(m, lt)
	local c = self.Theme.TextSecondary
	if lt == "success" then c = self.Theme.Success elseif lt == "warning" then c = self.Theme.Warning elseif lt == "error" then c = self.Theme.Error end
	Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = os.date("[%H:%M:%S]") .. " " .. m, TextColor3 = c, TextSize = 10, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.ConsoleScroll})
end

return OdinLib
