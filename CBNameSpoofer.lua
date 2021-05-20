local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")


local playerId = Players:GetUserIdFromNameAsync(getgenv().playername)

local GUI
if game.GameId == 115797356 then
    GUI = LocalPlayer.PlayerGui.GUI
end

local mt = getrawmetatable(game)
local __oldNewIndex = mt.__newindex

if setreadonly then setreadonly(mt, false) else make_writeable(mt) end

mt.__newindex = newcclosure(function(self, k, v)
    if (game.IsA(self, "TextLabel") or game.IsA(self, "TextButton")) and k == "Text" and string.find(v, getgenv().playername) then
        return __oldNewIndex(self, k, string.gsub(v, getgenv().playername, getgenv().newname))
    elseif (game.IsA(self, "ImageLabel") or game.IsA(self, "ImageButton")) and k == "Image" then
        if string.find(v, playerId) then
            return __oldNewIndex(self, k, string.gsub(v, playerId, getgenv().newpfp))
        elseif string.find(v, getgenv().playername) then
            return __oldNewIndex(self, k, string.gsub(v, getgenv().playername, Players.GetNameFromUserIdAsync(Players, playerId)))
        end
    end

    return __oldNewIndex(self, k, v)
end)

if setreadonly then setreadonly(mt, true) else make_readonly(mt) end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        end)
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v:GetPropertyChangedSignal("Text"):Connect(function()
            v.Text = string.gsub(v.Text, getgenv().playername, getgenv().newname)
        end)
    end
end)

if GUI then
    for i,v in pairs(GUI.TopRight:GetChildren()) do
        if v:FindFirstChild("Killer") and v:FindFirstChild("Victim") then
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
