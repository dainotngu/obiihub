-- Test.lua
-- ObiiHub — Minimal, Stable, Full features (Ready for GitHub)
-- Author: (you)
-- Notes: Set getgenv().Key before executing (or when using loadstring)

-- ======= Prevent multiple runs =======
if getgenv().ObiiHub_Running then
    return
end
getgenv().ObiiHub_Running = true

-- ======= CONFIG =======
local CORRECT_KEY = "day2hvnvlss"       -- modify here if you want
local UI_NAME = "ObiiHub_UI_v1"         -- name used in CoreGui
local PLAYER = game:GetService("Players").LocalPlayer
local RUN_SERVICE = game:GetService("RunService")

-- ======= KEY CHECK =======
-- must set: getgenv().Key = "..." before running loadstring
if not getgenv().Key or tostring(getgenv().Key) ~= CORRECT_KEY then
    -- gentle fallback: try warn before kick (some games block Kick)
    pcall(function()
        PLAYER:Kick("❌ Sai key. Vui lòng nhập đúng key!")
    end)
    return
end

-- ======= SAFE REMOVE EXISTING UI =======
local coregui = game:GetService("CoreGui")
local old = coregui:FindFirstChild(UI_NAME)
if old then
    pcall(function() old:Destroy() end)
end

-- ======= UTILS =======
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

-- ======= CREATE UI BASE =======
local screen = new("ScreenGui", {Name = UI_NAME, Parent = coregui, ResetOnSpawn = false})
local main = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 340, 0, 380),
    Position = UDim2.new(0.5, -170, 0.5, -190),
    BackgroundColor3 = Color3.fromRGB(255,170,190),
    Active = true,
    Draggable = true,
})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,12)})

-- Title
local title = new("TextLabel", {
    Parent = main,
    Size = UDim2.new(1,0,0,36),
    BackgroundTransparency = 1,
    Text = "✨ ObiiHub Rose UI ✨",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextScaled = false,
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

-- Info box (FB / TikTok / Tele)
local info = new("Frame", {
    Parent = main,
    Size = UDim2.new(1, -20, 0, 88),
    Position = UDim2.new(0,10,0,44),
    BackgroundColor3 = Color3.fromRGB(255,150,175),
})
new("UICorner", {Parent = info, CornerRadius = UDim.new(0,10)})
local infoText = new("TextLabel", {
    Parent = info,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "📌 Thông tin:\n• FB: Obii Roblox\n• TikTok: @obii_hub\n• Tele: Obii Community",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.Gotham,
    TextSize = 15,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Padding = Enum.Padding.None,
})

-- ======= BUTTON FACTORY =======
local function createButton(parent, text, y)
    local b = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, y),
        BackgroundColor3 = Color3.fromRGB(255,130,150),
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 17,
    })
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,8)})
    return b
end

-- ======= FUNCTION BUTTONS (placeholders) =======
local playerUID = tostring(PLAYER.UserId or "0")
local b1 = createButton(main, "Function 1", 150)
local b2 = createButton(main, "Function 2", 196)
local b3 = createButton(main, "Function 3", 242)
local b4 = createButton(main, "Function 4", 288)
local b5 = createButton(main, "Function 5", 334)

-- Example: you can replace these with your actual logic
b1.MouseButton1Click:Connect(function()
    -- Example auto logic by PlayerUID
    if playerUID == "123456" then
        -- run custom logic A
        print("[Obii] Function1 -> logic A for UID "..playerUID)
    else
        print("[Obii] Function1 pressed. UID:", playerUID)
    end
end)

b2.MouseButton1Click:Connect(function()
    print("[Obii] Function2 pressed")
end)
b3.MouseButton1Click:Connect(function()
    print("[Obii] Function3 pressed")
end)
b4.MouseButton1Click:Connect(function()
    print("[Obii] Function4 pressed")
end)
b5.MouseButton1Click:Connect(function()
    print("[Obii] Function5 pressed")
end)

-- ======= FPS COUNTER (safe) =======
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
    -- Use RenderStepped for best precision but calculate delta safely
    local last = tick()
    RUN_SERVICE.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - last
        last = now
        if dt > 0 then
            local f = math.floor(1 / dt + 0.5)
            fpsLabel.Text = "FPS: "..tostring(f)
        end
    end)
end

-- ======= WHITE SCREEN (overlay) =======
local whiteOverlay = new("Frame", {
    Parent = screen,
    Size = UDim2.new(1,0,1,0),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.new(1,1,1),
    Visible = false,
    ZIndex = 999,
})

-- add a toggle button (placed as last function button for convenience)
local wsBtn = createButton(main, "Màn Trắng (ON/OFF)", 334)
-- move the old b5 down so we don't overlap (we created two at same pos: keep both)
b5.Position = UDim2.new(0,10,0, 378)
wsBtn.MouseButton1Click:Connect(function()
    whiteOverlay.Visible = not whiteOverlay.Visible
end)

-- ======= CLOSE CONFIRM UI =======
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

btnClose.MouseButton1Click:Connect(function()
    confirm.Visible = true
end)
yes.MouseButton1Click:Connect(function()
    pcall(function() screen:Destroy() end)
end)
no.MouseButton1Click:Connect(function()
    confirm.Visible = false
end)

-- ======= SAFE CLEANUP ON GAME CLOSE =======
-- (if the player leaves or UI should be removed)
local function cleanup()
    if screen and screen.Parent then
        pcall(function() screen:Destroy() end)
    end
    getgenv().ObiiHub_Running = false
end
PLAYER.OnTeleport:Connect(cleanup)
GAME = game
GAME:GetService("Players").LocalPlayer.AncestryChanged:Connect(function()
    if not GAME:GetService("Players").LocalPlayer then
        cleanup()
    end
end)

-- ======= END OF FILE =======
print("[ObiiHub] Test.lua loaded successfully.")
