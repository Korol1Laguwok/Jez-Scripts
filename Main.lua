-- [[ Jez Menu v5.7 - Animated Loader Edition ]] --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("JezMenu") then
    game.CoreGui.JezMenu:Destroy()
end

local espEnabled = true
local antiApproach = false 
local currentSpeed = 16
local allScripts = {}

-- 1. ОСНОВНОЕ ОКНО
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JezMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Jez Меню"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Title
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 28
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Скорость
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = MainFrame
SpeedContainer.Size = UDim2.new(0.9, 0, 0, 35)
SpeedContainer.Position = UDim2.new(0.05, 0, 0.16, 0)
SpeedContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", SpeedContainer).CornerRadius = UDim.new(0, 6)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = SpeedContainer
SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "СКОРОСТЬ: 16.0"
SpeedLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
SpeedLabel.Font = Enum.Font.Code
SpeedLabel.TextSize = 14

local ResetBtn = Instance.new("TextButton")
ResetBtn.Parent = SpeedContainer
ResetBtn.Size = UDim2.new(0.35, 0, 0.8, 0)
ResetBtn.Position = UDim2.new(0.62, 0, 0.1, 0)
ResetBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ResetBtn.Text = "Сброс"
ResetBtn.TextColor3 = Color3.new(1, 1, 1)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 12
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 4)
ResetBtn.MouseButton1Click:Connect(function() currentSpeed = 16 end)

local AddSpeed = Instance.new("TextButton")
AddSpeed.Parent = MainFrame
AddSpeed.Size = UDim2.new(0.43, 0, 0, 30)
AddSpeed.Position = UDim2.new(0.05, 0, 0.30, 0)
AddSpeed.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AddSpeed.Text = "+ СКОРОСТЬ"
AddSpeed.TextColor3 = Color3.fromRGB(46, 204, 113)
AddSpeed.Font = Enum.Font.GothamBold
AddSpeed.TextSize = 12
Instance.new("UICorner", AddSpeed).CornerRadius = UDim.new(0, 6)
AddSpeed.MouseButton1Click:Connect(function() currentSpeed = currentSpeed + 1 end)

local SubSpeed = Instance.new("TextButton")
SubSpeed.Parent = MainFrame
SubSpeed.Size = UDim2.new(0.43, 0, 0, 30)
SubSpeed.Position = UDim2.new(0.52, 0, 0.30, 0)
SubSpeed.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SubSpeed.Text = "- СКОРОСТЬ"
SubSpeed.TextColor3 = Color3.fromRGB(231, 76, 60)
SubSpeed.Font = Enum.Font.GothamBold
SubSpeed.TextSize = 12
Instance.new("UICorner", SubSpeed).CornerRadius = UDim.new(0, 6)
SubSpeed.MouseButton1Click:Connect(function() currentSpeed = currentSpeed - 1 end)

local AntiBtn = Instance.new("TextButton")
AntiBtn.Parent = MainFrame
AntiBtn.Size = UDim2.new(0.9, 0, 0, 40)
AntiBtn.Position = UDim2.new(0.05, 0, 0.44, 0)
AntiBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
AntiBtn.Text = "Не подходи: ВЫКЛ"
AntiBtn.TextColor3 = Color3.new(1, 1, 1)
AntiBtn.Font = Enum.Font.GothamBold
AntiBtn.TextSize = 14
Instance.new("UICorner", AntiBtn).CornerRadius = UDim.new(0, 8)

local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = MainFrame
ESPBtn.Size = UDim2.new(0.9, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ESPBtn.Text = "Подсветка: ВКЛ"
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 14
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 8)

local OpenScriptsBtn = Instance.new("TextButton")
OpenScriptsBtn.Parent = MainFrame
OpenScriptsBtn.Size = UDim2.new(0.9, 0, 0, 40)
OpenScriptsBtn.Position = UDim2.new(0.05, 0, 0.77, 0)
OpenScriptsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
OpenScriptsBtn.Text = "СПИСОК СКРИПТОВ"
OpenScriptsBtn.TextColor3 = Color3.new(1, 1, 1)
OpenScriptsBtn.Font = Enum.Font.GothamBold
OpenScriptsBtn.TextSize = 14
Instance.new("UICorner", OpenScriptsBtn).CornerRadius = UDim.new(0, 8)

-- 2. ОКНО СКРИПТОВ
local ScriptFrame = Instance.new("Frame")
ScriptFrame.Parent = ScreenGui
ScriptFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ScriptFrame.Position = UDim2.new(0.1, 240, 0.4, 0)
ScriptFrame.Size = UDim2.new(0, 200, 0, 240)
ScriptFrame.Visible = false
Instance.new("UICorner", ScriptFrame).CornerRadius = UDim.new(0, 10)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = ScriptFrame
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0.05, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBox.PlaceholderText = "Поиск..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.Font = Enum.Font.GothamBold
SearchBox.TextSize = 12
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = ScriptFrame
Scroll.Position = UDim2.new(0.05, 0, 0.2, 0)
Scroll.Size = UDim2.new(0.9, 0, 0.75, 0)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0,0,0,0)
local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)

-- ФУНКЦИЯ ДОБАВЛЕНИЯ СКРИПТА С АНИМАЦИЕЙ
local function addScript(name, url)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    b.MouseButton1Click:Connect(function() 
        -- Анимация "Загрузка"
        b.Text = "Загрузка..."
        b.BackgroundColor3 = Color3.fromRGB(241, 196, 15) -- Желтый
        
        task.delay(0.8, function()
            local success, err = pcall(function() 
                loadstring(game:HttpGet(url))() 
            end)
            
            if success then
                b.Text = "Готово!"
                b.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Зеленый
            else
                b.Text = "Ошибка!"
                b.BackgroundColor3 = Color3.fromRGB(192, 57, 43) -- Красный
            end
            
            task.wait(1.5)
            b.Text = name
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end)
    
    table.insert(allScripts, b)
    Scroll.CanvasSize = UDim2.new(0,0,0, UIList.AbsoluteContentSize.Y)
end

addScript("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
addScript("Lucky Blocks", "https://github.com/bruhhwtf/LUCKY-BLOCKS-Battlegrounds-GUI/raw/main/Main")

-- Логика переключения "Не подходи"
AntiBtn.MouseButton1Click:Connect(function()
    antiApproach = not antiApproach
    AntiBtn.Text = antiApproach and "Не подходи: ВКЛ" or "Не подходи: ВЫКЛ"
    AntiBtn.BackgroundColor3 = antiApproach and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(192, 57, 43)
end)

-- ГЛАВНЫЙ ЦИКЛ
RunService.RenderStepped:Connect(function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = localPlayer.Character.HumanoidRootPart
        if localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = currentSpeed
            SpeedLabel.Text = string.format("СКОРОСТЬ: %.1f", hrp.Velocity.Magnitude)
        end
        if antiApproach then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = player.Character.HumanoidRootPart
                    if (hrp.Position - targetHrp.Position).Magnitude < 6 then
                        hrp.CFrame = hrp.CFrame + ((hrp.Position - targetHrp.Position).Unit * 0.5)
                    end
                end
            end
        end
    end
end)

OpenScriptsBtn.MouseButton1Click:Connect(function() ScriptFrame.Visible = not ScriptFrame.Visible end)

-- Остальное (Поиск, Драг, ЕСП)
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = SearchBox.Text:lower()
    for _, b in pairs(allScripts) do b.Visible = (t == "" or b.Text:lower():find(t)) end
end)

local function drag(frame)
    local d, ds, sp
    frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = frame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end
drag(MainFrame)
drag(ScriptFrame)

local function updateHL(p, c)
    if not c or p == localPlayer then return end
    local hl = c:FindFirstChild("JezHL") or Instance.new("Highlight", c)
    hl.Enabled = espEnabled
    hl.FillColor = (p.Team == localPlayer.Team and p.Team ~= nil) and Color3.new(0,1,0) or Color3.new(1,0,0)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "Подсветка: ВКЛ" or "Подсветка: ВЫКЛ"
    ESPBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(192, 57, 43)
    for _, p in pairs(Players:GetPlayers()) do if p.Character then updateHL(p, p.Character) end end
end)
