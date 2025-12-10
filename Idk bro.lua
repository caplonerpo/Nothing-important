
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function new(class, props)
    local o = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            o[k] = v
        end
    end
    return o
end

local gui = new("ScreenGui",{Name="OptimizedScanner",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=Players.LocalPlayer:WaitForChild("PlayerGui")})
local main = new("Frame",{Parent=gui,Size=UDim2.new(0.9,0,0.85,0),Position=UDim2.new(0.05,0,0.07,0),BackgroundTransparency=0.15,BackgroundColor3=Color3.fromRGB(20,20,20),AnchorPoint=Vector2.new(0,0)})
local left = new("Frame",{Parent=main,Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1})
local right = new("Frame",{Parent=main,Size=UDim2.new(0.55,0,1,0),Position=UDim2.new(0.45,0,0,0),BackgroundTransparency=1})

local title = new("TextLabel",{Parent=main,Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,Text="Optimized Scanner",Font=Enum.Font.SourceSansBold,TextSize=20,TextColor3=Color3.fromRGB(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center})
local controls = new("Frame",{Parent=left,Size=UDim2.new(1,0,0,0.07),Position=UDim2.new(0,0,0.05,0),BackgroundTransparency=1})

local scanButton = new("TextButton",{Parent=controls,Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0,0,0,0),Text="Scan",Font=Enum.Font.SourceSans,TextSize=16})
local refreshButton = new("TextButton",{Parent=controls,Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.32,0,0,0),Text="Rescan",Font=Enum.Font.SourceSans,TextSize=16})
local statusLabel = new("TextLabel",{Parent=controls,Size=UDim2.new(0.38,0,1,0),Position=UDim2.new(0.64,0,0,0),Text="Idle",Font=Enum.Font.SourceSans,TextSize=14,BackgroundTransparency=1,TextColor3=Color3.fromRGB(200,200,200),TextXAlignment=Enum.TextXAlignment.Right})

local listFrame = new("Frame",{Parent=left,Size=UDim2.new(1,0,0.9,0),Position=UDim2.new(0,0,0.12,0),BackgroundTransparency=1})
local scrolling = new("ScrollingFrame",{Parent=listFrame,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,1),ScrollBarThickness=6,BackgroundTransparency=1})
local uiList = new("UIListLayout",{Parent=scrolling,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)})
local pageControls = new("Frame",{Parent=left,Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0.96,0),BackgroundTransparency=1})

local prevBtn = new("TextButton",{Parent=pageControls,Size=UDim2.new(0.2,0,1,0),Position=UDim2.new(0,0,0,0),Text="Prev",Font=Enum.Font.SourceSans,TextSize=14})
local pageLabel = new("TextLabel",{Parent=pageControls,Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0.2,0,0,0),Text="Page 0/0",Font=Enum.Font.SourceSans,TextSize=14,BackgroundTransparency=1,TextColor3=Color3.fromRGB(220,220,220)})
local nextBtn = new("TextButton",{Parent=pageControls,Size=UDim2.new(0.2,0,1,0),Position=UDim2.new(0.8,0,0,0),Text="Next",Font=Enum.Font.SourceSans,TextSize=14})

local viewerTitle = new("TextLabel",{Parent=right,Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,Text="Viewer",Font=Enum.Font.SourceSansBold,TextSize=18,TextColor3=Color3.fromRGB(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center})
local viewer = new("TextBox",{Parent=right,Size=UDim2.new(1,0,0.92,0),Position=UDim2.new(0,0,0.06,0),ClearTextOnFocus=false,MultiLine=true,TextWrapped=false,Font=Enum.Font.Code,TextSize=14,Text="Select a script to view source",TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,BackgroundColor3=Color3.fromRGB(10,10,10),TextColor3=Color3.fromRGB(220,220,220)})
viewer.RichText = false
viewer.ReadOnly = true

local entries = {}
local pageSize = 40
local currentPage = 1
local totalPages = 1

local function clearList()
    for i,v in pairs(scrolling:GetChildren()) do
        if not (v:IsA("UIListLayout")) then
            v:Destroy()
        end
    end
end

local function updatePagination()
    totalPages = math.max(1, math.ceil(#entries / pageSize))
    currentPage = math.clamp(currentPage, 1, totalPages)
    pageLabel.Text = ("Page %d/%d"):format(currentPage, totalPages)
    clearList()
    local startI = (currentPage-1)*pageSize + 1
    local endI = math.min(#entries, currentPage*pageSize)
    for i=startI,endI do
        local e = entries[i]
        local name = e.Name or ("<unnamed "..i..">")
        local btn = new("TextButton",{Parent=scrolling,Size=UDim2.new(1,0,0,26),Text=("%d. %s (%s)"):format(i,name,e.ClassName),Font=Enum.Font.SourceSans,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})
        btn.BackgroundTransparency = 0.4
        btn.MouseButton1Click:Connect(function()
            statusLabel.Text = "Loading source..."
            local ok, src = pcall(function()
                if e:IsA("ModuleScript") or e:IsA("Script") or e:IsA("LocalScript") then
                    return e.Source
                end
                return nil
            end)
            if ok and src then
                viewer.Text = src
                statusLabel.Text = ("Loaded: %s"):format(name)
            else
                viewer.Text = "Unable to read Source or empty."
                statusLabel.Text = "No source accessible"
            end
        end)
    end
    RunService.Heartbeat:Wait()
    scrolling.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y + 6)
end

prevBtn.MouseButton1Click:Connect(function()
    currentPage = currentPage - 1
    updatePagination()
end)
nextBtn.MouseButton1Click:Connect(function()
    currentPage = currentPage + 1
    updatePagination()
end)

local scanning = false
local function scanAll()
    if scanning then return end
    scanning = true
    statusLabel.Text = "Scanning..."
    entries = {}
    clearList()
    local desc = game:GetDescendants()
    local n = #desc
    for i=1,n do
        local obj = desc[i]
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            table.insert(entries, obj)
        end
        if i % 200 == 0 then
            statusLabel.Text = ("Scanning... %d/%d"):format(i, n)
            RunService.Heartbeat:Wait()
        end
    end
    statusLabel.Text = ("Scan complete. %d scripts found"):format(#entries)
    currentPage = 1
    updatePagination()
    scanning = false
end

scanButton.MouseButton1Click:Connect(scanAll)
refreshButton.MouseButton1Click:Connect(scanAll)

scanAll()
