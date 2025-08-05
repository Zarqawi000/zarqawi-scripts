-- MADE BY ZARQAWI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Creation
local ZarqawiUI = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ZarqawiUI.Name = "ZarqawiUI"
ZarqawiUI.ResetOnSpawn = false

local main = Instance.new("Frame", ZarqawiUI)
main.Name = "Main"
main.Position = UDim2.new(0, 10, 0.5, -115)
main.Size = UDim2.new(0, 200, 0, 250)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

-- Add title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "Made by Zarqawi"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", main)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    main.Size = UDim2.new(0, 200, 0, UIListLayout.AbsoluteContentSize.Y + 40)
end)

local function addButton(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(0, 115, 200)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = main
    return button
end

-- Buttons
local btn1 = addButton("ESP: OFF")
local btn2 = addButton("Head Enlarger: OFF")
local btn3 = addButton("Aimbot: OFF")
local btn4 = addButton("Lock: Head")

-- Toggle UI with G key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        main.Visible = not main.Visible
    end
end)

-- Aimbot Integration
local teamCheck = false
local fov = 50
local predictionFactor = 0.08
local aimbotEnabled = false
local lockPart = "Head"

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1
FOVring.Radius = fov
FOVring.Transparency = 0
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
FOVring.Filled = false

local currentTarget = nil

local function getTargetPart(character)
    if not character then return nil end
    if lockPart == "Head" then
        return character:FindFirstChild("Head")
    else
        return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
end

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
    local target = nil
    local mag = math.huge
    local screenCenter = workspace.CurrentCamera.ViewportSize / 2

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and (v.Team ~= LocalPlayer.Team or not teamCheck) then
            local part = getTargetPart(v.Character)
            if part then
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                if onScreen and distanceFromCenter <= fov then
                    local magBuf = (part.Position - ray:ClosestPoint(part.Position)).Magnitude
                    if magBuf < mag then
                        mag = magBuf
                        target = v
                    end
                end
            end
        end
    end
    return target
end

local function predictPosition(target)
    if target and target.Character then
        local part = getTargetPart(target.Character)
        if part then
            local velocity = part.Velocity
            local position = part.Position
            return position + (velocity * predictionFactor)
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end
    currentTarget = getClosest(workspace.CurrentCamera.CFrame)
    if currentTarget and currentTarget.Character then
        local predictedPosition = predictPosition(currentTarget)
        if predictedPosition then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, predictedPosition)
        end
    end
end)

-- Button 3: Aimbot Toggle
btn3.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    btn3.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    btn3.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 115, 200)
    
    StarterGui:SetCore("SendNotification", {
        Title = "Made by Zarqawi",
        Text = aimbotEnabled and "Aimbot enabled!" or "Aimbot disabled",
        Duration = 3,
    })
end)

-- Button 4: Lock Part Toggle
btn4.MouseButton1Click:Connect(function()
    if lockPart == "Head" then
        lockPart = "Torso"
        btn4.Text = "Lock: Body"
    else
        lockPart = "Head"
        btn4.Text = "Lock: Head"
    end
end)

-- Head Enlarger Logic
local originalSizes = {}
_G.HeadSize = 6
_G.Disabled = false

btn2.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled
    btn2.Text = _G.Disabled and "Head Enlarger: ON" or "Head Enlarger: OFF"
    btn2.BackgroundColor3 = _G.Disabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 115, 200)
end)

RunService.RenderStepped:Connect(function()
    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            if _G.Disabled then
                if not originalSizes[v.Name] then
                    originalSizes[v.Name] = head.Size
                end
                head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                head.Transparency = 1
                head.BrickColor = BrickColor.new("Red")
                head.Material = Enum.Material.Neon
                head.CanCollide = false
                head.Massless = true
            elseif originalSizes[v.Name] then
                head.Size = originalSizes[v.Name]
                head.Transparency = 0
                head.BrickColor = BrickColor.new("Medium stone grey")
                head.Material = Enum.Material.Plastic
                head.CanCollide = true
                head.Massless = false
                originalSizes[v.Name] = nil
            end
        end
    end
end)

-- Enhanced ESP Logic with Highlight
local espEnabled = false
local espConnections = {}

local function createHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

local function createNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TagLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.Text = ""
        textLabel.Parent = billboard
    end
end

local function updateNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") and player.Character:FindFirstChild("Humanoid") then
        local tag = player.Character.Head.NameTag.TagLabel
        local distance = (LocalPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
        local health = math.floor(player.Character.Humanoid.Health)
        tag.Text = string.format("%s [%s] | %dm | ❤️ %d", 
            player.DisplayName, 
            player.Name, 
            math.floor(distance),
            health)
    end
end

local function updateHighlight(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(120, 0, 0)
        else
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

local function setupESP(player)
    if player ~= LocalPlayer then
        local function setupCharacter()
            if espEnabled then
                createHighlight(player)
                createNameTag(player)
            end
        end
        
        if not espConnections[player] then
            espConnections[player] = player.CharacterAdded:Connect(function()
                wait(0.1)
                setupCharacter()
            end)
        end
        
        if player.Character then
            setupCharacter()
        end
    end
end

local function refreshESP()
    -- Clear existing ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") then
                player.Character.Head.NameTag:Destroy()
            end
        end
    end
    
    -- Recreate ESP if enabled
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            setupESP(player)
        end
    end
end

-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end

Players.PlayerAdded:Connect(function(player)
    setupESP(player)
end)

-- ESP Toggle Button with refresh functionality
btn1.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    btn1.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    btn1.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 115, 200)
    refreshESP()
end)

-- Update ESP elements periodically
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                updateNameTag(player)
                updateHighlight(player)
            end
        end
    end
end)
