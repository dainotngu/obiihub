--// Dùng HttpService lưu config
local HttpService = game:GetService("HttpService")
local UserId = game.Players.LocalPlayer.UserId
local ConfigFile = "ObiiHub_Config_"..UserId..".json"

--// Load config
local Config = {}
if isfile(ConfigFile) then
    Config = HttpService:JSONDecode(readfile(ConfigFile))
else
    Config = {}
end

local function SaveConfig()
    writefile(ConfigFile, HttpService:JSONEncode(Config))
end

----------------------------------------------------------------------
-- DANH SÁCH CHỨC NĂNG + FUNCTION TƯƠNG ỨNG
----------------------------------------------------------------------

local FUNCTIONS = {
    bananafruit = function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "1e3fd8607009cfa687e46d83"
getgenv().Setting = {
    ["Delay Hop"] = 5,
    ["Webhook"] = {
        ["url"] = "",
        ["Webhook Target Fruit"] = true,
        ["Webhook Store Fruit"] = {
            ["Rarity"] = {
                ["Mythical"] = true,
                ["Legendary"] = true, 
                ["Rare"] = false,
                ["Uncommon"] = false,
                ["Common"] = false,
            },
            ["Enabled"] = true, 
        },
        ["Webhook When Attack Factory"] = true,
        ["Webhook When Attack Raid Castle"] = true,
        ["Ping Discord"] = {
            ["Enabled"] = false, 
            ["Id Discord/Everyone"] = ""
        },
        ["Enabled"] = false,
    },
    ["Auto Random Fruit"] = true,
    ["Use Portal Teleport"] = false,
    ["Attacking"] = {
        ["Weapon"] = "Melee", -- Sword,Melee,Blox Fruit
        ["Raid Castle"] = true,
        ["Factory"] = true,
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/HopFruit.lua"))()
    end,

    bananakaitun = function()
      repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "1e3fd8607009cfa687e46d83"
    getgenv().SettingFarm ={
        ["Hide UI"] = false,
        ["Reset Teleport"] = {
            ["Enabled"] = false,
            ["Delay Reset"] = 3,
            ["Item Dont Reset"] = {
                ["Fruit"] = {
                    ["Enabled"] = true,
                    ["All Fruit"] = true, 
                    ["Select Fruit"] = {
                        ["Enabled"] = false,
                        ["Fruit"] = {},
                    },
                },
            },
        },
        ["White Screen"] = false,
        ["Lock Fps"] = {
            ["Enabled"] = false,
            ["FPS"] = 20,
        },
        ["Get Items"] = {
            ["Saber"] = true,
            ["Godhuman"] =  true,
            ["Skull Guitar"] = true,
            ["Mirror Fractal"] = true,
            ["Cursed Dual Katana"] = true,
            ["Upgrade Race V2-V3"] = true,
            ["Auto Pull Lever"] = true,
            ["Shark Anchor"] = true, --- if have cdk,sg,godhuman
        },
        ["Get Rare Items"] = {
            ["Rengoku"] = true,
            ["Dragon Trident"] = true, 
            ["Pole (1st Form)"] = true,
            ["Gravity Blade"]  = true,
        },
        ["Farm Fragments"] = {
            ["Enabled"]  = false,
            ["Fragment"] = 50000,
        },
        ["Auto Chat"] = {
            ["Enabled"] = true,
            ["Text"] = "tat ca cac dich vu ro.b.l.o.x i.b : Fumio Youngest.",
        },
        ["Auto Summon Rip Indra"] = true, --- auto buy haki and craft haki legendary 
        ["Select Hop"] = { -- 70% will have it
            ["Hop Server If Have Player Near"] = false, 
            ["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] = true, 
            ["Hop Find Dough King Get Mirror Fractal"] = true,
            ["Hop Find Raids Castle [CDK]"] = true,
            ["Hop Find Cake Queen [CDK]"] = true,
            ["Hop Find Soul Reaper [CDK]"] = true,
            ["Hop Find Darkbeard [SG]"] = true,
            ["Hop Find Mirage [ Pull Lever ]"] = true,
        },
        ["Farm Mastery"] = {
            ["Melee"] = true,
            ["Sword"] = true,
        },
        ["Buy Haki"] = {
            ["Enhancement"] = true,
            ["Skyjump"] = true,
            ["Flash Step"] = true,
            ["Observation"] = true,
        },
        ["Sniper Fruit Shop"] = {
            ["Enabled"] = false, -- Auto Buy Fruit in Shop Mirage and Normal
            ["Fruit"] = {""},
        },
        ["Lock Fruit"] = {},
        ["Webhook"] = {
            ["Enabled"] = false,
            ["WebhookUrl"] = "",
        }
    }
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()  
    end,

    bananabounty = function()
       repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv( ) . Key = "1e3fd8607009cfa687e46d83"
    getgenv().Setting = {
        ["Team"] = "Marines", --//If Marines Then Change Marines
        ["Method Click"] = {["Click Gun"] = false ,["Click Melee"] = false,["Click Sword"] = false,["Click Fruit"] = false, ["LowHealth"] = 5000, ["Delay Click"] = 0.6},
        ["Race V4"] = {["Enable"] = true},
        ["Webhook"] = {["Enabled"] = true,["Url Webhook"] = "https://discord.com/api/webhooks/1424658717651243029/R-uv4Y-tw5Kt-Zq06UL9pD3bURjjly6YlF7w-3VSqVIafw1GEhWriQ8bwK5Kyg8HREnJ"},
        ["Misc"] = {["AutoBuyRandomandStoreFruit"] = false,["AutoBuySurprise"] = false},
        ["SafeZone"] = {["Enable"] = true,["LowHealth"] = 3500,["MaxHealth"] = 9000,["Teleport Y"] = 3000},
        ["Method Use Skill"] = {["Use Random"] = true,["Use Number"] = false},
        ["Use random skill if player target low health"] = { --- suport only method use skill Number
            ["Enabled"] = true,
            ["Low Health"] = 4000,
        },
        ["Use Portal Teleport"] = false,
        ["Target Time"] = 20,
        ["Aim Prediction"] = 0.3,
        ["Select Region"] = {["Enabled"] = true,["Region"] = {["Singapore"] = true,["United States"] = false,["Netherlands"] = false,["Germany"] =false,["India"] = false,["Australia"] = false}},
        ["Ignore Devil Fruit"] = {"Human-Human","Portal-Portal"}, 
        ["Dodge Skill Player"] = true, --- Beta per 50% can dodge 
        ["Spam Dash"] = false, ---- risk can banned 1 day
        ["Equip Weapon"] = {
            ["Enabled"] = false,
            ["Melee"] = {
                ["Enabled"] = true,
                ["Name Weapon"] = "",
            },
            ["Sword"] = {
                ["Enabled"] = true,
                ["Name Weapon"] = "",
            },
            ["Gun"] = {
                ["Enabled"] = false,
                ["Name Weapon"] = "",
            },
        },
        ["Weapons"] = {
            ["Melee"] = {
                ["Enable"] = true,
                ["Skills"] = {
                    ["Z"] = {["Enable"] = true,["HoldTime"] = 0.3,["Number"] = 2},
                    ["X"] = {["Enable"] = true,["HoldTime"] = 0.3,["Number"] = 3},
                    ["C"] = {["Enable"] = true,["HoldTime"] = 0.5,["Number"] = 5},
                },
            },
            ["Blox Fruit"] = {
                ["Enable"] = true,
                ["Skills"] = {
                    ["Z"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 4},
                    ["X"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 6},
                    ["C"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 9},
                    ["V"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 0},
                    ["F"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 8},
                },
            },
            ["Gun"] = {
                ["Enable"] = true,
                ["Skills"] = {
                    ["Z"] = {["Enable"] = false,["HoldTime"] = 0.3,["Number"] = 1},
                    ["X"] = {["Enable"] = true,["HoldTime"] = 0.7,["Number"] = 7},
                },
            },
            ["Sword"] = {
                ["Enable"] = true,
                ["Skills"] = {
                    ["Z"] = {["Enable"] = true,["HoldTime"] =0.1,["Number"] = 0.4},
                    ["X"] = {["Enable"] = true,["HoldTime"] = 0.3,["Number"] = 0.4},
                },
            },
        }
    }
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/BananaCat-BountyEz.lua"))() 
    end,

    bananalevi = function()
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "1e3fd8607009cfa687e46d83"
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/BananaCat-KaitunLevi.lua"))()
    end,

    speedxhub = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() 
    end,
    
    bananav4 = function()
    getgenv().ConfigV4 = {
    ["Account Up Gear"] = {
      "",
    },
    ["Account Help"] = {
      "",

    },
    ["Method Kick"] = {
        ["End Moon"] = false,
    },
    ["Auto Join"] = false,
    ["Auto Change Race"] = {
        ["Enabled"] = false,
        ["Race"] = {""} --- Human,Skypiea,Fishman,Mink
    }
}
getgenv().Key = "1e3fd8607009cfa687e46d83"
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/NewV4Config.lua"))()
    end,
    
    bananahub = function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer 
getgenv().Key = "1e3fd8607009cfa687e46d83" 
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
    end
}

----------------------------------------------------------------------
-- UI
----------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 260, 0, 270)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

UIListLayout.Parent = Frame
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

----------------------------------------------------------------------
-- TẠO BUTTON BẬT/TẮT
----------------------------------------------------------------------

local RanOnce = {}

for name, func in pairs(FUNCTIONS) do
    
    if Config[name] == nil then
        Config[name] = false
    end

    local state = Config[name]

    local Toggle = Instance.new("TextButton")
    Toggle.Parent = Frame
    Toggle.Size = UDim2.new(0, 230, 0, 36)
    Toggle.BackgroundColor3 = state and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,60,60)
    Toggle.TextColor3 = Color3.fromRGB(255,255,255)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextSize = 14
    Toggle.Text = name .. ": " .. (state and "ON" or "OFF")

    -- Nếu ON → chạy luôn khi vào game
    if state and not RanOnce[name] then
        RanOnce[name] = true
        task.spawn(func)
    end

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Config[name] = state
        SaveConfig()

        Toggle.Text = name .. ": " .. (state and "ON" or "OFF")
        Toggle.BackgroundColor3 = state and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,60,60)

        -- Khi bật → chạy 1 lần duy nhất
        if state and not RanOnce[name] then
            RanOnce[name] = true
            task.spawn(func)
        end
    end)
end
