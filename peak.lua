
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Script Scanner",
	LoadingTitle = "Loading",
	LoadingSubtitle = "Ready",
	ConfigurationSaving = {Enabled = false}
})

local ScanTab = Window:CreateTab("Scan", 4483362458)
local SearchTab = Window:CreateTab("Search", 4483362458)
local LocalScriptsTab = Window:CreateTab("LocalScripts", 4483362458)
local ModuleScriptsTab = Window:CreateTab("ModuleScripts", 4483362458)
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)
local RemoteEventsTab = Window:CreateTab("RemoteEvents", 4483362458)

local EditorTab = Window:CreateTab("Editor", 4483362458)
local EditorBox = EditorTab:CreateInput({
	Name = "Viewer",
	PlaceholderText = "",
	RemoveTextAfterFocusLost = false,
	Callback = function() end
})

local function showScript(t)
	EditorBox:Set(t)
end

local allButtons = {}

local function makeButton(tab, name, callback)
	local b = tab:CreateButton({
		Name = name,
		Callback = callback
	})
	table.insert(allButtons, {button=b, name=name})
end

local function safeWrite(path, data)
	local ok = pcall(function()
		writefile(path, data)
	end)
	return ok
end

local function saveScript(obj)
	if not obj.Source then return end
	local full = obj:GetFullName()
	local safe = full:gsub("[^%w_]+","_")
	local file = safe..".lua"
	safeWrite(file, obj.Source)
end

local function chunkedScan(list, chunk, callback)
	local n = 0
	for _,obj in ipairs(list) do
		callback(obj)
		n += 1
		if n >= chunk then
			n = 0
			task.wait()
		end
	end
end

local function scanAll()
	local list = game:GetDescendants()
	chunkedScan(list, 60, function(obj)
		if obj:IsA("LocalScript") then
			makeButton(LocalScriptsTab, obj:GetFullName(), function()
				if obj.Source then showScript(obj.Source) end
			end)
			saveScript(obj)
		elseif obj:IsA("ModuleScript") then
			makeButton(ModuleScriptsTab, obj:GetFullName(), function()
				if obj.Source then showScript(obj.Source) end
			end)
			saveScript(obj)
		elseif obj:IsA("Script") then
			makeButton(ScriptsTab, obj:GetFullName(), function()
				if obj.Source then showScript(obj.Source) end
			end)
			saveScript(obj)
		elseif obj:IsA("RemoteEvent") then
			makeButton(RemoteEventsTab, obj:GetFullName(), function()
				obj:FireServer()
			end)
		end
	end)
end

ScanTab:CreateButton({
	Name = "Scan + Save (No Freeze)",
	Callback = function()
		scanAll()
	end
})

SearchTab:CreateInput({
	Name = "Search",
	PlaceholderText = "Type script name",
	RemoveTextAfterFocusLost = false,
	Callback = function(txt)
		for _,entry in ipairs(allButtons) do
			if txt == "" then
				entry.button.Visible = true
			else
				entry.button.Visible = entry.name:lower():find(txt:lower()) ~= nil
			end
		end
	end
})
