getgenv().ExploiterName = "hexhub_22kO43" -- player to spoof
getgenv().PlayerName = "deadxd2020" -- target username
getgenv().CB_Pin = "rbxassetid://4434228836" -- spoof a pin

-- // initialize

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function filterString(string, k, v)
    string = tostring(string)
    local s = string.gsub(string, k, v)
    return string.gsub(string, k, v)
end

local playerId = Players:GetUserIdFromNameAsync(getgenv().PlayerName)
local exploiterId = Players:GetUserIdFromNameAsync(getgenv().ExploiterName)

local spoofed = {}

local GUI
if game.GameId == 115797356 then
    GUI = LocalPlayer.PlayerGui.GUI
end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if not rawget(spoofed, v) then
            table.insert(spoofed, v)
        end

        for i2,v2 in pairs(getconnections(v:GetPropertyChangedSignal("Text"))) do
            v2:Disable()
        end

        for i2,v2 in pairs(getconnections(v.Changed)) do
            v2:Disable()
        end

        v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if not rawget(spoofed, v) then
            table.insert(spoofed, v)
        end

        if not sFound then
            table.insert(spoofed, {v, v.Text})
        end

        for i2,v2 in pairs(getconnections(v:GetPropertyChangedSignal("Text"))) do
            v2:Disable()
        end

        for i2,v2 in pairs(getconnections(v.Changed)) do
            v2:Disable()
        end

        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end)

-- // metatable hooks

local mt = getrawmetatable(game)
local __oldNewIndex = mt.__newindex
local __oldIndex = mt.__index

if setreadonly then setreadonly(mt, false) else make_writeable(mt) end

mt.__index = newcclosure(function(self, k)
    if (k == "Text" or k == "Image") and rawget(spoofed, self) then
        if k == "Text" then
            return getgenv().ExploiterName
        elseif k == "Image" then
            return string.gsub(__oldIndex(self, k), playerId, exploiterId)
        end
    end
    return __oldIndex(self, k)
end)

mt.__newindex = newcclosure(function(self, k, v)
    if not checkcaller() then
        if (game.IsA(self, "TextLabel") or game.IsA(self, "TextButton")) and k == "Text" then
            if string.find(v, getgenv().ExploiterName) then
                return __oldNewIndex(self, k, string.gsub(v, getgenv().ExploiterName, getgenv().PlayerName))
            end
        elseif (game.IsA(self, "ImageLabel") or game.IsA(self, "ImageButton")) and k == "Image" then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            if string.find(v, exploiterId) then
                return __oldNewIndex(self, k, string.gsub(v, exploiterId, playerId))
            elseif string.find(v, getgenv().ExploiterName) then
                return __oldNewIndex(self, k, string.gsub(v, getgenv().ExploiterName, getgenv().PlayerName))
            end
        elseif GUI and self == GUI.Spectate.PlayerBox.PlayerPin and (string.find(GUI.Spectate.PlayerBox.PlayerName.Text, getgenv().ExploiterName) or string.find(GUI.Spectate.PlayerBox.PlayerName.Text, getgenv().PlayerName)) then
            __oldNewIndex(self, "Image", getgenv().CB_Pin or GUI.Spectate.PlayerBox.PlayerPin.Image)
            __oldNewIndex(self, "Visible", getgenv().CB_Pin and true or false)
            return
        end
    end

    return __oldNewIndex(self, k, v)
end)

if setreadonly then setreadonly(mt, true) else make_readonly(mt) end

-- // pin spoofer for counter blox
if GUI then
    GUI.Scoreboard.DescendantAdded:Connect(function(v)
        if v.Name == "CTFrame" or v.Name == "TFrame" then
            repeat game:GetService("RunService").Heartbeat:Wait() until v.player.Text ~= "PLAYER"
            if (string.find(v.player.Text, getgenv().ExploiterName) or string.find(v.player.Text, getgenv().PlayerName)) and v:FindFirstChild("Pin") then
                if not rawget(spoofed, v) then
                    table.insert(spoofed, v)
                end
                
                v.Pin.Image = getgenv().CB_Pin or ""
            end
        end
    end)
end
