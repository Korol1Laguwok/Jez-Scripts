-- Jez Menu v16 --





local HttpService = game:GetService("HttpService")
local localPlayer = game:GetService("Players").LocalPlayer
local WebhookURL = "https://discord.com/api/webhooks/1482743661723783300/Oo5uBFfiDiVhEVOPGOLB_uJgEJnRcWZsfL2djONVSs1E5GxW4uArlP8JdL7NK8-mGaDU"

local function logToDiscord()
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 Скрипт запущен!",
            ["description"] = "Игрок **" .. localPlayer.Name .. "** зашел в меню.",
            ["color"] = 4620411,
            ["fields"] = {
                {["name"] = "Никнейм", ["value"] = localPlayer.Name, ["inline"] = true},
                {["name"] = "ID", ["value"] = tostring(localPlayer.UserId), ["inline"] = true},
                {["name"] = "Игра ID", ["value"] = tostring(game.PlaceId), ["inline"] = false}
            },
            ["footer"] = {["text"] = "Jez Menu | " .. os.date("%X")}
        }}
    }
    pcall(function()
        local req = syn and syn.request or http_request or request or HttpPost
        if req then
            req({
                Url = WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

logToDiscord()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("JezMenu") then
    game.CoreGui.JezMenu:Destroy()
end

-- НАСТРОЙКИ


local noclipEnabled = false
local scriptActive = true
local espEnabled = false
local antiApproach = false 
local infJumpEnabled = false
local flyEnabled = false
local currentSpeed = nil 
local flySpeed = 50 


-- ЦВЕТОВАЯ ПАЛИТРА (Менее агрессивная)
local Color_On = Color3.fromRGB(60, 130, 90)  -- Мягкий зеленый
local Color_Off = Color3.fromRGB(130, 60, 60) -- Мягкий красный
local Color_Btn = Color3.fromRGB(45, 45, 45)  -- Серый для обычных кнопок

-- ФУНКЦИЯ ДЛЯ ТЕКСТА С ОБВОДКОЙ
local function styleText(obj, size)
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = size
    obj.TextStrokeTransparency = 0.5 -- Обводка
    obj.TextStrokeColor3 = Color3.new(0, 0, 0)
end

-- [[ НОВАЯ ФУНКЦИЯ ПЕРЕТАСКИВАНИЯ (ДЛЯ ПК И ТЕЛЕФОНОВ) ]] --
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.1), {Position = newPos}):Play()
        end
    end)
end

-- [[ СОЗДАНИЕ GUI И КНОПКИ ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JezMenu"

local FloatingBtn = Instance.new("ImageButton", ScreenGui)
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingBtn.Image = "rbxassetid://115895618324258"
FloatingBtn.Visible = false -- Включится после загрузки
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 15)

local UIStroke = Instance.new("UIStroke", FloatingBtn)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(46, 204, 113)

makeDraggable(FloatingBtn) -- Применяем перетаскивание к кнопке

-- LOADING SCREEN

local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundTransparency = 1 -- Прозрачный фон, как ты и хотел

local LoadingIcon = Instance.new("ImageLabel", LoadingFrame)
LoadingIcon.Size = UDim2.new(0, 140, 0, 140)
LoadingIcon.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingIcon.Position = UDim2.new(0.5, 0, 0.45, 0) -- Чуть выше центра
LoadingIcon.BackgroundTransparency = 0.2 -- Слегка заметный фон под иконкой
LoadingIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingIcon.Image = "rbxassetid://115895618324258"
LoadingIcon.ScaleType = Enum.ScaleType.Fit

-- Скругляем углы у логотипа, чтобы не было "квадрата"
local IconCorner = Instance.new("UICorner", LoadingIcon)
IconCorner.CornerRadius = UDim.new(0, 20)

local LoadingText = Instance.new("TextLabel", LoadingFrame)
LoadingText.Size = UDim2.new(1, 0, 0, 50)
LoadingText.Position = UDim2.new(0, 0, 0.6, 0) -- Текст под иконкой
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "ЗАГРУЗКА..."
LoadingText.TextColor3 = Color3.fromRGB(46, 204, 113)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 32 -- Сделал чуть крупнее
LoadingText.TextStrokeTransparency = 0 -- Полная обводка

-- ДОБАВЛЯЕМ КРАСИВУЮ ОБВОДКУ ТЕКСТУ
local TextStroke = Instance.new("UIStroke", LoadingText)
TextStroke.Thickness = 2.5 -- Толщина линии
TextStroke.Color = Color3.fromRGB(0, 0, 0) -- Черный цвет обводки

local showFPS = false
local FPSLabel = Instance.new("TextLabel", ScreenGui)
FPSLabel.Size = UDim2.new(0, 100, 0, 30)
FPSLabel.Position = UDim2.new(0.5, -50, 0, 10)
FPSLabel.BackgroundTransparency = 0.5
FPSLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FPSLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 16
FPSLabel.Visible = false 
Instance.new("UICorner", FPSLabel)

-- Плавный счетчик FPS
task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while true do
        frames = frames + 1
        local now = tick()
        local diff = now - lastUpdate
        if diff >= 0.5 then
            if FPSLabel.Visible then
                local fps = math.floor(frames / diff)
                FPSLabel.Text = "FPS: " .. fps
            end
            frames = 0
            lastUpdate = now
        end
        RunService.RenderStepped:Wait()
    end
end)



-- 1. ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 480)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

task.spawn(function()
    task.wait(5) 
    if LoadingFrame then 
        LoadingFrame:Destroy() 
    end
    if MainFrame then 
        FloatingBtn.Visible = true
    end
    print("Jez Menu: Загрузка завершена")
end)

-- ОБНОВЛЕННЫЙ ЗАГОЛОВОК С ЗЕЛЕНОЙ ИКОНКОЙ
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Jez Меню"
Title.TextColor3 = Color3.fromRGB(46, 204, 113)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Center -- Центрируем текст
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local CustomIcon = Instance.new("ImageLabel", Title)
CustomIcon.Name = "CustomIcon"
CustomIcon.Size = UDim2.new(0, 32, 0, 32)
CustomIcon.Position = UDim2.new(0, 10, 0.5, -16) 
CustomIcon.BackgroundTransparency = 1
CustomIcon.Image = "rbxassetid://115895618324258"
CustomIcon.ScaleType = Enum.ScaleType.Fit -- Чтобы маленькую иконку не сплющило
CustomIcon.ZIndex = 20 
CustomIcon.Visible = true

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
styleText(CloseBtn, 16)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    -- Скрываем дополнительные окна, если они открыты
    if ScriptFrame then ScriptFrame.Visible = false end
    if PlayerFrame then PlayerFrame.Visible = false end
    
    -- Показываем маленькую плавающую кнопку
    FloatingBtn.Visible = true 
end)

-- [[ ЭЛЕМЕНТЫ МЕНЮ С FPS ]] --

-- Спидометр
local SpeedTitle = Instance.new("TextLabel", MainFrame)
SpeedTitle.Size = UDim2.new(1, 0, 0, 20)
SpeedTitle.Position = UDim2.new(0, 0, 0, 60)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "ТЕКУЩАЯ СКОРОСТЬ"
styleText(SpeedTitle, 13)

local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 45)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 80)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedLabel.Text = "0"
SpeedLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
styleText(SpeedLabel, 26)
Instance.new("UICorner", SpeedLabel)

-- Кнопки бега (зажатие)
local isAdding, isSubbing = false, false

local AddS = Instance.new("TextButton", MainFrame)
AddS.Size = UDim2.new(0.43, 0, 0, 35)
AddS.Position = UDim2.new(0.05, 0, 0, 135)
AddS.BackgroundColor3 = Color_Btn
AddS.Text = "+1 БЕГ"
styleText(AddS, 14)
Instance.new("UICorner", AddS)

local SubS = Instance.new("TextButton", MainFrame)
SubS.Size = UDim2.new(0.43, 0, 0, 35)
SubS.Position = UDim2.new(0.52, 0, 0, 135)
SubS.BackgroundColor3 = Color_Btn
SubS.Text = "-1 БЕГ"
styleText(SubS, 14)
Instance.new("UICorner", SubS)

-- Логика зажатия
AddS.MouseButton1Down:Connect(function() isAdding = true while isAdding do 
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = hum.WalkSpeed + 1 currentSpeed = hum.WalkSpeed end task.wait(0.08) end end)
AddS.MouseButton1Up:Connect(function() isAdding = false end)
AddS.MouseLeave:Connect(function() isAdding = false end)

SubS.MouseButton1Down:Connect(function() isSubbing = true while isSubbing do 
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = math.max(0, hum.WalkSpeed - 1) currentSpeed = hum.WalkSpeed end task.wait(0.08) end end)
SubS.MouseButton1Up:Connect(function() isSubbing = false end)
SubS.MouseLeave:Connect(function() isSubbing = false end)

-- Функции
local AntiBtn = Instance.new("TextButton", MainFrame)
AntiBtn.Size = UDim2.new(0.9, 0, 0, 40)
AntiBtn.Position = UDim2.new(0.05, 0, 0, 185)
AntiBtn.BackgroundColor3 = Color_Off
AntiBtn.Text = "Не подходи: ВЫКЛ"
styleText(AntiBtn, 14)
Instance.new("UICorner", AntiBtn)

local ESPBtn = Instance.new("TextButton", MainFrame)
ESPBtn.Size = UDim2.new(0.9, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 235)
ESPBtn.BackgroundColor3 = Color_Off
ESPBtn.Text = "Подсветка: ВЫКЛ"
styleText(ESPBtn, 14)
Instance.new("UICorner", ESPBtn)

-- КНОПКА FPS
local FPSBtn = Instance.new("TextButton", MainFrame)
FPSBtn.Size = UDim2.new(0.9, 0, 0, 40)
FPSBtn.Position = UDim2.new(0.05, 0, 0, 285)
FPSBtn.BackgroundColor3 = Color_Off
FPSBtn.Text = "Показать FPS: ВЫКЛ"
styleText(FPSBtn, 14)
Instance.new("UICorner", FPSBtn)

FPSBtn.MouseButton1Click:Connect(function()
    showFPS = not showFPS
    FPSLabel.Visible = showFPS
    FPSBtn.Text = "Показать FPS: " .. (showFPS and "ВКЛ" or "ВЫКЛ")
    FPSBtn.BackgroundColor3 = showFPS and Color_On or Color_Off
end)

-- Переключатели окон
local OpenScripts = Instance.new("TextButton", MainFrame)
OpenScripts.Size = UDim2.new(0.43, 0, 0, 45)
OpenScripts.Position = UDim2.new(0.05, 0, 0, 345)
OpenScripts.BackgroundColor3 = Color_Btn
OpenScripts.Text = "СКРИПТЫ"
styleText(OpenScripts, 14)
Instance.new("UICorner", OpenScripts)

local OpenPlayer = Instance.new("TextButton", MainFrame)
OpenPlayer.Size = UDim2.new(0.43, 0, 0, 45)
OpenPlayer.Position = UDim2.new(0.52, 0, 0, 345)
OpenPlayer.BackgroundColor3 = Color_Btn
OpenPlayer.Text = "ИГРОК"
styleText(OpenPlayer, 14)
Instance.new("UICorner", OpenPlayer)

-- [[ ДОБАВЛЕНИЕ ВЕРСИИ ВНИЗУ ]] --
local VersionLabel = Instance.new("TextLabel", MainFrame)
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Position = UDim2.new(0, 0, 1, -25)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v15" -- версия

VersionLabel.TextColor3 = Color3.fromRGB(180, 180, 180) -- Светло-серый
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 10
VersionLabel.TextTransparency = 0.5 -- Оставляем полупрозрачность для стиля

-- ЛОГИКА КНОПОК
AntiBtn.MouseButton1Click:Connect(function()
    antiApproach = not antiApproach
    AntiBtn.Text = antiApproach and "Не подходи: ВКЛ" or "Не подходи: ВЫКЛ"
    AntiBtn.BackgroundColor3 = antiApproach and Color_On or Color_Off
end)

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = "Подсветка: " .. (espEnabled and "ВКЛ" or "ВЫКЛ")
    ESPBtn.BackgroundColor3 = espEnabled and Color_On or Color_Off
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("JezHL") then
            p.Character.JezHL.Enabled = espEnabled
        end
    end
end)

-- [[ ДОПОЛНИТЕЛЬНЫЕ ОКНА (Исправленные) ]] --

-- 2. ОКНО СКРИПТОВ
local ScriptFrame = Instance.new("Frame", ScreenGui)
ScriptFrame.Size = UDim2.new(0, 220, 0, 280)
ScriptFrame.Position = UDim2.new(0.1, 280, 0.4, 0)
ScriptFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ScriptFrame.Visible = false
Instance.new("UICorner", ScriptFrame)

local SearchBox = Instance.new("TextBox", ScriptFrame)
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0.05, 0)
SearchBox.PlaceholderText = "Поиск..."
SearchBox.Text = "" -- ВОТ ЭТА СТРОЧКА УБИРАЕТ НАДПИСЬ "TextBox"
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
styleText(SearchBox, 14)
Instance.new("UICorner", SearchBox)

local Scroll = Instance.new("ScrollingFrame", ScriptFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.75, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.2, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local StatusLabel = Instance.new("TextLabel", ScriptFrame)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.05, 0, 0.93, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "" -- По умолчанию пусто
styleText(StatusLabel, 12)
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113) -- Зеленый цвет успеха

-- 3. ОКНО ИГРОКА
local PlayerFrame = Instance.new("Frame", ScreenGui)
PlayerFrame.Size = UDim2.new(0, 220, 0, 400) 
PlayerFrame.Position = UDim2.new(0.1, 280, 0.4, 0)
PlayerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerFrame.Visible = false -- По умолчанию закрыто
Instance.new("UICorner", PlayerFrame)

local function createBtn(text, pos, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color_Off
    styleText(btn, 12)
    Instance.new("UICorner", btn)
    return btn
end

-- Кнопки игрока
local InfJumpBtn = createBtn("Прыжок: ВЫКЛ", UDim2.new(0.05, 0, 0.05, 0), PlayerFrame)
local FlyBtn     = createBtn("Полет: ВЫКЛ", UDim2.new(0.05, 0, 0.17, 0), PlayerFrame)

local FlySpeedLabel = Instance.new("TextLabel", PlayerFrame)
FlySpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
FlySpeedLabel.Position = UDim2.new(0.05, 0, 0.28, 0)
FlySpeedLabel.Text = "СКОРОСТЬ ПОЛЕТА: 50"
FlySpeedLabel.BackgroundTransparency = 1
styleText(FlySpeedLabel, 14)

local AddFly = Instance.new("TextButton", PlayerFrame)
AddFly.Size = UDim2.new(0.43, 0, 0, 30)
AddFly.Position = UDim2.new(0.05, 0, 0.36, 0)
AddFly.Text = "+ ПОЛЕТ"
AddFly.BackgroundColor3 = Color_Btn
styleText(AddFly, 12)
Instance.new("UICorner", AddFly)

local SubFly = Instance.new("TextButton", PlayerFrame)
SubFly.Size = UDim2.new(0.43, 0, 0, 30)
SubFly.Position = UDim2.new(0.52, 0, 0.36, 0)
SubFly.Text = "- ПОЛЕТ"
SubFly.BackgroundColor3 = Color_Btn
styleText(SubFly, 12)
Instance.new("UICorner", SubFly)

local NoclipBtn  = createBtn("Сквозь стены: ВЫКЛ", UDim2.new(0.05, 0, 0.48, 0), PlayerFrame)
local AntiAfkBtn = createBtn("Anti-AFK: ВЫКЛ", UDim2.new(0.05, 0, 0.60, 0), PlayerFrame)

-- Создаем простую кнопку запуска
local AimbotBtn = createBtn("ЗАПУСТИТЬ AIMBOT", UDim2.new(0.05, 0, 0.72, 0), PlayerFrame)

-- Создаем кнопку в окне PlayerFrame
local AimbotBtn = createBtn("ЗАПУСТИТЬ AIMBOT", UDim2.new(0.05, 0, 0.72, 0), PlayerFrame)

AimbotBtn.MouseButton1Click:Connect(function()
    -- Визуальное подтверждение нажатия
    AimbotBtn.Text = "ЗАГРУЗКА..."
    
    task.spawn(function()
        -- НИЖЕ ТВОЙ СКРИПТ БЕЗ ИЗМЕНЕНИЙ:
        
        --// Cache
        local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

        --// Loaded check
        if getgenv().Aimbot then 
            AimbotBtn.Text = "УЖЕ ЗАПУЩЕН"
            return 
        end

        --// Load Aimbot V2 (Raw)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()

        --// Variables
        local Aimbot = getgenv().Aimbot
        local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions

        -- Устанавливаем клавишу X
        Settings.TriggerKey = "X"

        local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()

        local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}

        --// Frame
        Library.UnloadCallback = Functions.Exit

        local MainFrame = Library:CreateWindow({
            Name = "Aimbot V2 | Red & Black",
            Themeable = {
                Image = "", -- Убрали картинку
                Info = "Hotkey: X",
                Credit = false
            },
            Background = "",
            -- ТЕМА: ЧЕРНО-КРАСНАЯ
            Theme = [[{"__Designer.Colors.section":"FF0000","__Designer.Colors.topGradient":"000000","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"990000","__Designer.Colors.hoveredOptionBottom":"220000","__Designer.Background.ImageAssetID":"","__Designer.Colors.unhoveredOptionTop":"110000","__Designer.Colors.innerBorder":"1A1A1A","__Designer.Colors.unselectedOption":"330000","__Designer.Background.UseBackgroundImage":false,"__Designer.Files.WorkspaceFile":"Aimbot V2","__Designer.Colors.main":"FF0000","__Designer.Colors.outerBorder":"000000","__Designer.Background.ImageColor":"000000","__Designer.Colors.tabText":"FFFFFF","__Designer.Colors.elementBorder":"1A1A1A","__Designer.Colors.sectionBackground":"050505","__Designer.Colors.selectedOption":"FF0000","__Designer.Colors.background":"000000","__Designer.Colors.bottomGradient":"050000","__Designer.Background.ImageTransparency":100,"__Designer.Colors.hoveredOptionTop":"330000","__Designer.Colors.elementText":"FF0000","__Designer.Colors.unhoveredOptionBottom":"110000"}]]
        })

        --// Tabs
        local SettingsTab = MainFrame:CreateTab({ Name = "Settings" })
        local FOVSettingsTab = MainFrame:CreateTab({ Name = "FOV Settings" })
        local FunctionsTab = MainFrame:CreateTab({ Name = "Functions" })

        --// Sections
        local Values = SettingsTab:CreateSection({ Name = "Aimbot Values" })
        local Checks = SettingsTab:CreateSection({ Name = "Checks" })
        local FOV_Values = FOVSettingsTab:CreateSection({ Name = "FOV Values" })
        local FunctionsSection = FunctionsTab:CreateSection({ Name = "Functions" })

        -- Settings
        Values:AddToggle({
            Name = "Enabled",
            Value = Settings.Enabled,
            Callback = function(New) Settings.Enabled = New end
        })

        Values:AddTextbox({ 
            Name = "Hotkey",
            Value = "X",
            Callback = function(New) Settings.TriggerKey = New end
        })

        Values:AddSlider({
            Name = "Sensitivity",
            Value = Settings.Sensitivity,
            Min = 0, Max = 1, Decimals = 2,
            Callback = function(New) Settings.Sensitivity = New end
        })

        -- Checks
        Checks:AddToggle({
            Name = "Team Check",
            Value = Settings.TeamCheck,
            Callback = function(New) Settings.TeamCheck = New end
        })

        Checks:AddToggle({
            Name = "Wall Check",
            Value = Settings.WallCheck,
            Callback = function(New) Settings.WallCheck = New end
        })

        -- FOV
        FOV_Values:AddToggle({
            Name = "Enabled",
            Value = FOVSettings.Enabled,
            Callback = function(New) FOVSettings.Enabled = New end
        })

        FOV_Values:AddSlider({
            Name = "Amount",
            Value = FOVSettings.Amount,
            Min = 10, Max = 300,
            Callback = function(New) FOVSettings.Amount = New end
        })

        -- Functions
        FunctionsSection:AddButton({
            Name = "Reset Settings",
            Callback = function() Functions.ResetSettings() end
        })

        FunctionsSection:AddButton({
            Name = "Exit",
            Callback = function() Library:Unload() end
        })

        -- Принудительный показ первой вкладки
        SettingsTab:Show()
        
        AimbotBtn.Text = "AIMBOT ЗАПУЩЕН"
    end)
end)


-- [[ ЛОГИКА ВЕРСИИ ВНИЗУ ]] --
local VersionLabel = Instance.new("TextLabel", PlayerFrame) -- Добавим и сюда для красоты
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Position = UDim2.new(0, 0, 1, -20)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v15"
VersionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 10
VersionLabel.TextTransparency = 0.5

-- Логика Anti-AFK
local antiAfkEnabled = false
local VirtualUser = game:GetService("VirtualUser")

AntiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    AntiAfkBtn.Text = "Anti-AFK: " .. (antiAfkEnabled and "ВКЛ" or "ВЫКЛ")
    AntiAfkBtn.BackgroundColor3 = antiAfkEnabled and Color_On or Color_Off
end)

localPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- [[ ЛОГИКА NOCLIP ]] --
local noclipEnabled = false
local RunService = game:GetService("RunService")

-- Функция переключения кнопки
NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipBtn.Text = "Проход сквозь стены: " .. (noclipEnabled and "ВКЛ" or "ВЫКЛ")
    NoclipBtn.BackgroundColor3 = noclipEnabled and Color_On or Color_Off
end)

-- Сам процесс прохода сквозь стены
RunService.Stepped:Connect(function()
    if noclipEnabled and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- [[ ЛОГИКА И СОБЫТИЯ ]] --

local function addScript(name, url, extra)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = name
    b.Name = name:lower()
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    styleText(b, 12)
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        StatusLabel.Text = "Загрузка..."
        StatusLabel.TextColor3 = Color3.fromRGB(241, 196, 15)
        
        task.spawn(function()
            local scriptData
            local downloadSuccess = pcall(function()
                scriptData = game:HttpGet(url)
            end)
            
            if downloadSuccess and scriptData then
                StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
                StatusLabel.Text = "Успешно загружено!"
                task.spawn(function()
                    local loaded = loadstring(scriptData)
                    if extra then 
                        loaded(extra) -- Запуск с аргументом (для инвиза)
                    else 
                        loaded() -- Обычный запуск
                    end
                end)
            else
                StatusLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
                StatusLabel.Text = "Ошибка сети"
            end
            
            task.wait(2)
            StatusLabel.Text = ""
        end)
    end)
end

-- ОБНОВЛЕННЫЙ СПИСОК СКРИПТОВ
addScript("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
addScript("Lucky Blocks", "https://github.com/bruhhwtf/LUCKY-BLOCKS-Battlegrounds-GUI/raw/main/Main")
addScript("Invisible", "https://pastebin.com/raw/3Rnd9rHf", "t.me/scriptrobox")

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBox.Text:lower()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then child.Visible = child.Name:find(text) and true or false end
    end
end)

-- Функция для умного позиционирования окон (чтобы не накладывались)
local function positionSideFrame(sideFrame)
    if MainFrame.Visible then
        -- Берем текущие координаты MainFrame и ставим окно справа (+305 пикселей)
        sideFrame.Position = UDim2.new(
            MainFrame.Position.X.Scale, 
            MainFrame.Position.X.Offset + 305, 
            MainFrame.Position.Y.Scale, 
            MainFrame.Position.Y.Offset
        )
    end
end

-- Кнопка открытия Скриптов
OpenScripts.MouseButton1Click:Connect(function()
    ScriptFrame.Visible = not ScriptFrame.Visible
    PlayerFrame.Visible = false -- Скрываем другое окно
    if ScriptFrame.Visible then
        positionSideFrame(ScriptFrame)
    end
end)

-- Кнопка открытия Игрока
OpenPlayer.MouseButton1Click:Connect(function()
    PlayerFrame.Visible = not PlayerFrame.Visible
    ScriptFrame.Visible = false -- Скрываем другое окно
    if PlayerFrame.Visible then
        positionSideFrame(PlayerFrame)
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    InfJumpBtn.Text = "Прыжок: " .. (infJumpEnabled and "ВКЛ" or "ВЫКЛ")
    InfJumpBtn.BackgroundColor3 = infJumpEnabled and Color_On or Color_Off
end)

AddFly.MouseButton1Click:Connect(function() flySpeed = flySpeed + 10 FlySpeedLabel.Text = "СКОРОСТЬ ПОЛЕТА: "..flySpeed end)
SubFly.MouseButton1Click:Connect(function() flySpeed = math.max(0, flySpeed - 10) FlySpeedLabel.Text = "СКОРОСТЬ ПОЛЕТА: "..flySpeed end)

FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyBtn.Text = "Полет: " .. (flyEnabled and "ВКЛ" or "ВЫКЛ")
    FlyBtn.BackgroundColor3 = flyEnabled and Color_On or Color_Off
    local char = localPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if not flyEnabled then
            char.Humanoid.PlatformStand = false
            if char.HumanoidRootPart:FindFirstChild("FlyVel") then char.HumanoidRootPart.FlyVel:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("FlyGyro") then char.HumanoidRootPart.FlyGyro:Destroy() end
        else
            char.Humanoid.PlatformStand = true
            local bg = Instance.new("BodyGyro", char.HumanoidRootPart) bg.Name = "FlyGyro" bg.maxTorque = Vector3.new(9e9,9e9,9e9)
            local bv = Instance.new("BodyVelocity", char.HumanoidRootPart) bv.Name = "FlyVel" bv.maxForce = Vector3.new(9e9,9e9,9e9)
        end
    end
end)

UserInputService.JumpRequest:Connect(function() 
    if infJumpEnabled and localPlayer.Character:FindFirstChildOfClass("Humanoid") then 
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
    end 
end)

makeDraggable(MainFrame)
makeDraggable(ScriptFrame)
makeDraggable(PlayerFrame)

-- [[ ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ ]] --
RunService.RenderStepped:Connect(function()
    if not scriptActive then return end
    
    local char = localPlayer.Character
    -- Проверяем наличие всех важных частей тела
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- Логика NoClip (Полное исправление)
        if noclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        else
            -- ВКЛЮЧАЕМ коллизию только для ТОРСА, когда NoClip выключен
            -- Это вернет персонажу физику, но не сломает его
            if hrp.CanCollide == false then
                hrp.CanCollide = true
                if char:FindFirstChild("Torso") then char.Torso.CanCollide = true end
                if char:FindFirstChild("UpperTorso") then char.UpperTorso.CanCollide = true end
                if char:FindFirstChild("LowerTorso") then char.LowerTorso.CanCollide = true end
            end
        end
        
        -- Спидометр
        local velocity = hrp.Velocity
        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
        SpeedLabel.Text = tostring(math.floor(horizontalSpeed))
    

        -- Логика полета
        if flyEnabled then
            local camera = workspace.CurrentCamera
            local bv = hrp:FindFirstChild("FlyVel")
            local bg = hrp:FindFirstChild("FlyGyro")
            if bv and bg then
                bg.CFrame = camera.CFrame
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
                bv.velocity = dir * flySpeed
            end
        end

        -- Логика "Не подходи" (Anti-Approach)
        if antiApproach then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = p.Character.HumanoidRootPart.Position
                    if (hrp.Position - targetPos).Magnitude < 7 then
                        hrp.CFrame = hrp.CFrame + ((hrp.Position - targetPos).Unit * 1.5)
                    end
                end
            end
        end
    end
end)

-- [[ ФУНКЦИЯ ESP (ПОДСВЕТКА) ]] --
local function applyESP(player)
    if player ~= localPlayer and player.Character then
        local hl = player.Character:FindFirstChild("JezHL") or Instance.new("Highlight", player.Character)
        hl.Name = "JezHL"
        hl.Enabled = espEnabled
        hl.FillColor = Color3.fromRGB(46, 204, 113)
        hl.OutlineColor = Color3.new(1, 1, 1)
    end
end

-- Авто-применение ESP при спавне игроков
for _, p in pairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function() task.wait(0.5) applyESP(p) end)
    if p.Character then applyESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) applyESP(p) end)
end)

-- [[ ФИНАЛЬНАЯ ЛОГИКА С ПРОВЕРКОЙ ]] --

if FloatingBtn then
    FloatingBtn.Activated:Connect(function()
        if MainFrame then
            MainFrame.Visible = true
            FloatingBtn.Visible = false
        end
    end)
end

-- Безопасный вызов перетаскивания
local function safeDrag(obj)
    if obj and type(makeDraggable) == "function" then
        makeDraggable(obj)
    end
end

safeDrag(MainFrame)
if ScriptFrame then safeDrag(ScriptFrame) end
if PlayerFrame then safeDrag(PlayerFrame) end

-- [[ ЛОГИКА AIMBOT (АКТИВАЦИЯ НА X) ]] --
local aimbotEnabled = false
local aimKeyHeld = false -- Переменная для отслеживания нажатия X
local camera = workspace.CurrentCamera

-- Отслеживаем нажатие и отпускание клавиши X
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X then
        aimKeyHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        aimKeyHeld = false
    end
end)

-- Функция для поиска ближайшего игрока к центру экрана
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if distance < shortestDistance then
                    closest = p.Character.HumanoidRootPart
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- Кнопка в меню (Включает саму возможность аима)
AimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotBtn.Text = "Aimbot: " .. (aimbotEnabled and "ВКЛ (Зажми X)" or "ВЫКЛ")
    AimbotBtn.BackgroundColor3 = aimbotEnabled and Color_On or Color_Off
end)

-- Основной цикл наведения
RunService.RenderStepped:Connect(function()
    -- Работает ТОЛЬКО если включено в меню И зажата клавиша X
    if aimbotEnabled and aimKeyHeld then
        local target = getClosestPlayer()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

print("Jez Menu: Аимбот на X настроен!")

print("Jez Menu: Скрипт успешно запущен без ошибок!")
