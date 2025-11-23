loadstring(game:HttpGet("https://raw.githubusercontent.com/dainotngu/ObiiUi/refs/heads/main/ObiiUi.lua"))()
-- Functions.lua
-- Bảng chứa tất cả logic function

local Functions = {}
local PLAYER = game:GetService("Players").LocalPlayer
local playerUID = tostring(PLAYER.UserId or "0")

-- Function 1
Functions["Function 1"] = function()
    if playerUID == "123456" then
        print("[Obii] Function 1 -> logic A for UID "..playerUID)
    else
        print("[Obii] Function 1 executed for UID "..playerUID)
    end
end

-- Function 2
Functions["Function 2"] = function()
    print("[Obii] Function 2 executed")
end

-- Function 3
Functions["Function 3"] = function()
    print("[Obii] Function 3 executed")
end

-- Function 4
Functions["Function 4"] = function()
    print("[Obii] Function 4 executed")
end

return Functions
