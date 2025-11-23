loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/87856de860ec1ca82e0e3382e59527d369787720f83e3b07c8abf7c74fe7b6ca/download"))()
loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/87856de860ec1ca82e0e3382e59527d369787720f83e3b07c8abf7c74fe7b6ca/download"))()
--=====================================================
-- FUNCTIONS MODULE
--=====================================================
getgenv().ObiiHubFunctions = getgenv().ObiiHubFunctions or {}
local Functions = getgenv().ObiiHubFunctions
local PLAYER = game.Players.LocalPlayer
local UID = tostring(PLAYER.UserId)

-- Ví dụ function
Functions["Function1"] = function() print("[Obii] Function1 executed for UID "..UID) end
Functions["Function2"] = function() print("[Obii] Function2 executed") end
Functions["Function3"] = function() print("[Obii] Function3 executed") end
Functions["Function4"] = function() print("[Obii] Function4 executed") end

-- Tạo nút chuyên nghiệp
getgenv().createObiiBtn = function(parent,text,y,key)
    local HttpService = game:GetService("HttpService")
    local configFile = "ObiiHub_Config_"..PLAYER.UserId..".json"
    local Config = {}
    if isfile(configFile) then
        local ok, read = pcall(readfile, configFile)
        if ok then
            local ok2, json = pcall(HttpService.JSONDecode,HttpService,read)
            if ok2 then Config=json end
        end
    end

    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Size = UDim2.new(0.5,-20,0,36)
    b.Position = UDim2.new(0.5,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(255,120,150)
    b.Text = text.." ("..tostring(Config[key] or false)..")"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 17
    local UIC = Instance.new("UICorner",b)
    UIC.CornerRadius = UDim.new(0,12)

    -- Click event
    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text.." ("..tostring(Config[key])..")"
        pcall(function() writefile(configFile,HttpService:JSONEncode(Config)) end)
        if Functions[key] then Functions[key]() end
    end)
    return b
end

return true
