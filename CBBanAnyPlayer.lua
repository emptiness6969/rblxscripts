-- nice attempt rolve!!!!

for i,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
    v:Disable()    
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function filterString(string, k, v)
    string = tostring(string)
    local s = string.gsub(string, k, v)
    return s
end

function DisableRBXSignal(RBXSignal)
    for i,v in pairs(getconnections(RBXSignal)) do
        v:Disable()
    end
end

local playerId = Players:GetUserIdFromNameAsync(getgenv().PlayerName)
local exploiterId = Players:GetUserIdFromNameAsync(getgenv().ExploiterName)

local spoofed = {}
local oldPin

local GUI
if game.GameId == 115797356 then
    GUI = LocalPlayer.PlayerGui.GUI
end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if string.find(tostring(v.Text), getgenv().ExploiterName) then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
                DisableRBXSignal(v:GetPropertyChangedSignal("Text"))
                DisableRBXSignal(v.Changed)
            end
        end

        v.Text = filterString(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = filterString(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if string.find(tostring(v.Text), getgenv().ExploiterName) then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
                DisableRBXSignal(v:GetPropertyChangedSignal("Text"))
                DisableRBXSignal(v.Changed)
            end
        end

        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = filterString(v.Text, getgenv().ExploiterName, getgenv().PlayerName)
        end)
    end
end)



local mt = getrawmetatable(game)
local __oldNewIndex = mt.__newindex
local __oldIndex = mt.__index

if setreadonly then setreadonly(mt, false) else make_writeable(mt) end

mt.__index = newcclosure(function(self, k)
    if not checkcaller() then
        if (k == "Text" or k == "Image") and rawget(spoofed, self) then
            if k == "Text" then
                return getgenv().ExploiterName
            elseif k == "Image" then
                if self.Name == "Pin" then
                    return oldPin
                end
                local x = filterString(filterString(__oldIndex(self, k), playerId, exploiterId), getgenv().PlayerName, getgenv().ExploiterName)
                return x
            end
        end
    end
    return __oldIndex(self, k)
end)

mt.__newindex = newcclosure(function(self, k, v)
    if not checkcaller() then
        if (game.IsA(self, "TextLabel") or game.IsA(self, "TextButton")) and k == "Text" then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            if string.find(v, getgenv().ExploiterName) then
                return __oldNewIndex(self, k, filterString(v, getgenv().ExploiterName, getgenv().PlayerName))
            end
        elseif (game.IsA(self, "ImageLabel") or game.IsA(self, "ImageButton")) and k == "Image" then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            if string.find(v, exploiterId) then
                return __oldNewIndex(self, k, filterString(v, exploiterId, playerId))
            elseif string.find(v, getgenv().ExploiterName) then
                return __oldNewIndex(self, k, filterString(v, getgenv().ExploiterName, getgenv().PlayerName))
            end
        elseif GUI and self == GUI.Spectate.PlayerBox.PlayerPin and (string.find(GUI.Spectate.PlayerBox.PlayerName.Text, getgenv().ExploiterName) or string.find(GUI.Spectate.PlayerBox.PlayerName.Text, getgenv().PlayerName)) then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end
            if not oldPin then
                oldPin = __oldIndex(self, "Image")
            end

            __oldNewIndex(self, "Image", getgenv().CB_Pin or oldPin)
            __oldNewIndex(self, "Visible", getgenv().CB_Pin and true or false)
            return
        end
    end

    return __oldNewIndex(self, k, v)
end)



if setreadonly then setreadonly(mt, true) else make_readonly(mt) end

if GUI then
    GUI.Scoreboard.DescendantAdded:Connect(function(v)
        if v.Name == "CTFrame" or v.Name == "TFrame" then
            repeat game:GetService("RunService").RenderStepped:Wait() until v.player.Text ~= "PLAYER"
            if (string.find(v.player.Text, getgenv().ExploiterName) or string.find(v.player.Text, getgenv().PlayerName)) and v:FindFirstChild("Pin") then
                if not rawget(spoofed, v) then
                    table.insert(spoofed, v)
                    DisableRBXSignal(v.Pin:GetPropertyChangedSignal("Image"))
                    DisableRBXSignal(v.Pin:GetPropertyChangedSignal("Visible"))
                    DisableRBXSignal(v.Pin.Changed)
                end
                if not oldPin then
                    oldPin = v.Pin.Image
                end
                
                v.Pin.Image = getgenv().CB_Pin or oldPin
                v.Pin:GetPropertyChangedSignal("Image"):Connect(function()
                    v.Pin.Image = getgenv().CB_Pin or oldPin
                end)
                v.Pin:GetPropertyChangedSignal("Visible"):Connect(function()
                    v.Pin.Visible = getgenv().CB_Pin and true or false
                end)
            end
        end
    end)
end
