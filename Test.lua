if getgenv().ObiiHub_UI then return end
getgenv().ObiiHub_UI = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local PLAYER = Players.LocalPlayer
local UI_NAME = "ObiiHub_ProMax_UI"

-- REMOVE OLD UI
local old = CoreGui:FindFirstChild(UI_NAME)
if old then pcall(function() old:Destroy() end) end

-- UTILITY
local function new(class,props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    return o
end

-- MAIN SCREEN
local screen = new("ScreenGui",{Name=UI_NAME,Parent=CoreGui,ResetOnSpawn=false})
local main = new("Frame",{
    Parent=screen,
    Size=UDim2.new(0,850,0,500),
    Position=UDim2.new(0.5,-425,0.5,-250),
    BackgroundColor3=Color3.fromRGB(255,180,200),
    Active=true,Draggable=true
})
new("UICorner",{Parent=main,CornerRadius=UDim.new(0,12)})

-- TITLE
new("TextLabel",{
    Parent=main,
    Size=UDim2.new(1,0,0,40),
    BackgroundTransparency=1,
    Text="✨ ObiiHub Ultimate Pro Max ✨",
    TextColor3=Color3.fromRGB(255,255,255),
    TextScaled=true,
    Font=Enum.Font.GothamBold
})

-- CLOSE BUTTON
local close = new("TextButton",{
    Parent=main,
    Size=UDim2.new(0,40,0,36),
    Position=UDim2.new(1,-46,0,2),
    BackgroundColor3=Color3.fromRGB(255,130,150),
    Text="X",
    TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold,
    TextSize=18
})
new("UICorner",{Parent=close})
close.MouseEnter:Connect(function() close.BackgroundColor3 = Color3.fromRGB(255,100,120) end)
close.MouseLeave:Connect(function() close.BackgroundColor3 = Color3.fromRGB(255,130,150) end)
close.MouseButton1Click:Connect(function()
    for i=1,10 do main.BackgroundTransparency=main.BackgroundTransparency+0.1 wait(0.03) end
    pcall(function() screen:Destroy() end)
    getgenv().ObiiHub_UI=false
end)

-- SEARCH BAR
local searchBox = new("TextBox",{
    Parent=main,
    Size=UDim2.new(0.95,0,0,30),
    Position=UDim2.new(0.025,0,0,10),
    PlaceholderText = "🔍 Search function...",
    Text = "",
    BackgroundColor3 = Color3.fromRGB(255,200,200),
    TextColor3 = Color3.fromRGB(0,0,0),
    Font = Enum.Font.Gotham,
    TextSize = 18
})
new("UICorner",{Parent=searchBox})

-- SCROLL FRAME
local scroll = new("ScrollingFrame",{
    Parent = main,
    Size=UDim2.new(1,-20,1,-60),
    Position=UDim2.new(0,10,0,50),
    CanvasSize=UDim2.new(0,0,0,0),
    BackgroundColor3=Color3.fromRGB(255,150,175),
    ScrollBarThickness=6
})
new("UICorner",{Parent=scroll})

local layout = new("UIListLayout",{Parent=scroll,Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder})
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
end)

-- CONFIG
local configFile = "ObiiHub_Config_"..PLAYER.UserId..".json"
local Config = {}
if isfile(configFile) then
    local ok, read = pcall(readfile, configFile)
    if ok then
        local ok2, json = pcall(function() return HttpService:JSONDecode(read) end)
        if ok2 then Config = json end
    end
end
local function save() writefile(configFile,HttpService:JSONEncode(Config)) end

-- FUNCTIONS
local Functions = getgenv().ObiiHubFunctions or {}
local btns = {}

local function createBtn(name,key)
    local b = new("TextButton",{
        Parent = scroll,
        Size = UDim2.new(1,-20,0,40),
        BackgroundColor3=Color3.fromRGB(255,120,150),
        Text=name.." ("..tostring(Config[key] or false)..")",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold,
        TextSize=16
    })
    new("UICorner",{Parent=b})

    -- Tooltip
    if Functions[key].desc then
        local tip = new("TextLabel",{
            Parent=b,
            Size=UDim2.new(1,0,0,20),
            Position=UDim2.new(0,0,1,0),
            BackgroundTransparency=0.6,
            BackgroundColor3=Color3.fromRGB(0,0,0),
            Text=Functions[key].desc,
            TextColor3=Color3.fromRGB(255,255,255),
            TextSize=14,
            Visible=false
        })
        b.MouseEnter:Connect(function() tip.Visible=true end)
        b.MouseLeave:Connect(function() tip.Visible=false end)
    end

    -- Click
    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = name.." ("..tostring(Config[key])..")"
        save()
        if Functions[key].func then Functions[key].func() end
    end)

    btns[key]=b
    return b
end

-- AUTO CREATE BUTTONS
local keys={}
for k,_ in pairs(Functions) do table.insert(keys,k) end
table.sort(keys)
for _,k in ipairs(keys) do createBtn(k,k) end

-- SEARCH FUNCTIONALITY
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt=searchBox.Text:lower()
    for k,b in pairs(btns) do
        b.Visible = string.find(k:lower(),txt) ~= nil
    end
end)

-- FPS Counter
local fpsLabel = new("TextLabel",{
    Parent=screen,
    Size=UDim2.new(0,120,0,26),
    Position=UDim2.new(0,8,0,50),
    BackgroundColor3=Color3.fromRGB(255,130,150),
    BackgroundTransparency=0.15,
    Text="FPS: ...",
    TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold,
    TextSize=14
})
new("UICorner",{Parent=fpsLabel})

do
    local last=tick()
    RunService.RenderStepped:Connect(function()
        local now=tick()
        local dt=now-last
        last=now
        if dt>0 then fpsLabel.Text="FPS: "..math.floor(1/dt+0.5) end
    end)
end

-- CLEANUP
local function cleanup()
    if screen and screen.Parent then pcall(function() screen:Destroy() end) end
    getgenv().ObiiHub_UI=false
end
PLAYER.OnTeleport:Connect(cleanup)
PLAYER.AncestryChanged:Connect(function() if not PLAYER.Parent then cleanup() end end)

