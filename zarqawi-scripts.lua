-- THIS SCRIPT IS MAINTAINED AND BUILT BY ZARQAWI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZarqaworksUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local function createPanel(name, position)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.Size = UDim2.new(0, 180, 0, 180)
    panel.Position = position
    panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    panel.BorderSizePixel = 0
    panel.Visible = true
    panel.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = panel

    return panel
end

-- Left-center panel position
local panelone = createPanel("panelone", UDim2.new(0, 10, 0.5, -90))
local paneltwo = createPanel("paneltwo", UDim2.new(0, 192, 0.5, -90))
paneltwo.Visible = false

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 24)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextScaled = true
titleLabel.Text = "Zarqaworks"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = panelone
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local function createCategoryButton(name, text, posY)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -12, 0, 20)
    button.Position = UDim2.new(0, 6, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = panelone

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    return button
end

local aimingButton = createCategoryButton("AimingButton", "Aiming", 30)
local visualButton = createCategoryButton("VisualButton", "Visual", 55)

local aimingFrame = Instance.new("Frame")
aimingFrame.Name = "AimingFrame"
aimingFrame.Size = UDim2.new(1, 0, 1, 0)
aimingFrame.BackgroundTransparency = 1
aimingFrame.Visible = false
aimingFrame.Parent = paneltwo

local visualFrame = Instance.new("Frame")
visualFrame.Name = "VisualFrame"
visualFrame.Size = UDim2.new(1, 0, 1, 0)
visualFrame.BackgroundTransparency = 1
visualFrame.Visible = false
visualFrame.Parent = paneltwo

local function createButton(parent, name, posY)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -12, 0, 20)
    button.Position = UDim2.new(0, 6, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name .. ": OFF"
    button.Font = Enum.Font.Gotham
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    return button
end

local aimbotToggle = createButton(aimingFrame, "Aimbot", 5)
local lockPartToggle = createButton(aimingFrame, "Lock Part", 30)
local checkWallsToggle = createButton(aimingFrame, "Check Walls", 55)

local espToggle = createButton(visualFrame, "ESP", 5)
local bodyHighlightToggle = createButton(visualFrame, "Body Highlights", 30)
local headEnlargerToggle = createButton(visualFrame, "Head Enlarger", 55)

local teamCheck = false
local fov = 50
local predictionFactor = 0.08
local aimbotEnabled = false
local lockPart = "Head"
local checkWalls = true

-- Show notification at script execution
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Nicetry Hub",
    Text = "Successfully Executed, This script is made by Zarqawi",
    Duration = 5
})

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1
FOVring.Radius = fov
FOVring.Transparency = 0
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
FOVring.Filled = false

local function isVisible(part)
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = (part.Position - origin).Unit * 500
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result and result.Instance and result.Instance:IsDescendantOf(part.Parent)
end

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
                if onScreen and distanceFromCenter <= fov and (not checkWalls or isVisible(part)) then
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
    local currentTarget = getClosest(workspace.CurrentCamera.CFrame)
    if currentTarget and currentTarget.Character then
        local predictedPosition = predictPosition(currentTarget)
        if predictedPosition then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, predictedPosition)
        end
    end
end)

aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

lockPartToggle.MouseButton1Click:Connect(function()
    lockPart = (lockPart == "Head") and "Torso" or "Head"
    lockPartToggle.Text = "Lock Part: " .. lockPart
end)

checkWallsToggle.MouseButton1Click:Connect(function()
    checkWalls = not checkWalls
    checkWallsToggle.Text = "Check Walls: " .. (checkWalls and "ON" or "OFF")
end)

-- ESP and Highlights
local espEnabled = false
local highlightEnabled = false
local highlights = {}
local nameTags = {}

local function clearESP()
    for _, tag in pairs(nameTags) do tag:Destroy() end
    nameTags = {}
end

local function clearHighlights()
    for _, h in pairs(highlights) do h:Destroy() end
    highlights = {}
end

local function createNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Adornee = player.Character:FindFirstChild("Head")
        billboard.Size = UDim2.new(0, 130, 0, 25)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character

        local label = Instance.new("TextLabel")
        label.Name = "TagLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Cartoon
        label.TextScaled = true
        label.TextStrokeTransparency = 0.6
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Parent = billboard

        nameTags[player] = billboard
    end
end

local function updateNameTag(player)
    if nameTags[player] and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
        local tag = nameTags[player]:FindFirstChild("TagLabel")
        if tag then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local health = math.floor(player.Character.Humanoid.Health)
            tag.Text = player.DisplayName .. " (@".. player.Name .. ") | " .. string.format("%.0f", distance) .. "m | ❤" .. health
        end
    end
end

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
        highlights[player] = highlight
    end
end

local function updateHighlight(player)
    if highlights[player] and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then
            highlights[player].FillColor = Color3.fromRGB(120, 0, 0)
        else
            highlights[player].FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if espEnabled then
                if not nameTags[player] then createNameTag(player) end
                updateNameTag(player)
            else
                if nameTags[player] then nameTags[player]:Destroy(); nameTags[player] = nil end
            end

            if highlightEnabled then
                if not highlights[player] then createHighlight(player) end
                updateHighlight(player)
            else
                if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
            end
        end
    end
end)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    clearESP()
end)

bodyHighlightToggle.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    bodyHighlightToggle.Text = "Body Highlights: " .. (highlightEnabled and "ON" or "OFF")
    clearHighlights()
end)

-- Head Enlarger
local headEnlargerEnabled = false
local originalHeads = {}

headEnlargerToggle.MouseButton1Click:Connect(function()
    headEnlargerEnabled = not headEnlargerEnabled
    headEnlargerToggle.Text = "Head Enlarger: " .. (headEnlargerEnabled and "ON" or "OFF")
    if not headEnlargerEnabled then
        for player, data in pairs(originalHeads) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                head.Size = data.Size
                head.Transparency = data.Transparency
                head.BrickColor = data.BrickColor
                head.Material = data.Material
                head.CanCollide = data.CanCollide
                head.Massless = data.Massless
            end
        end
        originalHeads = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if headEnlargerEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if not originalHeads[player] then
                    originalHeads[player] = {
                        Size = head.Size,
                        Transparency = head.Transparency,
                        BrickColor = head.BrickColor,
                        Material = head.Material,
                        CanCollide = head.CanCollide,
                        Massless = head.Massless
                    }
                end
                head.Size = Vector3.new(6, 6, 6)
                head.Transparency = 1
                head.BrickColor = BrickColor.new("Red")
                head.Material = Enum.Material.Neon
                head.CanCollide = false
                head.Massless = true
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        local state = not panelone.Visible
        panelone.Visible = state
        if not state then
            paneltwo.Visible = false
        else
            if aimingFrame.Visible or visualFrame.Visible then
                paneltwo.Visible = true
            end
        end
    end
end)

local currentCategory = ""
aimingButton.MouseButton1Click:Connect(function()
    if currentCategory == "Aiming" then
        paneltwo.Visible = false
        aimingFrame.Visible = false
        currentCategory = ""
    else
        paneltwo.Visible = true
        aimingFrame.Visible = true
        visualFrame.Visible = false
        currentCategory = "Aiming"
    end
end)

visualButton.MouseButton1Click:Connect(function()
    if currentCategory == "Visual" then
        paneltwo.Visible = false
        visualFrame.Visible = false
        currentCategory = ""
    else
        paneltwo.Visible = true
        visualFrame.Visible = true
        aimingFrame.Visible = false
        currentCategory = "Visual"
    end
end)
