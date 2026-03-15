-- [[ Jez Menu v2 - Updated UI ]] --

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("JezMenu") then
    game.CoreGui.JezMenu:Destroy()
end

local espEnabled = true
local currentSpeed = 16

-- 1. ИНТЕРФЕЙС
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JezMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Jez"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20 -- Увеличил заголовок
local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 10)

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 26
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Секция Спидхака
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0, 0, 0.15, 0)
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Real Speed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.Font = Enum.Font.Code
SpeedLabel.TextSize = 16

local AddSpeedBtn = Instance.new("TextButton")
AddSpeedBtn.Parent = MainFrame
AddSpeedBtn.Size = UDim2.new(0.4, 0, 0, 35)
AddSpeedBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
AddSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AddSpeedBtn.Text = "+1"
AddSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
AddSpeedBtn.Font = Enum.Font.GothamBold
AddSpeedBtn.TextSize = 18 -- УВЕЛИЧЕНО
Instance.new("UICorner", AddSpeedBtn).CornerRadius = UDim.new(0, 6)

local SubSpeedBtn = Instance.new("TextButton")
SubSpeedBtn.Parent = MainFrame
SubSpeedBtn.Size = UDim2.new(0.4, 0, 0, 35)
SubSpeedBtn.Position = UDim2.new(0.525, 0, 0.25, 0)
SubSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SubSpeedBtn.Text = "-1"
SubSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
SubSpeedBtn.Font = Enum.Font.GothamBold
SubSpeedBtn.TextSize = 18 -- УВЕЛИЧЕНО
Instance.new("UICorner", SubSpeedBtn).CornerRadius = UDim.new(0, 6)

-- Кнопка ESP
local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = MainFrame
ESPBtn.Size = UDim2.new(0.85, 0, 0, 45) -- Увеличил кнопку
ESPBtn.Position = UDim2.new(0.075, 0, 0.42, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
ESPBtn.Text = "ESP: ON"
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 18 -- УВЕЛИЧЕНО
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 8)

-- СЕКЦИЯ СКРИПТОВ
local ScriptTitle = Instance.new("TextLabel")
ScriptTitle.Parent = MainFrame
ScriptTitle.Position = UDim2.new(0, 0, 0.62, 0)
ScriptTitle.Size = UDim2.new(1, 0, 0, 20)
ScriptTitle.BackgroundTransparency = 1
ScriptTitle.Text = "EXTERNAL SCRIPTS"
ScriptTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
ScriptTitle.Font = Enum.Font.GothamBold
ScriptTitle.TextSize = 12

local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Parent = MainFrame
LuckyBtn.Size = UDim2.new(0.85, 0, 0, 45)
LuckyBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 150)
LuckyBtn.Text = "Lucky Blocks Battlegrounds"
LuckyBtn.TextColor3 = Color3.new(1, 1, 1)
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 12
LuckyBtn.TextWrapped = true
Instance.new("UICorner", LuckyBtn).CornerRadius = UDim.new(0, 8)

-- 2. ЛОГИКА КНОПКИ ЗАГРУЗКИ
LuckyBtn.MouseButton1Click:Connect(function()
    local originalText = "Lucky Blocks Battlegrounds"
    LuckyBtn.Text = "Loading..."
    task.wait(0.8)
    
    -- Пытаемся загрузить скрипт
    pcall(function()
        loadstring(game:HttpGet("https://github.com/bruhhwtf/LUCKY-BLOCKS-Battlegrounds-GUI/raw/main/Main"))()
    end)
    
    LuckyBtn.Text = "Done!"
    LuckyBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Зеленеет при успехе
    task.wait(1.5)
    LuckyBtn.Text = originalText
    LuckyBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 150) -- Возвращаем цвет
end)

-- 3. ПЕРЕМЕЩЕНИЕ И ОСТАЛЬНАЯ ЛОГИКА
AddSpeedBtn.MouseButton1Click:Connect(function() currentSpeed = currentSpeed + 1 end)
SubSpeedBtn.MouseButton1Click:Connect(function() currentSpeed = currentSpeed - 1 end)

RunService.RenderStepped:Connect(function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local s = hrp.Velocity
            SpeedLabel.Text = string.format("Real Speed: %.1f", Vector3.new(s.X, 0, s.Z).Magnitude)
        end
    end
end)

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local function updateHL(p, c)
    if not c then return end
    local hl = c:FindFirstChild("JezHL") or Instance.new("Highlight", c)
    hl.Name = "JezHL"
    hl.Enabled = espEnabled
    local isTeam = (p.Team == localPlayer.Team and p.Team ~= nil)
    hl.FillColor = isTeam and Color3.new(0,1,0) or Color3.new(1,0,0)
    hl.FillTransparency = isTeam and 0.5 or 0.8
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(192, 57, 43)
    for _, p in pairs(Players:GetPlayers()) do if p.Character then updateHL(p, p.Character) end end
end)

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function(c) updateHL(p, c) end) end)
for _, p in pairs(Players:GetPlayers()) do if p ~= localPlayer and p.Character then updateHL(p, p.Character) end end
