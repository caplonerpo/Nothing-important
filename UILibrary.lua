local TweenService = game:GetService(“TweenService”) local
UserInputService = game:GetService(“UserInputService”)

local TabNames = { “Main”, “Combat”, “Visuals”, “Player”, “World”,
“Settings” }

local Library = {} Library.Windows = {}

local ScreenGui = Instance.new(“ScreenGui”) ScreenGui.IgnoreGuiInset =
true ScreenGui.ResetOnSpawn = false ScreenGui.Parent =
game.Players.LocalPlayer:WaitForChild(“PlayerGui”)

local MainFrame = Instance.new(“Frame”) MainFrame.Size = UDim2.new(0,
650, 0, 400) MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0 MainFrame.Parent = ScreenGui

local Corner = Instance.new(“UICorner”, MainFrame) Corner.CornerRadius =
UDim.new(0, 12)

local Sidebar = Instance.new(“Frame”) Sidebar.Size = UDim2.new(0, 120,
1, 0) Sidebar.BackgroundColor3 = Color3.fromRGB(17,17,17)
Sidebar.BorderSizePixel = 0 Sidebar.Parent = MainFrame

Instance.new(“UICorner”, Sidebar).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new(“UIListLayout”, Sidebar) TabList.Padding =
UDim.new(0, 6) TabList.HorizontalAlignment =
Enum.HorizontalAlignment.Center TabList.VerticalAlignment =
Enum.VerticalAlignment.Top

local ContentFrame = Instance.new(“Frame”) ContentFrame.Position =
UDim2.new(0, 130, 0, 0) ContentFrame.Size = UDim2.new(1, -130, 1, 0)
ContentFrame.BackgroundTransparency = 1 ContentFrame.Parent = MainFrame

local Tabs = {} local SelectedTab = nil

local function SwitchToTab(tab) if SelectedTab then
SelectedTab.Page.Visible = false TweenService:Create(SelectedTab.Button,
TweenInfo.new(0.2), {BackgroundColor3 =
Color3.fromRGB(17,17,17)}):Play() end

    SelectedTab = tab
    tab.Page.Visible = true

    TweenService:Create(tab.Button, TweenInfo.new(0.2),
        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()

end

for _, name in ipairs(TabNames) do local TabButton =
Instance.new(“TextButton”) TabButton.Text = name TabButton.Size =
UDim2.new(1, -20, 0, 40) TabButton.Position = UDim2.new(0, 10, 0, 0)
TabButton.BackgroundColor3 = Color3.fromRGB(17,17,17)
TabButton.TextColor3 = Color3.fromRGB(255,255,255) TabButton.Font =
Enum.Font.GothamMedium TabButton.TextSize = 15 TabButton.Parent =
Sidebar

    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentFrame

    Tabs[name] = {Button = TabButton, Page = Page}

    TabButton.MouseButton1Click:Connect(function()
        SwitchToTab(Tabs[name])
    end)

end

task.wait() SwitchToTab(Tabs[TabNames[1]])

function Library:CreateSection(tab, title) local Target = Tabs[tab] if
not Target then return warn(“Invalid tab:”, tab) end

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 220)
    Container.Position = UDim2.new(0, 10, 0, 10)
    Container.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Container.BorderSizePixel = 0
    Container.Parent = Target.Page
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Text = title
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 15
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 6)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Parent = Container

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 6)
    List.Parent = Container
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.VerticalAlignment = Enum.VerticalAlignment.Top
    List.HorizontalAlignment = Enum.HorizontalAlignment.Left

    return Container

end

return Library
