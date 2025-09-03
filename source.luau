-- will break somethime
-- just source because i dont want to obf ts

if not game:IsLoaded() then game.Loaded:Wait() end

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local NPCs = workspace:WaitForChild("NPCs")
local CHAM_COLOR = Color3.fromRGB(179, 255, 230)
local PARENT = nil

local function randomString()
	local t = {}
	for i = 1, math.random(10,20) do
		t[i] = string.char(math.random(32, 126))
	end
	return table.concat(t)
end

local function pdestroy(obj)
	pcall(game.Destroy, obj)
end

if get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	local Main = Instance.new("ScreenGui")
	Main.Name = randomString()
	Main.Parent = hiddenUI()
	PARENT = Main
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
	local Main = Instance.new("ScreenGui")
	Main.Name = randomString()
	syn.protect_gui(Main)
	Main.Parent = CoreGui
	PARENT = Main
elseif CoreGui:FindFirstChild("RobloxGui") then
	PARENT = CoreGui.RobloxGui
else
	local Main = Instance.new("ScreenGui")
	Main.Name = randomString()
	Main.Parent = CoreGui
	PARENT = Main
end

local function applycham(obj : Model)
	if not (obj:IsDescendantOf(NPCs)) then return end

	local cham = Instance.new("Highlight")
	cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	cham.FillColor = CHAM_COLOR
	cham.OutlineColor = CHAM_COLOR
	cham.FillTransparency = 0.65
	cham.Parent = PARENT
	cham.Adornee = obj

	local humanoid = obj:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Once(function()
			pdestroy(cham)
			return
		end)
	end

	task.spawn(function()
		repeat 
			for _, inst in next, obj:GetDescendants() do
				if inst:IsA("Highlight") then
					inst:Destroy()
				end
			end
			task.wait(.5)
		until not obj:IsDescendantOf(NPCs)
	end)

	obj.AncestryChanged:Connect(function(_, parent)
		if parent ~= NPCs then
			pdestroy(cham)
			return
		end
	end)
end


for _, obj in next, NPCs:GetChildren() do
	if obj:IsA("Model") and obj:GetAttribute("Points") then
		task.spawn(applycham, obj)
	end
end

NPCs.ChildAdded:Connect(function(obj)
	if obj:IsA("Model") and obj:GetAttribute("Points") then
		task.spawn(applycham, obj)
	end
end)

StarterGui:SetCore("SendNotification", {
	Title = "enfosis script | esp",
	Text = "this script probably will break later ✌️",
	Duration = 5
})
