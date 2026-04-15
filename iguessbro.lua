local WimplyUI = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

local Window = WimplyUI:CreateWindow({
    Title = "My Script | wimply.xyz",
    Size = UDim2.fromOffset(420, 520),
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl,
    ConfigFolder = "MyScript",
    ConfigFile = "settings"
})

local Main = Window:AddTab({ Title = "Main" })
local Settings = Window:AddTab({ Title = "Settings" })

Main:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Flag = "autoFarm",
    Callback = function(v) print("Farm:", v) end
})

Main:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Increment = 1,
    Flag = "speed",
    Callback = function(v) print("Speed:", v) end
})

Main:AddDropdown({
    Title = "Mode",
    Options = {"Legit", "Rage", "Silent"},
    Default = "Legit",
    Flag = "mode",
    Callback = function(v) print("Mode:", v) end
})

Main:AddButton({
    Title = "Execute",
    Callback = function() print("clicked") end
})

Main:AddInput({
    Title = "Target",
    Placeholder = "Username...",
    Default = "",
    Flag = "target",
    Callback = function(v) print("Target:", v) end
})

Main:AddParagraph({
    Title = "Info",
    Content = "Made by wimply.xyz"
})

Main:AddKeybind({
    Title = "Toggle Key",
    Default = Enum.KeyCode.E,
    Flag = "toggleKey",
    Callback = function(key) print("Pressed:", key) end
})

Settings:AddDropdown({
    Title = "Theme",
    Options = {"Amethyst", "Midnight", "Rose", "Emerald", "Sunset", "Dark"},
    Default = "Amethyst",
    Callback = function(v) Window:SetTheme(v) end
})

Window:SelectTab(1)
Window:SaveConfig()
