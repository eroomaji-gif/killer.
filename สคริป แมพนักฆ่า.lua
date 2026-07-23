-- ==========================================
-- โครงสร้าง UI เมนูสคริปต์ (UI เปล่า + จัดรูปแบบปุ่มตามสั่ง)
-- ==========================================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าทิ้งก่อน (ถ้ามี)
local oldGui = playerGui:FindFirstChild("FlexibleMenuGui")
if oldGui then
    oldGui:Destroy()
end

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlexibleMenuGui"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999

-- 1. ปุ่มเปิด/ปิดหน้าต่างเมนู (เล็ก)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 110, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "📂 เปิดเมนู"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Active = true
ToggleButton.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- 2. หน้าต่างหลัก (สี่เหลี่ยมใหญ่)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 470)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- แถบหัวข้อด้านบน (Title Bar)
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  ⚡ Custom Script Menu"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- ปุ่มกากบาทปิดหน้าต่าง (Close)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0.15, 0)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- พื้นที่ใส่เมนูข้างใน (ScrollingFrame)
local Container = Instance.new("ScrollingFrame")
Container.Name = "MenuContainer"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 0, 320)
Container.ScrollBarThickness = 6


-- ==========================================
-- 📌 [ปุ่มที่ 1] วาปฆ่า+วาปหาเพื่อน (ระบบสวิตช์ ON / OFF)
-- ==========================================
getgenv().Script1_Active = false

local Btn1 = Instance.new("TextButton")
Btn1.Name = "ScriptButton1"
Btn1.Parent = Container
Btn1.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- สีแดง (ปิดอยู่)
Btn1.Position = UDim2.new(0, 0, 0, 10)
Btn1.Size = UDim2.new(1, 0, 0, 45)
Btn1.Font = Enum.Font.GothamBold
Btn1.Text = "⚡ วาปฆ่า+วาปหาเพื่อน: OFF"
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn1.TextSize = 14

local Corner1 = Instance.new("UICorner")
Corner1.CornerRadius = UDim.new(0, 6)
Corner1.Parent = Btn1

-- 1. ฟังก์ชันเช็คสีเป้าหมาย (วางไว้นอกปุ่ม)
local function getTargetColorType(targetPlayer)
    local targetChar = targetPlayer.Character
    if not targetChar then return "White" end
    local targetBackpack = targetPlayer:FindFirstChild("Backpack")
    
    if targetChar:FindFirstChild("Knife") or targetChar:FindFirstChild("Gun") or 
       (targetBackpack and (targetBackpack:FindFirstChild("Knife") or targetBackpack:FindFirstChild("Gun"))) then
        return "Red"
    end
    return "GreenOrWhite"
end

-- 2. ลูปการทำงานหลัก (วางไว้นอกปุ่มเช่นกัน ให้รันเช็คตามตัวแปร Script1_Active)
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().Script1_Active then
            pcall(function()
                local myChar = localPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                
                for _, targetPlayer in ipairs(Players:GetPlayers()) do
                    if targetPlayer ~= localPlayer and targetPlayer.Character then
                        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = targetPlayer.Character:FindFirstChild("Humanoid")
                        
                        if targetRoot and targetHum and targetHum.Health > 0 then
                            if not getgenv().Script1_Active then break end
                            
                            local colorType = getTargetColorType(targetPlayer)
                            if colorType ~= "Red" then
                                myChar.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. คำสั่งเมื่อกดปุ่ม (สลับสถานะเปิด/ปิดตรงนี้ที่เดียวจบ)
Btn1.MouseButton1Click:Connect(function()
    getgenv().Script1_Active = not getgenv().Script1_Active
    
    if getgenv().Script1_Active then
        Btn1.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- สีเขียวเมื่อเปิด
        Btn1.Text = "⚡ วาปฆ่า+วาปหาเพื่อน: ON"
    else
        Btn1.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- สีแดงเมื่อปิด
        Btn1.Text = "⚡ วาปฆ่า+วาปหาเพื่อน: OFF"
    end
end)






-- ==========================================
-- 📌 [ปุ่มที่ 2] เปิดมองทะลุ (ระบบสวิตช์ ON / OFF)
-- ==========================================
getgenv().Script2_Active = false

local Btn2 = Instance.new("TextButton")
Btn2.Name = "ScriptButton2"
Btn2.Parent = Container
Btn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- สีแดง (ปิดอยู่)
Btn2.Position = UDim2.new(0, 0, 0, 65)
Btn2.Size = UDim2.new(1, 0, 0, 45)
Btn2.Font = Enum.Font.GothamBold
Btn2.Text = "👁️ เปิดมองทะลุ: OFF"
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn2.TextSize = 14

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 6)
Corner2.Parent = Btn2

-- ฟังก์ชันเช็คสี ESP นอกปุ่ม
local function getESPColor(player)
    if player.Team and player.Team == localPlayer.Team then
        return Color3.fromRGB(0, 255, 0) -- สีเขียว (พวกเดียวกัน)
    end
    
    local character = player.Character
    if character then
        local backpack = player:FindFirstChild("Backpack")
        if character:FindFirstChild("Knife") or character:FindFirstChild("Gun") or 
           (backpack and (backpack:FindFirstChild("Knife") or backpack:FindFirstChild("Gun"))) then
            return Color3.fromRGB(255, 0, 0) -- สีแดง (อันตราย/ฆาตกร)
        end
    end
    return Color3.fromRGB(255, 255, 255) -- สีขาว (ทั่วไป)
end

-- ลูปการทำงาน ESP
task.spawn(function()
    getgenv().ActiveHighlights = {}
    game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().Script2_Active then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                if character:FindFirstChild("HumanoidRootPart") then
                    local highlight = character:FindFirstChild("CustomTeamESP")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "CustomTeamESP"
                        highlight.Adornee = character
                        highlight.OutlineTransparency = 0
                        highlight.FillTransparency = 0.4
                        highlight.Parent = character
                        table.insert(getgenv().ActiveHighlights, highlight)
                    end
                    
                    local targetColor = getESPColor(player)
                    highlight.FillColor = targetColor
                    highlight.OutlineColor = targetColor
                end
            end
        end
    end)
end)

Btn2.MouseButton1Click:Connect(function()
    getgenv().Script2_Active = not getgenv().Script2_Active
    
    if getgenv().Script2_Active then
        Btn2.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- สีเขียวเมื่อเปิด
        Btn2.Text = "👁️ เปิดมองทะลุ: ON"
    else
        Btn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- สีแดงเมื่อปิด
        Btn2.Text = "👁️ เปิดมองทะลุ: OFF"
        
        -- ล้างค่าแสง ESP ออกเมื่อปิดสคริปต์
        for _, highlight in pairs(getgenv().ActiveHighlights or {}) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
        end
        getgenv().ActiveHighlights = {}
    end
end)



-- ==========================================
-- 📌 [ปุ่มที่ 3 - ล่างสุด] วาปไปหน้าประตู (กดครั้งเดียวทำงานทันที)
-- ==========================================
local Btn3 = Instance.new("TextButton")
Btn3.Name = "ScriptButton3"
Btn3.Parent = Container
Btn3.BackgroundColor3 = Color3.fromRGB(50, 120, 200) -- สีฟ้า (กดสั่งทีเดียว)
Btn3.Position = UDim2.new(0, 0, 0, 120)
Btn3.Size = UDim2.new(1, 0, 0, 45)
Btn3.Font = Enum.Font.GothamBold
Btn3.Text = "🚪 วาปไปหน้าประตู"
Btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn3.TextSize = 14

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 6)
Corner3.Parent = Btn3

-- ฟังก์ชันค้นหาประตูทางออก
local function findKillerExitDoor()
    local bestTarget = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            if string.find(nameLower, "exit") or string.find(nameLower, "escape") or string.find(nameLower, "door") or string.find(nameLower, "gate") or string.find(nameLower, "win") then
                if obj.Transparency < 1 then
                    bestTarget = obj
                    if string.find(nameLower, "exit") or string.find(nameLower, "escape") then
                        return obj
                    end
                end
            end
        end
    end
    return bestTarget
end

Btn3.MouseButton1Click:Connect(function()
    pcall(function()
        local myChar = localPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local targetDoor = findKillerExitDoor()
        if targetDoor then
            myChar.HumanoidRootPart.CFrame = targetDoor.CFrame + Vector3.new(0, 3, 0)
            print("[Escape] วาบมาที่ประตูทางออกสำเร็จ!")
        else
            print("[Error] ยังไม่พบประตูทางออก หรือยังไม่ถึงเวลาเปิด")
        end
    end)
end)



-- ==========================================
-- 📌 [ปุ่มที่ 4] ระบบบินสำหรับมือถือ (แก้อาการเดินหน้าเป็นถอยหลัง, ซ้ายขวาสลับ)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

getgenv().Script4_FlyToggle = false
local fixedSpeed = 3 -- ความเร็วคงที่ 3

local Btn4 = Instance.new("TextButton")
Btn4.Name = "ScriptButton4"
Btn4.Parent = Container
Btn4.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Btn4.Position = UDim2.new(0, 0, 0, 175)
Btn4.Size = UDim2.new(1, 0, 0, 45)
Btn4.Font = Enum.Font.GothamBold
Btn4.Text = "✈️ ระบบบิน (Mobile): OFF"
Btn4.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn4.TextSize = 14

local Corner4 = Instance.new("UICorner")
Corner4.CornerRadius = UDim.new(0, 6)
Corner4.Parent = Btn4

local bg, bv
local flyConnection

Btn4.MouseButton1Click:Connect(function()
    getgenv().Script4_FlyToggle = not getgenv().Script4_FlyToggle
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if getgenv().Script4_FlyToggle then
        Btn4.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Btn4.Text = "✈️ ระบบบิน (Mobile): ON"
        
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        bg.Parent = hrp
        
        bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
        
        -- ลูปควบคุมทิศทาง (เอาเครื่องหมายลบออกแล้ว เพื่อให้ทิศทางตรงกับจอยสติ๊กปกติ)
        flyConnection = RunService.RenderStepped:Connect(function()
            if not getgenv().Script4_FlyToggle or not char or not hrp.Parent then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                -- แก้ไขโดยการเอาเครื่องหมายลบ (-) ออก ให้ทิศทางวิ่งตามจอยสติ๊กตรงๆ
                moveDirection = camera.CFrame:VectorToWorldSpace(humanoid.MoveDirection) * (fixedSpeed * 10)
            end
            
            bv.velocity = moveDirection
            bg.cframe = camera.CFrame
        end)
        
    else
        Btn4.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Btn4.Text = "✈️ ระบบบิน (Mobile): OFF"
        
        if flyConnection then flyConnection:Disconnect() end
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)



-- ==========================================
-- 📌 [ปุ่มที่ 5] เทเลพอร์ตกลับบ้าน (พิกัดเป๊ะๆ)
-- ==========================================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Btn5 = Instance.new("TextButton")
Btn5.Name = "ScriptButton5"
Btn5.Parent = Container
Btn5.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
Btn5.Position = UDim2.new(0, 0, 0, 225)
Btn5.Size = UDim2.new(1, 0, 0, 45)
Btn5.Font = Enum.Font.GothamBold
Btn5.Text = "🏡 เทเลพอร์ตกลับบ้าน"
Btn5.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn5.TextSize = 14

local Corner5 = Instance.new("UICorner")
Corner5.CornerRadius = UDim.new(0, 6)
Corner5.Parent = Btn5

Btn5.MouseButton1Click:Connect(function()
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- พิกัดบ้านที่คุณให้มา (เซ็ต Y สูงขึ้นนิดหน่อย +3 กันตัวละครจมพื้น)
        local homePosition = Vector3.new(-7.17, 266.55 + 3, -4.11)
        
        character.HumanoidRootPart.CFrame = CFrame.new(homePosition)
        
        Btn5.Text = "✅ กลับบ้านสำเร็จ!"
        task.wait(1.5)
        Btn5.Text = "🏡 เทเลพอร์ตกลับบ้าน"
    end
end)


    



-- ==========================================
-- 📌 [ปุ่มเช็คพิกัด] กดเพื่อเช็คและก๊อปปี้พิกัดปัจจุบัน
-- ==========================================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local BtnCoord = Instance.new("TextButton")
BtnCoord.Name = "CoordButton"
BtnCoord.Parent = Container
BtnCoord.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
BtnCoord.Position = UDim2.new(0, 0, 0, 280) -- ปรับตำแหน่ง Y ตามความเหมาะสม (อันนี้ต่อจากปุ่มที่ 5)
BtnCoord.Size = UDim2.new(1, 0, 0, 45)
BtnCoord.Font = Enum.Font.GothamBold
BtnCoord.Text = "📍 เช็คพิกัดปัจจุบัน"
BtnCoord.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCoord.TextSize = 14

local CornerCoord = Instance.new("UICorner")
CornerCoord.CornerRadius = UDim.new(0, 6)
CornerCoord.Parent = BtnCoord

BtnCoord.MouseButton1Click:Connect(function()
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local cf = character.HumanoidRootPart.CFrame
        
        -- แสดงพิกัดใน Console / Output
        print("===== 📌 พิกัดปัจจุบัน =====")
        print("Vector3.new(" .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z) .. ")")
        print("CFrame: " .. tostring(cf))
        
        -- พยายามก๊อปปี้ลงคลิปบอร์ด (ถ้าโปรแกรมรันสคริปต์รองรับ)
        local coordString = string.format("Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
        pcall(function()
            setclipboard(coordString)
        end)
        
        BtnCoord.Text = "✅ ก๊อปปี้พิกัดแล้ว!"
        task.wait(1.5)
        BtnCoord.Text = "📍 เช็คพิกัดปัจจุบัน"
    end
end)



-- ==========================================
-- 📌 [ปุ่มที่ 7] ระบบ Noclip (เดินทะลุกำแพง / สิ่งกีดขวาง): ON/OFF
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

getgenv().Script7_NoclipToggle = false

local Btn7 = Instance.new("TextButton")
Btn7.Name = "ScriptButton7"
Btn7.Parent = Container
Btn7.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Btn7.Position = UDim2.new(0, 0, 0, 335)
Btn7.Size = UDim2.new(1, 0, 0, 45)
Btn7.Font = Enum.Font.GothamBold
Btn7.Text = "👻 เดินทะลุกำแพง: OFF"
Btn7.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn7.TextSize = 14

local Corner7 = Instance.new("UICorner")
Corner7.CornerRadius = UDim.new(0, 6)
Corner7.Parent = Btn7

-- ลูปคอยปิดการชน (CanCollide) ของชิ้นส่วนตัวละครทุกๆ เฟรม
RunService.Stepped:Connect(function()
    if getgenv().Script7_NoclipToggle then
        local char = localPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

Btn7.MouseButton1Click:Connect(function()
    getgenv().Script7_NoclipToggle = not getgenv().Script7_NoclipToggle
    
    if getgenv().Script7_NoclipToggle then
        Btn7.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Btn7.Text = "👻 เดินทะลุกำแพง: ON"
    else
        Btn7.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Btn7.Text = "👻 เดินทะลุกำแพง: OFF"
    end
end)





-- ==========================================
-- 📌 [ปุ่มที่ 8] ระบบ God Mode (หลบเลี่ยงดาเมจ / ลบ TouchHitbox ตัวเอง): ON/OFF
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

getgenv().Script8_GodModeToggle = false

local Btn8 = Instance.new("TextButton")
Btn8.Name = "ScriptButton8"
Btn8.Parent = Container
Btn8.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Btn8.Position = UDim2.new(0, 0, 0, 390) -- อยู่ในตำแหน่งปุ่มที่ 8 (ต่อจากปุ่มที่ 7)
Btn8.Size = UDim2.new(1, 0, 0, 45)
Btn8.Font = Enum.Font.GothamBold
Btn8.Text = "🛡️ God Mode: OFF"
Btn8.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn8.TextSize = 14

local Corner8 = Instance.new("UICorner")
Corner8.CornerRadius = UDim.new(0, 6)
Corner8.Parent = Btn8

-- ลูปทำงานตลอดเวลาเพื่อลบตัวจับการสัมผัส (TouchInterest) ที่ทำให้โดนฆาตกรตีตาย
RunService.Stepped:Connect(function()
    if getgenv().Script8_GodModeToggle then
        local char = localPlayer.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanCollide = false
                    -- ลบ TouchInterest เพื่อให้อาวุธของฆาตกรสัมผัสตัวเราไม่ติด
                    if obj:FindFirstChild("TouchInterest") then
                        obj.TouchInterest:Destroy()
                    end
                end
            end
        end
    end
end)

Btn8.MouseButton1Click:Connect(function()
    getgenv().Script8_GodModeToggle = not getgenv().Script8_GodModeToggle
    
    if getgenv().Script8_GodModeToggle then
        Btn8.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Btn8.Text = "🛡️ God Mode: ON"
    else
        Btn8.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Btn8.Text = "🛡️ God Mode: OFF"
    end
end)




-- ระบบเปิด/ปิดหน้าต่างหลักของเมนู
local isOpened = false

ToggleButton.MouseButton1Click:Connect(function()
    isOpened = not isOpened
    MainFrame.Visible = isOpened
    if isOpened then
        ToggleButton.Text = "📁 ปิดเมนู"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    else
        ToggleButton.Text = "📂 เปิดเมนู"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    isOpened = false
    MainFrame.Visible = false
    ToggleButton.Text = "📂 เปิดเมนู"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

print("=== โหลด UI เปล่าสำเร็จ (แยกประเภทปุ่มตามสั่งเรียบร้อย) ===")
