local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")


local playerId = Players:GetUserIdFromNameAsync(getgenv().playername)

local spoofed = {}

local GUI
if game.GameId == 115797356 then
    GUI = LocalPlayer.PlayerGui.GUI
end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if string.find(tostring(v.Text), getgenv().playername) then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            for i2,v2 in pairs(getconnections(v:GetPropertyChangedSignal("Text"))) do
                v2:Disable()
            end
            for i2,v2 in pairs(getconnections(v.Changed)) do
                v2:Disable()
            end
        end
        
        v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        end)
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if string.find(v.Text, getgenv().playername) then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            for i2,v2 in pairs(getconnections(v:GetPropertyChangedSignal("Text"))) do
                v2:Disable()
            end
            for i2,v2 in pairs(getconnections(v.Changed)) do
                v2:Disable()
            end
        end

        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        end)
    end
end)

if GUI then
    for i,v in pairs(GUI.TopRight:GetChildren()) do
        if v:FindFirstChild("Killer") and v:FindFirstChild("Victim") then
            if not rawget(spoofed, v) then
                table.insert(spoofed, v)
            end

            for i2,v2 in pairs(getconnections(v.Killer:GetPropertyChangedSignal("Text"))) do
                v2:Disable()
            end
            for i2,v2 in pairs(getconnections(v.Outline:GetPropertyChangedSignal("Visible"))) do
                v2:Disable()
            end
            for i2,v2 in pairs(getconnections(v.Killer.Changed)) do
                v2:Disable()
            end
            for i2,v2 in pairs(getconnections(v.Outline.Changed)) do
                v2:Disable()
            end
            
            v.Killer:GetPropertyChangedSignal("Text"):Connect(function()
                if string.find(v.Killer.Text, getgenv().newname) then
                    v.Outline.Visible = true
                end
            end)
            
            v.Outline:GetPropertyChangedSignal("Visible"):Connect(function()
                if string.find(v.Killer.Text, getgenv().newname) or string.find(v.Victim.Text, getgenv().newname) then
                    v.Outline.Visible = true
                end
            end)
        end
    end
end

local mt = getrawmetatable(game)
local __oldIndex = mt.__index
local __oldNewIndex = mt.__newindex

if setreadonly then setreadonly(mt, false) else make_writeable(mt) end

mt.__index = newcclosure(function(self, k)
    if not checkcaller() then
        if (k == "Text" or k == "Image") and rawget(spoofed, self) then
            if k == "Text" then
                return getgenv().playername
            elseif k == "Image" then
                local x = string.gsub(string.gsub(__oldIndex(self, k), playerId, exploiterId), getgenv().PlayerName, getgenv().ExploiterName)
                return x
            end
        end
    end
    return __oldIndex(self, k)
end)

mt.__newindex = newcclosure(function(self, k, v)
    if (game.IsA(self, "TextLabel") or game.IsA(self, "TextButton")) and k == "Text" and string.find(v, getgenv().playername) then
        if not rawget(spoofed, v) then
            table.insert(spoofed, v)
        end

        return __oldNewIndex(self, k, string.gsub(v, getgenv().playername, getgenv().newname))
    elseif (game.IsA(self, "ImageLabel") or game.IsA(self, "ImageButton")) and k == "Image" then
        if not rawget(spoofed, v) then
            table.insert(spoofed, v)
        end

        if string.find(v, playerId) then
            return __oldNewIndex(self, k, string.gsub(v, playerId, getgenv().newpfp))
        elseif string.find(v, getgenv().playername) then
            return __oldNewIndex(self, k, string.gsub(v, getgenv().playername, Players.GetNameFromUserIdAsync(Players, playerId)))
        end
    end

    return __oldNewIndex(self, k, v)
end)

if setreadonly then setreadonly(mt, true) else make_readonly(mt) end
