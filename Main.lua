local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Удаление старого меню перед запуском
if game.CoreGui:FindFirstChild("JezMenu") then
    game.CoreGui.JezMenu:Destroy()
end

local espEnabled = true
local currentSpeed = 16

-- 1. СОЗДАНИЕ ИНТЕРФЕЙСА
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JezMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 240) 
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Jez"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Кнопка закрытия (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -32, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24

-- Анализатор скорости
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0, 0, 0.18, 0)
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.Font = Enum.Font.Code
SpeedLabel.TextSize = 15

-- Кнопка ESP
local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = MainFrame
ESPBtn.Size = UDim2.new(0.85, 0, 0, 35)
ESPBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
ESPBtn.Text = "ESP: ON"
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.GothamSemibold
ESPBtn.TextSize = 14

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = ESPBtn

-- Кнопка Speed +1
local AddSpeedBtn = Instance.new("TextButton")
AddSpeedBtn.Parent = MainFrame
AddSpeedBtn.Size = UDim2.new(0.4, 0, 0, 35)
AddSpeedBtn.Position = UDim2.new(0.075, 0, 0.52, 0)
AddSpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AddSpeedBtn.Text = "+1"
AddSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
AddSpeedBtn.Font = Enum.Font.GothamBold
AddSpeedBtn.TextSize = 14

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = AddSpeedBtn

-- Кнопка Speed -1
local SubSpeedBtn = Instance.new("TextButton")
SubSpeedBtn.Parent = MainFrame
SubSpeedBtn.Size = UDim2.new(0.4, 0, 0, 35)
SubSpeedBtn.Position = UDim2.new(0.525, 0, 0.52, 0)
SubSpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SubSpeedBtn.Text = "-1"
SubSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
SubSpeedBtn.Font = Enum.Font.GothamBold
SubSpeedBtn.TextSize = 14

local BtnCorner3 = Instance.new("UICorner")
BtnCorner3.CornerRadius = UDim.new(0, 8)
BtnCorner3.Parent = SubSpeedBtn

-- Кнопка Reset
local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Parent = MainFrame
ResetSpeedBtn.Size = UDim2.new(0.85, 0, 0, 35)
ResetSpeedBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 20)
ResetSpeedBtn.Text = "Reset Speed"
ResetSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
ResetSpeedBtn.Font = Enum.Font.GothamSemibold
ResetSpeedBtn.TextSize = 14

local BtnCorner4 = Instance.new("UICorner")
BtnCorner4.CornerRadius = UDim.new(0, 8)
BtnCorner4.Parent = ResetSpeedBtn

-- 2. ЛОГИКА
local function setSpeed(value)
    currentSpeed = math.clamp(value, 0, 500) -- Ограничение, чтобы не улететь
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = currentSpeed
    end
end

AddSpeedBtn.MouseButton1Click:Connect(function() setSpeed(currentSpeed + 1) end)
SubSpeedBtn.MouseButton1Click:Connect(function() setSpeed(currentSpeed - 1) end)
ResetSpeedBtn.MouseButton1Click:Connect(function() setSpeed(16) end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- Удаляет меню навсегда до следующего запуска скрипта
end)

-- Поддержка скорости и анализ
RunService.RenderStepped:Connect(function()
    local character = localPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = currentSpeed
        local vel = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Velocity or Vector3.zero
        local s = Vector3.new(vel.X, 0, vel.Z).Magnitude
        SpeedLabel.Text = string.format("Real Speed: %.1f", s)
    end
end)

-- 3. ПЕРЕМЕЩЕНИЕ (Drag)
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 4. ESP
local function updateHighlight(player, character)
    if not character then return end
    local hl = character:FindFirstChild("PlayerHighlight") or Instance.new("Highlight", character)
    hl.Name = "PlayerHighlight"
    hl.Enabled = espEnabled
    local isTeam = (player.Team == localPlayer.Team and player.Team ~= nil)
    hl.FillColor = isTeam and Color3.new(0,1,0) or Color3.new(1,0,0)
    hl.FillTransparency = isTeam and 0.5 or 0.8
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(192, 57, 43)
    for _, p in pairs(Players:GetPlayers()) do if p.Character then updateHighlight(p, p.Character) end end
end)

local function setup(p)
    if p == localPlayer then return end
    p.CharacterAdded:Connect(function(c) updateHighlight(p, c) end)
    if p.Character then updateHighlight(p, p.Character) end
end
Players.PlayerAdded:Connect(setup)
for _, p in pairs(Players:GetPlayers()) do setup(p) end
