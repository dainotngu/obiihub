
-- ObiiHub — Horizontal UI + Auto Config
-- Author: (qdai)

-- ===== Prevent multiple runs =====
if getgenv().ObiiHub_Running then return end
getgenv().ObiiHub_Running = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local PLAYER = Players.LocalPlayer

-- ===== CONFIG =====
local CORRECT_KEY = "day2hvnvlss"
local UI_NAME = "ObiiHub_UI_Horizontal_Config"

-- ===== KEY CHECK =====
if not getgenv().Key or tostring(getgenv().Key) ~= CORRECT_KEY then
    pcall(function() PLAYER:Kick("❌ Sai key. Vui lòng nhập đúng key!") end)
    return
end

-- ===== UTILS =====
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                obj[k] = v
            end
        end
    end
    return obj
end

-- ===== CONFIG FILE =====
local configFile = "ObiiHub_Config_"..PLAYER.UserId..".json"
local Config = {}

if isfile(configFile) then
    local success, data = pcall(readfile, configFile)
    if success then
        local ok, json = pcall(HttpService.JSONDecode, HttpService, data)
        if ok then Config = json end
    end
end

local function saveConfig()
    pcall(function()
        writefile(configFile, HttpService:JSONEncode(Config))
    end)
end

-- ===== SAFE REMOVE OLD UI =====
local old = CoreGui:FindFirstChild(UI_NAME)
if old then pcall(function() old:Destroy() end) end

-- ===== CREATE UI BASE (HORIZONTAL) =====
local screen = new("ScreenGui", {Name = UI_NAME, Parent = CoreGui, ResetOnSpawn = false})
local main = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 600, 0, 180),
    Position = UDim2.new(0.5, -300, 0.5, -90),
    BackgroundColor3 = Color3.fromRGB(255,170,190),
    Active = true,
    Draggable = true,
})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,12)})

-- Title
new("TextLabel", {
    Parent = main,
    Size = UDim2.new(1,0,0,36),
    BackgroundTransparency = 1,
    Text = "✨ ObiiHub Horizontal UI ✨",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamSemibold,
    TextScaled = true,
})

-- Close button
local btnClose = new("TextButton", {
    Parent = main,
    Size = UDim2.new(0, 40, 0, 36),
    Position = UDim2.new(1, -46, 0, 2),
    BackgroundColor3 = Color3.fromRGB(255,140,160),
    Text = "X",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
})
new("UICorner", {Parent = btnClose})

-- Info Box (left side)
local info = new("Frame", {
    Parent = main,
    Size = UDim2.new(0.45, 0, 1, -40),
    Position = UDim2.new(0,10,0,44),
    BackgroundColor3 = Color3.fromRGB(255,150,175),
})
new("UICorner", {Parent = info, CornerRadius = UDim.new(0,10)})

new("TextLabel", {
    Parent = info,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "📌 Thông tin:\n• FB: Obii Roblox\n• TikTok: @obii_hub\n• Tele: Obii Community",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamSemibold,
    TextScaled = true,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})

-- ===== BUTTON FACTORY (right side) =====
local function createToggleButton(parent, text, y, key)
    local b = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(0.5, -20, 0, 36),
        Position = UDim2.new(0.5, 10, 0, y),
        BackgroundColor3 = Color3.fromRGB(255,130,150),
        Text = text.." ("..tostring(Config[key] or false)..")",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 17,
    })
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})

    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text.." ("..tostring(Config[key])..")"
        saveConfig()
    end)
    return b
end

local playerUID = tostring(PLAYER.UserId or "0")
local b1 = createToggleButton(main, "Function 1", 50, "Function1")
local b2 = createToggleButton(main, "Function 2", 92, "Function2")
local b3 = createToggleButton(main, "Function 3", 134, "Function3")
local b4 = createToggleButton(main, "Function 4", 176, "Function4")

-- ===== FPS COUNTER =====
local fpsLabel = new("TextLabel", {
    Parent = screen,
    Size = UDim2.new(0,120,0,26),
    Position = UDim2.new(0,8,0,8),
    BackgroundColor3 = Color3.fromRGB(255,130,150),
    BackgroundTransparency = 0.15,
    Text = "FPS: ...",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
})
new("UICorner", {Parent = fpsLabel, CornerRadius = UDim.new(0,8)})

do
    local last = tick()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - last
        last = now
        if dt > 0 then
            fpsLabel.Text = "FPS: "..tostring(math.floor(1/dt + 0.5))
        end
    end)
end

-- ===== CLOSE CONFIRM =====
local confirm = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 260, 0, 140),
    Position = UDim2.new(0.5, -130, 0.5, -70),
    BackgroundColor3 = Color3.fromRGB(255,170,190),
    Visible = false,
    ZIndex = 1000,
})
new("UICorner", {Parent = confirm, CornerRadius = UDim.new(0,10)})

new("TextLabel", {
    Parent = confirm,
    Size = UDim2.new(1,0,0,44),
    BackgroundTransparency = 1,
    Text = "Bạn muốn tắt UI?",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
})

local yes = new("TextButton", {
    Parent = confirm,
    Size = UDim2.new(0.44,0,0,40),
    Position = UDim2.new(0.05,0,0.5,0),
    BackgroundColor3 = Color3.fromRGB(255,130,150),
    Text = "YES",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
})
new("UICorner", {Parent = yes, CornerRadius = UDim.new(0,8)})

local no = new("TextButton", {
    Parent = confirm,
    Size = UDim2.new(0.44,0,0,40),
    Position = UDim2.new(0.51,0,0.5,0),
    BackgroundColor3 = Color3.fromRGB(255,130,150),
    Text = "NO",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
})
new("UICorner", {Parent = no, CornerRadius = UDim.new(0,8)})

btnClose.MouseButton1Click:Connect(function() confirm.Visible = true end)
yes.MouseButton1Click:Connect(function() pcall(function() screen:Destroy() end) end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)

-- ===== CLEANUP =====
local function cleanup()
    if screen and screen.Parent then pcall(function() screen:Destroy() end) end
    getgenv().ObiiHub_Running = false
end
PLAYER.OnTeleport:Connect(cleanup)
PLAYER.AncestryChanged:Connect(function() if not PLAYER.Parent then cleanup() end end)

print("[ObiiHub] Test_Horizontal_Config.lua loaded successfully.")
