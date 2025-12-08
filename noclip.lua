local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({Name = "Noclip Control"})
local ToggleState = false

local function setNoclip(state)
    ToggleState = state
    if state then
        RunService.Stepped:Connect(function()
            local char = Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

Window:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        setNoclip(v)
    end
})

local username = Players.LocalPlayer.Name
