local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Speed of legend" .. Fluent.Version,
    SubTitle = "by RunnerHub",
    TabWidth = 100,
    Size = UDim2.fromOffset(420, 320),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "RunnerHub.....",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

    Tabs.Main:AddParagraph({
        Title = "Rebirths",
        Content = "Your Rebirths Count is: " .. tostring(game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value)
    })
end -- ปิดบล็อก 'do'

-- Dropdown สำหรับเลือก Orb
local OrbDropdown = Tabs.Main:AddDropdown("OrbDropdown", {
    Title = "Select Orb",
    Values = {"Orange Orb", "Red Orb", "Blue Orb", "Yellow Orb", "Gem", "All Orbs"},
    Multi = false,
    Default = "Orange Orb",
})

OrbDropdown:OnChanged(function(Value)
    print("Orb Selected:", Value)
    _G.SelectedOrb = Value
end)

-- Toggle สำหรับเปิด/ปิดการทำงาน
local OrbToggle = Tabs.Main:AddToggle("OrbToggle", {Title = "Enable Orb Collection", Default = false})

OrbToggle:OnChanged(function(Value)
    _G.OrbEnabled = Value
    print("Orb Collection Toggled:", Value)
end)

-- ฟังก์ชันสำหรับเก็บ Orb
_G.OrbEnabled = false
_G.SelectedOrb = "Orange Orb"

spawn(function()
    while true do
        wait()
        if _G.OrbEnabled and _G.SelectedOrb then
            if _G.SelectedOrb == "All Orbs" then
                -- เก็บทุก Orb
                local allOrbs = {"Orange Orb", "Red Orb", "Blue Orb", "Yellow Orb", "Gem"}
                for _, orb in ipairs(allOrbs) do
                    local args = {
                        [1] = "collectOrb",
                        [2] = orb,
                        [3] = "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                end
            else
                -- เก็บ Orb ที่เลือก
                local args = {
                    [1] = "collectOrb",
                    [2] = _G.SelectedOrb,
                    [3] = "City"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
            end
        end
    end
end)

-- Toggle สำหรับเปิด/ปิดออโต้รีเบิร์ธ
local RebirthToggle = Tabs.Main:AddToggle("RebirthToggle", {Title = "Enable Auto Rebirth", Default = false})

-- ตัวแปรควบคุมการทำงาน
_G.AutoRebirth = false

RebirthToggle:OnChanged(function(Value)
    _G.AutoRebirth = Value
    print("Auto Rebirth Enabled:", Value)
end)

spawn(function()
    while true do
        wait(1) -- ตั้งค่าหน่วงเวลาการทำงาน
        if _G.AutoRebirth then
            local args = {
                [1] = "rebirthRequest"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthEvent"):FireServer(unpack(args))
            print("Rebirth Requested")
        end
    end
end)

-- Toggle สำหรับเปิด/ปิดออโต้เก็บกล่อง
local RewardToggle = Tabs.Main:AddToggle("RewardChests", {Title = "Enable Auto Reward Chests", Default = false})

-- ตัวแปรควบคุมการทำงาน
_G.RewardChests = false

RewardToggle:OnChanged(function(Value)
    _G.RewardChests = Value
    print("Auto Reward Chests Enabled:", Value)
end)

spawn(function()
    while true do
        wait(1) -- ตั้งค่าหน่วงเวลา
        if _G.RewardChests then
            -- เก็บกล่อง 100
            local args1 = {
                [1] = workspace:WaitForChild("rewardChests"):WaitForChild("rewardChest")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("collectCourseChestRemote"):InvokeServer(unpack(args1))
            print("Collected 100 Chest")

            -- เก็บกล่อง 500
            local args2 = {
                [1] = workspace:WaitForChild("rewardChests"):WaitForChild("rewardChest")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("collectCourseChestRemote"):InvokeServer(unpack(args2))
            print("Collected 500 Chest")

            -- เก็บ Golden Chest
            local args3 = {
                [1] = "Golden Chest"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("checkChestRemote"):InvokeServer(unpack(args3))
            print("Collected Golden Chest")

            -- เก็บ Free Gift
            local args4 = {
                [1] = "claimGift",
                [2] = 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("freeGiftClaimRemote"):InvokeServer(unpack(args4))
            print("Claimed Free Gift")
        end
    end
end)



Options.MyToggle:SetValue(false)

-- Addons:
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})