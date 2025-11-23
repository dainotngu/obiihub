-- ObiiHub_ProHorizontal_Full.lua
-- Horizontal Professional UI with Functions, Auto Config & FPS
-- Author: (you)

-- Prevent multiple runs
if getgenv().ObiiHub_Running then return end
getgenv().ObiiHub_Running = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local PLAYER = Players.LocalPlayer

-- CONFIG
local CORRECT_KEY = "day2hvnvlss"
local UI_NAME = "ObiiHub_ProUI"

-- KEY CHECK
if not getgenv().Key or tostring(getgenv().Key) ~= CORRECT_KEY then
    pcall(function() PLAYER:Kick("❌ Sai key. Vui lòng nhập đúng key!") end)
    return
end

-- UTILS
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

-- CONFIG FILE
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

-- SAFE REMOVE OLD UI
local old = CoreGui:FindFirstChild(UI_NAME)
if old then pcall(function() old:Destroy() end) end

-- SCREEN & MAIN
local screen = new("ScreenGui", {Name = UI_NAME, Parent = CoreGui, ResetOnSpawn = false})
local main = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 620, 0, 200),
    Position = UDim2.new(0.5, -310, 0.5, -100),
    BackgroundColor3 = Color3.fromRGB(255,180,200),
    Active = true,
    Draggable = true,
})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,12)})

-- TITLE
local title = new("TextLabel", {
    Parent = main,
    Size = UDim2.new(1,0,0,36),
    BackgroundTransparency = 1,
    Text = "✨ ObiiHub Pro UI ✨",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamSemibold,
    TextScaled = true,
})

-- CLOSE BUTTON
local btnClose = new("TextButton", {
    Parent = main,
    Size = UDim2.new(0,40,0,36),
    Position = UDim2.new(1,-46,0,2),
    BackgroundColor3 = Color3.fromRGB(255,130,150),
    Text = "X",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
})
new("UICorner", {Parent = btnClose})

btnClose.MouseEnter:Connect(function() btnClose.BackgroundColor3 = Color3.fromRGB(255,100,120) end)
btnClose.MouseLeave:Connect(function() btnClose.BackgroundColor3 = Color3.fromRGB(255,130,150) end)
btnClose.MouseButton1Click:Connect(function()
    local confirm = new("Frame", {
        Parent = screen,
        Size = UDim2.new(0, 280, 0, 120),
        Position = UDim2.new(0.5, -140, 0.5, -60),
        BackgroundColor3 = Color3.fromRGB(255,170,190),
        ZIndex = 1000,
    })
    new("UICorner", {Parent = confirm, CornerRadius=UDim.new(0,12)})
    local label = new("TextLabel",{
        Parent = confirm,
        Size = UDim2.new(1,0,0,50),
        BackgroundTransparency=1,
        Text="Bạn có chắc muốn tắt UI?",
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold,
        TextSize=18
    })
    local yes = new("TextButton",{
        Parent = confirm,
        Size = UDim2.new(0.44,0,0,36),
        Position = UDim2.new(0.05,0,0.55,0),
        BackgroundColor3=Color3.fromRGB(255,130,150),
        Text="YES",
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold,
        TextSize=16,
    })
    new("UICorner",{Parent=yes, CornerRadius=UDim.new(0,8)})
    local no = new("TextButton",{
        Parent = confirm,
        Size = UDim2.new(0.44,0,0,36),
        Position = UDim2.new(0.51,0,0.55,0),
        BackgroundColor3=Color3.fromRGB(255,130,150),
        Text="NO",
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold,
        TextSize=16,
    })
    new("UICorner",{Parent=no, CornerRadius=UDim.new(0,8)})

    yes.MouseButton1Click:Connect(function()
        pcall(function() screen:Destroy() end)
        getgenv().ObiiHub_Running=false
    end)
    no.MouseButton1Click:Connect(function() confirm:Destroy() end)
end)

-- INFO FRAME
local infoFrame = new("Frame", {
    Parent = main,
    Size = UDim2.new(1,-20,1,-44),
    Position = UDim2.new(0,10,0,44),
    BackgroundColor3 = Color3.fromRGB(255,150,175),
})
new("UICorner",{Parent=infoFrame, CornerRadius=UDim.new(0,10)})

new("TextLabel",{
    Parent = infoFrame,
    Size = UDim2.new(0.45,0,1,0),
    BackgroundTransparency=1,
    Text="📌 Thông tin:\n• FB: Obii Roblox\n• TikTok: @obii_hub\n• Tele: Obii Community",
    TextColor3=Color3.new(1,1,1),
    Font=Enum.Font.GothamSemibold,
    TextScaled=true,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top
})

-- FUNCTIONS
getgenv().ObiiHubFunctions = getgenv().ObiiHubFunctions or {}
local playerUID = tostring(PLAYER.UserId or "0")
local Functions = getgenv().ObiiHubFunctions

Functions["Function1"] = function() print("[Obii] Function1 executed for UID "..playerUID) end
Functions["Function2"] = function() print("[Obii] Function2 executed") end
Functions["Function3"] = function() print("[Obii] Function3 executed") end
Functions["Function4"] = function() print("[Obii] Function4 executed") end

-- BUTTON FACTORY
local function createBtn(parent, text, y, key)
    local b = new("TextButton", {
        Parent=parent,
        Size=UDim2.new(0.5,-20,0,36),
        Position=UDim2.new(0.5,10,0,y),
        BackgroundColor3=Color3.fromRGB(255,120,150),
        Text=text.." ("..tostring(Config[key] or false)..")",
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold,
        TextSize=17,
    })
    new("UICorner",{Parent=b, CornerRadius=UDim.new(0,8)})
    b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(255,90,130) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(255,120,150) end)
    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text.." ("..tostring(Config[key])..")"
        saveConfig()
        if Functions[key] then Functions[key]() end
        b.BackgroundColor3=Color3.fromRGB(255,200,200)
        wait(0.1)
        b.BackgroundColor3=Color3.fromRGB(255,120,150)
    end)
    return b
end

createBtn(infoFrame,"Function 1",20,"Function1")
createBtn(infoFrame,"Function 2",70,"Function2")
createBtn(infoFrame,"Function 3",120,"Function3")
createBtn(infoFrame,"Function 4",170,"Function4")

-- FPS COUNTER
local fpsLabel = new("TextLabel",{
    Parent=screen,
    Size=UDim2.new(0,120,0,26),
    Position=UDim2.new(0,8,0,8),
    BackgroundColor3=Color3.fromRGB(255,130,150),
    BackgroundTransparency=0.15,
    Text="FPS: ...",
    TextColor3=Color3.new(1,1,1),
    Font=Enum.Font.GothamBold,
    TextSize=14,
})
new("UICorner",{Parent=fpsLabel, CornerRadius=UDim.new(0,8)})

do
    local last = tick()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now-last
        last = now
        if dt>0 then fpsLabel.Text="FPS: "..tostring(math.floor(1/dt+0.5)) end
    end)
end

-- CLEANUP
local function cleanup()
    if screen and screen.Parent then pcall(function() screen:Destroy() end) end
    getgenv().ObiiHub_Running=false
end
PLAYER.OnTeleport:Connect(cleanup)
PLAYER.AncestryChanged:Connect(function() if not PLAYER.Parent then cleanup() end end)

print("[ObiiHub] Pro Horizontal Full UI loaded successfully.")
