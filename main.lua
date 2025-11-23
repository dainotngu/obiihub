-- ===========================
-- ObiiHub Loader + Functions
-- ===========================

-- 1️⃣ Load UI trực tuyến
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dainotngu/ObiiUi/refs/heads/main/ObiiUi.lua"))()
end)

if not success then
    warn("[Obii] Không thể load UI:", err)
end

-- 2️⃣ Định nghĩa Functions (tách riêng)
getgenv().ObiiHubFunctions = getgenv().ObiiHubFunctions or {}

local PLAYER = game:GetService("Players").LocalPlayer
local playerUID = tostring(PLAYER.UserId or "0")

-- Function 1
getgenv().ObiiHubFunctions["Function 1"] = function()
    if playerUID == "123456" then
        print("[Obii] Function 1 -> logic A for UID "..playerUID)
    else
        print("[Obii] Function 1 executed for UID "..playerUID)
    end
end

-- Function 2
getgenv().ObiiHubFunctions["Function 2"] = function()
    print("[Obii] Function 2 executed")
end

-- Function 3
getgenv().ObiiHubFunctions["Function 3"] = function()
    print("[Obii] Function 3 executed")
end

-- Function 4
getgenv().ObiiHubFunctions["Function 4"] = function()
    print("[Obii] Function 4 executed")
end

-- 3️⃣ Gắn function vào UI (nếu UI đã load xong)
-- UI.lua cần gọi getgenv().ObiiHubFunctions[name] khi click nút
-- Ví dụ trong UI.lua:
-- btn.MouseButton1Click:Connect(function()
--     local f = getgenv().ObiiHubFunctions[name]
--     if f then f() end
-- end)

print("[ObiiHub] Loader + Functions setup complete.")
