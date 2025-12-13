repeat task.wait() until game:IsLoaded()

local cloneref = cloneref or function(v) return v end
local Players = cloneref(game:GetService("Players"))
local Plr = Players.LocalPlayer

if not script_key then
  Plr:Kick("You haven't entered a key yet or your executor is trash!")
  return
end

local validgame

if game.GameId == 7884563721 then
  validgame = true
  loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/5d931a534e183e0469eb5e92b8b3f52b.lua"))() -- arcade basketball
end

if game.GameId == 184199275 then
  loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/a3f402ada01f234399ea335aae31f420.lua"))()
end

if not validgame then
  loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/f6a92e7f0cc4fcec3184b7402d4232b8.lua"))() -- universal script
end
