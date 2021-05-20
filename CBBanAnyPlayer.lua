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

local GUI
if game.GameId == 115797356 then
    GUI = LocalPlayer.PlayerGui.GUI
end

-- // metatable hooks

local mt = getrawmetatable(game)
local __oldNewIndex = mt.__newindex

if setreadonly then setreadonly(mt, false) else make_writeable(mt) end

mt.__newindex = newcclosure(function(self, k, v)
    if (game.IsA(self, "TextLabel") or game.IsA(self, "TextButton")) and k == "Text" then
        if string.find(v, getgenv().ExploiterName) then
            return __oldNewIndex(self, k, string.gsub(v, getgenv().ExploiterName, getgenv().PlayerName))
        end
    elseif (game.IsA(self, "ImageLabel") or game.IsA(self, "ImageButton")) and k == "Image" then
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

    return __oldNewIndex(self, k, v)
end)

if setreadonly then setreadonly(mt, true) else make_readonly(mt) end

-- // other

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end)

-- // pin spoofer for counter blox
if GUI then
    GUI.Scoreboard.DescendantAdded:Connect(function(v)
        if v.Name == "CTFrame" or v.Name == "TFrame" then
            repeat game:GetService("RunService").Heartbeat:Wait() until v.player.Text ~= "PLAYER"
            if (string.find(v.player.Text, getgenv().ExploiterName) or string.find(v.player.Text, getgenv().PlayerName)) and v:FindFirstChild("Pin") then
                v.Pin.Image = getgenv().CB_Pin
            end
        end
    end)
end
