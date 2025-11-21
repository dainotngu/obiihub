-- CONFIG THEO UID
local HttpService = game:GetService("HttpService")
local UserId = game.Players.LocalPlayer.UserId
local ConfigFile = "ObiiHub_Config_"..UserId..".json"
local Config = isfile(ConfigFile) and HttpService:JSONDecode(readfile(ConfigFile)) or {}
local function Save() writefile(ConfigFile, HttpService:JSONEncode(Config)) end

-- DANH SÁCH CHỨC NĂNG
local FUNCTIONS = {
    bananafruit = function() print("Chạy bananafruit") end,
    bananakaitun = function() print("Chạy bananakaitun") end,
    bananabounty = function() print("Chạy bananabounty") end,
}

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,250,0,200)
Frame.Position = UDim2.new(0.5,-125,0.5,-100)
Frame.BackgroundColor3 = Color3.fromRGB(255,100,150)
Frame.BackgroundTransparency = 0.2

-- Nút đóng/mở UI
local BtnShow = Instance.new("TextButton", ScreenGui)
BtnShow.Size = UDim2.new(0,120,0,30)
BtnShow.Position = UDim2.new(0.5,-60,0,20)
BtnShow.Text = "Hiện/Ẩn UI"
BtnShow.BackgroundColor3 = Color3.fromRGB(255,150,180)
local Visible = true
BtnShow.MouseButton1Click:Connect(function() Visible = not Visible; Frame.Visible = Visible end)

-- Tạo nút cho mỗi function
for name, func in pairs(FUNCTIONS) do
    if Config[name]==nil then Config[name]=false end
    local state = Config[name]
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0,220,0,35)
    Btn.Position = UDim2.new(0,15,0,#Frame:GetChildren()*40)
    Btn.BackgroundColor3 = state and Color3.fromRGB(255,150,180) or Color3.fromRGB(255,200,220)
    Btn.Text = name..": "..(state and "ON" or "OFF")
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Config[name] = state
        Save()
        Btn.Text = name..": "..(state and "ON" or "OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(255,150,180) or Color3.fromRGB(255,200,220)
        if state then task.spawn(func) end
    end)
    if state then task.spawn(func) end
end
