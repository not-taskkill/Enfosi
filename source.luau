-- will break somethime
-- just source because i dont want to obf ts

local COREGUI = game:GetService("CoreGui")
local NPCs = workspace.NPCs
local PARENT = nil

local function randomString()
	local t = {}
	for i = 1, math.random(10,20) do
		t[i] = string.char(math.random(32, 126))
	end
	return table.concat(t)
end

do
	if get_hidden_gui or gethui then
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		Main.Parent = (get_hidden_gui or gethui)()
		PARENT = Main
	elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		syn.protect_gui(Main)
		Main.Parent = COREGUI
		PARENT = Main
	elseif COREGUI:FindFirstChild("RobloxGui") then
		PARENT = COREGUI.RobloxGui
	else
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		Main.Parent = COREGUI
		PARENT = Main
	end
end

local function applycham(obj)
    local cham = Instance.new("Highlight", PARENT)
    cham.Name = randomString()
	cham.FillTransparency = 1
	cham.OutlineColor = Color3.fromRGB(157, 224, 255)
	cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	cham.Adornee = obj

    obj:GetPropertyChangedSignal("Parent"):Connect(function()
        if obj == nil or not obj:IsDescendantOf(NPCs) then
            pcall(game.Destroy, cham)
            return
        end
    end)
end

for _, obj in pairs(NPCs:GetChildren()) do
    if obj:GetAttribute("Points") or obj:GetAttribute("OutcomeDamageType") then
        task.spawn(applycham, obj)
    end
end

NPCs.ChildAdded:Connect(function(obj)
    if obj:GetAttribute("Points") or obj:GetAttribute("OutcomeDamageType") then
        task.spawn(applycham, obj)
    end
end)
