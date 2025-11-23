-- CoDon (ObiiHub Function Manager) - full file
-- Paste this whole file into your raw file (CoDon) and load via raw link
-- Features: sidebar list, add/edit/delete functions, run, import/export (base64), auto-save per UID
-- Author: (you)

-- Prevent multiple runs
if getgenv().ObiiHub_Running then return end
getgenv().ObiiHub_Running = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local PLAYER = Players.LocalPlayer

-- Config
local CORRECT_KEY = "day2hvnvlss"
local UI_NAME = "ObiiHub_FunctionManager"
local CONFIG_FILE = "ObiiHub_Functions_" .. PLAYER.UserId .. ".json"

-- Key check
if not getgenv().Key or tostring(getgenv().Key) ~= CORRECT_KEY then
    pcall(function() PLAYER:Kick("❌ Sai key. Vui lòng nhập đúng key!") end)
    return
end

-- Utils
local function safeCall(fn, ...) local ok, res = pcall(fn, ...) return ok, res end
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then obj.Parent = v else obj[k] = v end
        end
    end
    return obj
end

-- Pure Lua Base64 encode/decode (no bit ops)
local _b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_encode(data)
    return ((data:gsub('.', function(x)
        local r=''
        local c = string.byte(x)
        for i=7,0,-1 do
            r = r .. (math.floor(c / 2^i) % 2)
        end
        return r
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if #x < 6 then return '' end
        local c=0
        for i=1,6 do c = c*2 + (x:sub(i,i)=='1' and 1 or 0) end
        return _b:sub(c+1,c+1)
    end) .. ({ '', '==', '=' })[#data%3 + 1]
end

local function base64_decode(data)
    data = string.gsub(data, '[^'.._b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local pos = string.find(_b, x) - 1
        local bin = ''
        for i=5,0,-1 do
            bin = bin .. (math.floor(pos / 2^i) % 2)
        end
        return bin
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c=0
        for i=1,8 do c = c*2 + (x:sub(i,i) == '1' and 1 or 0) end
        return string.char(c)
    end))
end

-- Config load/save
local FunctionsData = {} -- array of {id, name, code, enabled}
local function newId() return tostring(tick()) .. "_" .. tostring(math.random(1000,999999)) end

local function loadConfig()
    if isfile(CONFIG_FILE) then
        local ok, raw = pcall(readfile, CONFIG_FILE)
        if ok and raw then
            local ok2, parsed = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok2 and type(parsed) == "table" then
                FunctionsData = parsed
            end
        end
    end
end

local function saveConfig()
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(FunctionsData))
    end)
end

loadConfig()

-- SAFE remove existing UI
local old = CoreGui:FindFirstChild(UI_NAME)
if old then pcall(function() old:Destroy() end) end

-- Build UI
local screen = new("ScreenGui", {Name = UI_NAME, Parent = CoreGui, ResetOnSpawn = false})
local main = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 820, 0, 380),
    Position = UDim2.new(0.5, -410, 0.5, -190),
    BackgroundColor3 = Color3.fromRGB(255,185,200),
    Active = true,
    Draggable = true
})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,14)})

-- Title + close
local title = new("TextLabel", {
    Parent = main, Size = UDim2.new(1,0,0,44), BackgroundTransparency = 1,
    Text = "✨ ObiiHub Function Manager ✨", TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamSemibold, TextScaled = true
})
local closeBtn = new("TextButton", {
    Parent = main, Size = UDim2.new(0,44,0,32), Position = UDim2.new(1,-52,0,6),
    BackgroundColor3 = Color3.fromRGB(255,120,150), Text = "X", TextColor3 = Color3.fromRGB(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 18
})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,8)})
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(255,100,130) end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(255,120,150) end)
closeBtn.MouseButton1Click:Connect(function()
    for i=1,10 do main.BackgroundTransparency = i*0.08; wait(0.02) end
    pcall(function() screen:Destroy() end)
end)

-- Layout: sidebar + editor
local sidebar = new("Frame", {Parent = main, Size = UDim2.new(0, 260, 1, -60), Position = UDim2.new(0,12,0,48), BackgroundColor3 = Color3.fromRGB(255,155,175)})
new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0,10)})
local editorFrame = new("Frame", {Parent = main, Size = UDim2.new(1,-292,1,-60), Position = UDim2.new(0,284,0,48), BackgroundColor3 = Color3.fromRGB(255,150,170)})
new("UICorner", {Parent = editorFrame, CornerRadius = UDim.new(0,10)})

-- Sidebar header
local sbHeader = new("Frame", {Parent = sidebar, Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1})
local addBtn = new("TextButton", {Parent = sbHeader, Text = "➕ Add", Size = UDim2.new(0.48, -6, 0, 30), Position = UDim2.new(0,6,0,5), BackgroundColor3 = Color3.fromRGB(255,120,150), Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1,1,1)})
new("UICorner", {Parent = addBtn, CornerRadius = UDim.new(0,8)})
local importBtn = new("TextButton", {Parent = sbHeader, Text = "📥 Import", Size = UDim2.new(0.48, -6, 0, 30), Position = UDim2.new(0.52,6,0,5), BackgroundColor3 = Color3.fromRGB(255,120,150), Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1,1,1)})
new("UICorner", {Parent = importBtn, CornerRadius = UDim.new(0,8)})

-- Sidebar scroll
local sbScroll = new("ScrollingFrame", {Parent = sidebar, Size = UDim2.new(1,-12,1,-52), Position = UDim2.new(0,6,0,46), CanvasSize = UDim2.new(0,0,1,0), ScrollBarThickness = 6, BackgroundTransparency = 1})
local sbLayout = new("UIListLayout", {Parent = sbScroll, Padding = UDim.new(0,6)})
sbLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Editor header controls
local editorHeader = new("Frame", {Parent = editorFrame, Size = UDim2.new(1,0,0,44), BackgroundTransparency = 1})
local nameBox = new("TextBox", {Parent = editorHeader, PlaceholderText = "Function name...", Size = UDim2.new(0.6, -8, 0, 34), Position = UDim2.new(0,8,0,4), BackgroundColor3 = Color3.fromRGB(255,200,210), ClearTextOnFocus = false, Text = "", Font = Enum.Font.Gotham, TextSize = 16})
new("UICorner", {Parent = nameBox, CornerRadius = UDim.new(0,6)})
local saveBtn = new("TextButton", {Parent = editorHeader, Text = "💾 Save", Size = UDim2.new(0.14, -6, 0, 34), Position = UDim2.new(0.62, 6, 0, 4), BackgroundColor3 = Color3.fromRGB(255,120,150), Font = Enum.Font.GothamBold})
new("UICorner", {Parent = saveBtn, CornerRadius = UDim.new(0,6)})
local runBtn = new("TextButton", {Parent = editorHeader, Text = "▶ Run", Size = UDim2.new(0.12, -6, 0, 34), Position = UDim2.new(0.76, 6, 0, 4), BackgroundColor3 = Color3.fromRGB(100,200,150), Font = Enum.Font.GothamBold})
new("UICorner", {Parent = runBtn, CornerRadius = UDim.new(0,6)})
local delBtn = new("TextButton", {Parent = editorHeader, Text = "🗑 Delete", Size = UDim2.new(0.12, -6, 0, 34), Position = UDim2.new(0.88, 6, 0, 4), BackgroundColor3 = Color3.fromRGB(255,90,110), Font = Enum.Font.GothamBold})
new("UICorner", {Parent = delBtn, CornerRadius = UDim.new(0,6)})

-- Editor textbox
local codeBox = new("TextBox", {Parent = editorFrame, Size = UDim2.new(1,-16,1,-64), Position = UDim2.new(0,8,0,56), BackgroundColor3 = Color3.fromRGB(255,220,225), ClearTextOnFocus = false, Text = "-- Write your function body here.\n-- Example:\n-- print('hello from function')", Font = Enum.Font.Code, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextScaled = false, TextSize = 14})
new("UICorner", {Parent = codeBox, CornerRadius = UDim.new(0,6)})

-- Helper: refresh sidebar
local function refreshSidebar()
    for _,child in pairs(sbScroll:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
    for idx,fn in ipairs(FunctionsData) do
        local row = new("Frame", {Parent = sbScroll, Size = UDim2.new(1, -12, 0, 48), BackgroundTransparency = 1})
        local btn = new("TextButton", {Parent = row, Size = UDim2.new(0.66, 0, 1, 0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(255,200,210), Text = fn.name or ("Function "..idx), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamSemibold, TextSize = 16})
        new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
        local enableBtn = new("TextButton", {Parent = row, Size = UDim2.new(0.16, -4, 0.7, 0), Position = UDim2.new(0.66, 6, 0.15, 0), BackgroundColor3 = (fn.enabled and Color3.fromRGB(120,200,140) or Color3.fromRGB(200,120,140)), Text = (fn.enabled and "ON" or "OFF"), Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(1,1,1)})
        new("UICorner", {Parent = enableBtn, CornerRadius = UDim.new(0,6)})
        local runMini = new("TextButton", {Parent = row, Size = UDim2.new(0.16, -4, 0.7, 0), Position = UDim2.new(0.82, 6, 0.15, 0), BackgroundColor3 = Color3.fromRGB(100,200,150), Text = "Run", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(1,1,1)})
        new("UICorner", {Parent = runMini, CornerRadius = UDim.new(0,6)})

        btn.MouseButton1Click:Connect(function()
            nameBox.Text = fn.name or ""
            codeBox.Text = fn.code or ""
            for _,ch in pairs(sbScroll:GetChildren()) do
                if ch:IsA("Frame") then
                    for _,n in pairs(ch:GetChildren()) do
                        if n:IsA("TextButton") then n.BackgroundColor3 = Color3.fromRGB(255,200,210) end
                    end
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(255,230,235)
            main:SetAttribute("SelectedId", fn.id)
        end)

        enableBtn.MouseButton1Click:Connect(function()
            fn.enabled = not fn.enabled
            enableBtn.Text = (fn.enabled and "ON" or "OFF")
            enableBtn.BackgroundColor3 = (fn.enabled and Color3.fromRGB(120,200,140) or Color3.fromRGB(200,120,140))
            saveConfig()
        end)

        runMini.MouseButton1Click:Connect(function()
            if fn.code and fn.code:match("%S") then
                local ok, chunk = pcall(loadstring, "return function()\n" .. fn.code .. "\nend")
                if not ok or not chunk then ok, chunk = pcall(loadstring, fn.code) end
                if ok and chunk then
                    local s, res = pcall(chunk)
                    if not s then warn("[ObiiHub] Run error:", res) end
                else
                    warn("[ObiiHub] Compile error:", chunk)
                end
            end
        end)
    end
    local canvasY = 0
    for _,v in pairs(sbScroll:GetChildren()) do if v:IsA("Frame") then canvasY = canvasY + v.Size.Y.Offset + 6 end end
    sbScroll.CanvasSize = UDim2.new(0,0,0, math.max(canvasY, 1))
end

local function getSelected() return main:GetAttribute("SelectedId") end

-- Modals
local function promptAdd()
    local modal = new("Frame", {Parent = screen, Size = UDim2.new(0,420,0,260), Position = UDim2.new(0.5,-210,0.5,-130), BackgroundColor3 = Color3.fromRGB(255,240,245)})
    new("UICorner", {Parent = modal, CornerRadius = UDim.new(0,10)})
    new("TextLabel", {Parent = modal, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, Text = "Add New Function", Font = Enum.Font.GothamSemibold, TextScaled = true})
    local nameInput = new("TextBox", {Parent = modal, Size = UDim2.new(1,-20,0,34), Position = UDim2.new(0,10,0,48), PlaceholderText = "Function name", Text = ""})
    new("UICorner", {Parent = nameInput, CornerRadius = UDim.new(0,6)})
    local codeInput = new("TextBox", {Parent = modal, Size = UDim2.new(1,-20,0,120), Position = UDim2.new(0,10,0,92), Text = "-- function body\n", ClearTextOnFocus = false, MultiLine = true, Font = Enum.Font.Code, TextSize = 14})
    new("UICorner", {Parent = codeInput, CornerRadius = UDim.new(0,6)})
    local okBtn = new("TextButton", {Parent = modal, Text = "Add", Size = UDim2.new(0.48, -6, 0, 36), Position = UDim2.new(0,10,1,-46), BackgroundColor3 = Color3.fromRGB(120,200,140)})
    new("UICorner", {Parent = okBtn, CornerRadius = UDim.new(0,6)})
    local cancelBtn = new("TextButton", {Parent = modal, Text = "Cancel", Size = UDim2.new(0.48, -6, 0, 36), Position = UDim2.new(0.52,6,1,-46), BackgroundColor3 = Color3.fromRGB(255,120,150)})
    new("UICorner", {Parent = cancelBtn, CornerRadius = UDim.new(0,6)})

    okBtn.MouseButton1Click:Connect(function()
        local name = tostring(nameInput.Text or ""):gsub("^%s*(.-)%s*$", "%1")
        local code = tostring(codeInput.Text or "")
        if name == "" then nameInput.PlaceholderText = "Please enter a name"; return end
        local id = newId()
        table.insert(FunctionsData, 1, {id = id, name = name, code = code, enabled = false})
        saveConfig()
        refreshSidebar()
        modal:Destroy()
    end)
    cancelBtn.MouseButton1Click:Connect(function() modal:Destroy() end)
end

local function promptImport()
    local modal = new("Frame", {Parent = screen, Size = UDim2.new(0,420,0,170), Position = UDim2.new(0.5,-210,0.5,-85), BackgroundColor3 = Color3.fromRGB(255,240,245)})
    new("UICorner", {Parent = modal, CornerRadius = UDim.new(0,10)})
    new("TextLabel", {Parent = modal, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, Text = "Import Function (paste code)", Font = Enum.Font.GothamSemibold, TextScaled = true})
    local codeInput = new("TextBox", {Parent = modal, Size = UDim2.new(1,-20,0,72), Position = UDim2.new(0,10,0,44), Text = "", ClearTextOnFocus = false})
    new("UICorner", {Parent = codeInput, CornerRadius = UDim.new(0,6)})
    local okBtn = new("TextButton", {Parent = modal, Text = "Import", Size = UDim2.new(0.48, -6, 0, 34), Position = UDim2.new(0,10,1,-46), BackgroundColor3 = Color3.fromRGB(120,200,140)})
    new("UICorner", {Parent = okBtn, CornerRadius = UDim.new(0,6)})
    local cancelBtn = new("TextButton", {Parent = modal, Text = "Cancel", Size = UDim2.new(0.48, -6, 0, 34), Position = UDim2.new(0.52,6,1,-46), BackgroundColor3 = Color3.fromRGB(255,120,150)})
    new("UICorner", {Parent = cancelBtn, CornerRadius = UDim.new(0,6)})

    okBtn.MouseButton1Click:Connect(function()
        local payload = tostring(codeInput.Text or "")
        if payload == "" then return end
        local ok, decoded = pcall(base64_decode, payload)
        if not ok or not decoded then warn("[ObiiHub] Invalid import code"); return end
        local ok2, parsed = pcall(HttpService.JSONDecode, HttpService, decoded)
        if not ok2 or type(parsed) ~= "table" then warn("[ObiiHub] Import JSON invalid"); return end
        local name = tostring(parsed.name or "ImportedFunction")
        local code = tostring(parsed.code or "")
        local id = newId()
        table.insert(FunctionsData, 1, {id = id, name = name, code = code, enabled = false})
        saveConfig()
        refreshSidebar()
        modal:Destroy()
    end)
    cancelBtn.MouseButton1Click:Connect(function() modal:Destroy() end)
end

local function exportSelected()
    local sel = getSelected()
    if not sel then warn("[ObiiHub] No function selected to export"); return end
    local found
    for _,fn in ipairs(FunctionsData) do if fn.id == sel then found = fn; break end end
    if not found then warn("[ObiiHub] Selected function not found"); return end
    local payload = HttpService:JSONEncode({name = found.name or "", code = found.code or ""})
    local encoded = base64_encode(payload)
    local modal = new("Frame", {Parent = screen, Size = UDim2.new(0,560,0,180), Position = UDim2.new(0.5,-280,0.5,-90), BackgroundColor3 = Color3.fromRGB(255,245,250)})
    new("UICorner", {Parent = modal, CornerRadius = UDim.new(0,10)})
    new("TextLabel", {Parent = modal, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, Text = "Share code (copy)", Font = Enum.Font.GothamSemibold, TextScaled = true})
    local outBox = new("TextBox", {Parent = modal, Size = UDim2.new(1,-20,0,88), Position = UDim2.new(0,10,0,44), Text = encoded, ClearTextOnFocus = false})
    new("UICorner", {Parent = outBox, CornerRadius = UDim.new(0,6)})
    local okBtn = new("TextButton", {Parent = modal, Text = "Close", Size = UDim2.new(0.3, -6, 0, 34), Position = UDim2.new(0.7,6,1,-46), BackgroundColor3 = Color3.fromRGB(255,120,150)})
    new("UICorner", {Parent = okBtn, CornerRadius = UDim.new(0,6)})
    okBtn.MouseButton1Click:Connect(function() modal:Destroy() end)
end

-- Save, Run, Delete behaviors
saveBtn.MouseButton1Click:Connect(function()
    local sel = getSelected()
    local name = tostring(nameBox.Text or ""):gsub("^%s*(.-)%s*$", "%1")
    local code = tostring(codeBox.Text or "")
    if name == "" then nameBox.PlaceholderText = "Enter function name"; return end
    if sel then
        for i,fn in ipairs(FunctionsData) do if fn.id == sel then fn.name = name; fn.code = code; break end end
    else
        local id = newId()
        table.insert(FunctionsData, 1, {id = id, name = name, code = code, enabled = false})
        main:SetAttribute("SelectedId", id)
    end
    saveConfig()
    refreshSidebar()
end)

runBtn.MouseButton1Click:Connect(function()
    local sel = getSelected()
    if not sel then warn("[ObiiHub] No function selected to run"); return end
    local found
    for _,fn in ipairs(FunctionsData) do if fn.id == sel then found = fn; break end end
    if not found or (found.code or "") == "" then warn("[ObiiHub] Function code empty or not found"); return end
    local ok, chunk = pcall(loadstring, "return function()\n" .. found.code .. "\nend")
    if not ok or not chunk then ok, chunk = pcall(loadstring, found.code) end
    if not ok or not chunk then warn("[ObiiHub] Compile error:", chunk); return end
    local success, result = pcall(chunk)
    if not success then warn("[ObiiHub] Run error:", result) end
end)

delBtn.MouseButton1Click:Connect(function()
    local sel = getSelected()
    if not sel then return end
    for i,fn in ipairs(FunctionsData) do if fn.id == sel then table.remove(FunctionsData, i); break end end
    main:SetAttribute("SelectedId", nil)
    nameBox.Text = ""; codeBox.Text = ""
    saveConfig()
    refreshSidebar()
end)

addBtn.MouseButton1Click:Connect(promptAdd)
importBtn.MouseButton1Click:Connect(promptImport)

-- Export shortcut Ctrl+E
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
        exportSelected()
    end
end)

-- Auto-save on code change (debounced)
local debounceSave = false
codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if debounceSave then return end
    debounceSave = true
    delay(0.8, function()
        local sel = getSelected()
        if sel then
            for _,fn in ipairs(FunctionsData) do
                if fn.id == sel then fn.code = codeBox.Text; fn.name = tostring(nameBox.Text or fn.name); break end
            end
            saveConfig()
            refreshSidebar()
        end
        debounceSave = false
    end)
end)

-- initial populate
refreshSidebar()

-- FPS Counter
local fpsLabel = new("TextLabel", {Parent = screen, Size = UDim2.new(0,120,0,28), Position = UDim2.new(0,12,0,8), BackgroundColor3 = Color3.fromRGB(255,140,160), BackgroundTransparency = 0.15, Text = "FPS: ...", TextColor3 = Color3.fromRGB(1,1,1), Font = Enum.Font.GothamBold, TextSize = 14})
new("UICorner", {Parent = fpsLabel, CornerRadius = UDim.new(0,8)})
do
    local last = tick()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - last
        last = now
        if dt > 0 then fpsLabel.Text = "FPS: "..tostring(math.floor(1/dt + 0.5)) end
    end)
end

-- Cleanup
local function cleanup()
    if screen and screen.Parent then pcall(function() screen:Destroy() end) end
    getgenv().ObiiHub_Running = false
end
PLAYER.OnTeleport:Connect(cleanup)
PLAYER.AncestryChanged:Connect(function() if not PLAYER.Parent then cleanup() end end)

print("[ObiiHub] CoDon Function Manager loaded. Add functions from sidebar ➕ Add.")
