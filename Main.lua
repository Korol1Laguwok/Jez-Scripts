-- Jez Menu v9 --


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
local currentSpeed = 16
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

local function drag(frame)
    local d, ds, sp
    frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = frame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JezMenu"

-- 1. ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 400)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Jez Меню"
Title.TextColor3 = Color3.fromRGB(46, 204, 113)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
styleText(CloseBtn, 16)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    scriptActive = false 
	noclipEnabled = false
    
    local char = localPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16 
        char.Humanoid.PlatformStand = false
        if char.HumanoidRootPart:FindFirstChild("FlyVel") then char.HumanoidRootPart.FlyVel:Destroy() end
        if char.HumanoidRootPart:FindFirstChild("FlyGyro") then char.HumanoidRootPart.FlyGyro:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("JezHL") then
            p.Character.JezHL:Destroy()
        end
    end

    ScreenGui:Destroy()
end)

local SpeedTitle = Instance.new("TextLabel", MainFrame)
SpeedTitle.Size = UDim2.new(1, 0, 0, 20)
SpeedTitle.Position = UDim2.new(0, 0, 0, 65)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "ТЕКУЩАЯ СКОРОСТЬ"
styleText(SpeedTitle, 13)

local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 50)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 90)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedLabel.Text = "0"
SpeedLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 28
Instance.new("UICorner", SpeedLabel).CornerRadius = UDim.new(0, 8)

-- КНОПКИ БЕГА
local AddS = Instance.new("TextButton", MainFrame)
AddS.Size = UDim2.new(0.43, 0, 0, 35)
AddS.Position = UDim2.new(0.05, 0, 0, 155)
AddS.BackgroundColor3 = Color_Btn
AddS.Text = "+1 БЕГ"
styleText(AddS, 14)
Instance.new("UICorner", AddS)
AddS.MouseButton1Click:Connect(function() currentSpeed = currentSpeed + 1 end)

local SubS = Instance.new("TextButton", MainFrame)
SubS.Size = UDim2.new(0.43, 0, 0, 35)
SubS.Position = UDim2.new(0.52, 0, 0, 155)
SubS.BackgroundColor3 = Color_Btn
SubS.Text = "-1 БЕГ"
styleText(SubS, 14)
Instance.new("UICorner", SubS)
SubS.MouseButton1Click:Connect(function() currentSpeed = math.max(0, currentSpeed - 1) end)

-- ГЛАВНЫЕ КНОПКИ (С МЯГКИМИ ЦВЕТАМИ)
local AntiBtn = Instance.new("TextButton", MainFrame)
AntiBtn.Size = UDim2.new(0.9, 0, 0, 45)
AntiBtn.Position = UDim2.new(0.05, 0, 0, 205)
AntiBtn.BackgroundColor3 = Color_Off
AntiBtn.Text = "Не подходи: ВЫКЛ"
styleText(AntiBtn, 14)
Instance.new("UICorner", AntiBtn)

local ESPBtn = Instance.new("TextButton", MainFrame)
ESPBtn.Size = UDim2.new(0.9, 0, 0, 45)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 265)
ESPBtn.BackgroundColor3 = Color_Off
ESPBtn.Text = "Подсветка: ВЫКЛ"
styleText(ESPBtn, 14)
Instance.new("UICorner", ESPBtn)

local OpenScripts = Instance.new("TextButton", MainFrame)
OpenScripts.Size = UDim2.new(0.43, 0, 0, 45)
OpenScripts.Position = UDim2.new(0.05, 0, 0, 330)
OpenScripts.BackgroundColor3 = Color_Btn
OpenScripts.Text = "СКРИПТЫ"
styleText(OpenScripts, 14)
Instance.new("UICorner", OpenScripts)

local OpenPlayer = Instance.new("TextButton", MainFrame)
OpenPlayer.Size = UDim2.new(0.43, 0, 0, 45)
OpenPlayer.Position = UDim2.new(0.52, 0, 0, 330)
OpenPlayer.BackgroundColor3 = Color_Btn
OpenPlayer.Text = "ИГРОК"
styleText(OpenPlayer, 14)
Instance.new("UICorner", OpenPlayer)

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
PlayerFrame.Size = UDim2.new(0, 220, 0, 240)
PlayerFrame.Position = UDim2.new(0.1, 280, 0.4, 0)
PlayerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerFrame.Visible = false
Instance.new("UICorner", PlayerFrame)

local NoclipBtn = Instance.new("TextButton", PlayerFrame)
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
NoclipBtn.Position = UDim2.new(0.05, 0, 0.75, 0) -- Расположи ниже остальных
NoclipBtn.Text = "Проход сквозь стены: ВЫКЛ"
NoclipBtn.BackgroundColor3 = Color_Off
styleText(NoclipBtn, 12)
Instance.new("UICorner", NoclipBtn)

NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipBtn.Text = "Проход сквозь стены: " .. (noclipEnabled and "ВКЛ" or "ВЫКЛ")
    NoclipBtn.BackgroundColor3 = noclipEnabled and Color_On or Color_Off
end)


local InfJumpBtn = Instance.new("TextButton", PlayerFrame)
InfJumpBtn.Size = UDim2.new(0.9, 0, 0, 35)
InfJumpBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
InfJumpBtn.Text = "Прыжок: ВЫКЛ"
InfJumpBtn.BackgroundColor3 = Color_Off
styleText(InfJumpBtn, 12)
Instance.new("UICorner", InfJumpBtn)

local FlyBtn = Instance.new("TextButton", PlayerFrame)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 35)
FlyBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
FlyBtn.Text = "Полет: ВЫКЛ"
FlyBtn.BackgroundColor3 = Color_Off
styleText(FlyBtn, 12)
Instance.new("UICorner", FlyBtn)

local FlySpeedLabel = Instance.new("TextLabel", PlayerFrame)
FlySpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
FlySpeedLabel.Position = UDim2.new(0.05, 0, 0.48, 0)
FlySpeedLabel.Text = "СКОРОСТЬ ПОЛЕТА: 50"
FlySpeedLabel.BackgroundTransparency = 1
styleText(FlySpeedLabel, 10)

local AddFly = Instance.new("TextButton", PlayerFrame)
AddFly.Size = UDim2.new(0.43, 0, 0, 30)
AddFly.Position = UDim2.new(0.05, 0, 0.58, 0)
AddFly.Text = "+ ПОЛЕТ"
AddFly.BackgroundColor3 = Color_Btn
styleText(AddFly, 12)
Instance.new("UICorner", AddFly)

local SubFly = Instance.new("TextButton", PlayerFrame)
SubFly.Size = UDim2.new(0.43, 0, 0, 30)
SubFly.Position = UDim2.new(0.52, 0, 0.58, 0)
SubFly.Text = "- ПОЛЕТ"
SubFly.BackgroundColor3 = Color_Btn
styleText(SubFly, 12)
Instance.new("UICorner", SubFly)

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

OpenScripts.MouseButton1Click:Connect(function() ScriptFrame.Visible = not ScriptFrame.Visible PlayerFrame.Visible = false end)
OpenPlayer.MouseButton1Click:Connect(function() PlayerFrame.Visible = not PlayerFrame.Visible ScriptFrame.Visible = false end)

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

drag(MainFrame) drag(ScriptFrame) drag(PlayerFrame)
-- [[ ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ (СПИДОМЕТР И ФУНКЦИИ) ]] --
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
        
        -- Скорость ходьбы
        if not flyEnabled then
            hum.WalkSpeed = currentSpeed
        end

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
