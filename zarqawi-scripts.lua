-- SCRIPT IS MADE BY ZARQAWI
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 6)

-- UI Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Text = "Made by Zarqawi"
TitleLabel.LayoutOrder = 0
TitleLabel.Parent = Frame

-- UIListLayout for buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)  -- 8 pixels spacing
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Toggle button creator
local toggleIndex = 1
local function createToggle(name, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.8, 0, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.Text = name .. ": OFF"
    toggle.LayoutOrder = toggleIndex
    toggleIndex = toggleIndex + 1

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        toggle.Text = name .. ": " .. (on and "ON" or "OFF")
        callback(on)
    end)

    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 4)

    return toggle
end

-- ESP Script
local espConnections = {}
local espScriptEnabled = false

local function clearESP()
    for _, con in pairs(espConnections) do
        con:Disconnect()
    end
    espConnections = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            if player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") then
                player.Character.Head.NameTag:Destroy()
            end
        end
    end
end

local function toggleESP(state)
    espScriptEnabled = state
    clearESP()

    if not state then return end

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
            billboard.Size = UDim2.new(0, 130, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = player.Character.Head

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TagLabel"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.Font = Enum.Font.Cartoon
            textLabel.TextScaled = true
            textLabel.TextStrokeTransparency = 0.6
            textLabel.Text = ""
            textLabel.Parent = billboard
        end
    end

    local function update(player)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Head:FindFirstChild("NameTag") then
                local distance = (LocalPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
                local health = math.floor(player.Character.Humanoid.Health)
                player.Character.Head.NameTag.TagLabel.Text = player.Name .. " | " .. string.format("%.0f", distance).."m | ❤️"..health
            end
            if player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight.FillColor = player.Character.Humanoid.Health <= 0 and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    end

    local function setup(player)
        if player ~= LocalPlayer then
            table.insert(espConnections, player.CharacterAdded:Connect(function()
                wait(0.1)
                createHighlight(player)
                createNameTag(player)
            end))
            if player.Character then
                createHighlight(player)
                createNameTag(player)
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do setup(p) end

    table.insert(espConnections, Players.PlayerAdded:Connect(setup))

    table.insert(espConnections, RunService.RenderStepped:Connect(function()
        if espScriptEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    update(p)
                end
            end
        end
    end))
end

-- Head Enlarger Script with Original Properties Storage
local headScriptEnabled = false
local originalHeadProperties = {} -- Store original head properties

local function storeOriginalHeadProperties(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        originalHeadProperties[player.UserId] = {
            Size = head.Size,
            Transparency = head.Transparency,
            BrickColor = head.BrickColor,
            Material = head.Material,
            CanCollide = head.CanCollide,
            Massless = head.Massless
        }
    end
end

local function restoreHeads()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            pcall(function()
                local head = p.Character.Head
                local props = originalHeadProperties[p.UserId]
                
                if props then
                    -- Restore original properties
                    head.Size = props.Size
                    head.Transparency = props.Transparency
                    head.BrickColor = props.BrickColor
                    head.Material = props.Material
                    head.CanCollide = props.CanCollide
                    head.Massless = props.Massless
                else
                    -- Fallback to default values if original properties weren't stored
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.BrickColor = BrickColor.new("Medium stone grey")
                    head.Material = Enum.Material.Plastic
                    head.CanCollide = true
                    head.Massless = false
                end
            end)
        end
    end
end

local function toggleHead(state)
    headScriptEnabled = state
    _G.Disabled = not state
    _G.HeadSize = 6

    if state then
        -- Store original properties when enabling
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                storeOriginalHeadProperties(p)
            end
        end
    else
        -- Restore original properties when disabling
        restoreHeads()
    end
end

-- Store original properties for new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.1) -- Wait for character to fully load
        if headScriptEnabled then
            storeOriginalHeadProperties(player)
        end
    end)
end)

-- Store original properties for existing players when they respawn
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(0.1)
            if headScriptEnabled then
                storeOriginalHeadProperties(player)
            end
        end)
        -- Store for already existing characters
        if player.Character then
            storeOriginalHeadProperties(player)
        end
    end
end

-- Create toggles and parent them to Frame
local espToggle = createToggle("ESP", toggleESP)
espToggle.Parent = Frame

local headToggle = createToggle("Head Enlarger", toggleHead)
headToggle.Parent = Frame

-- Head Enlarger Loop
RunService.RenderStepped:Connect(function()
    if headScriptEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                pcall(function()
                    -- Store original properties if not already stored
                    if not originalHeadProperties[v.UserId] then
                        storeOriginalHeadProperties(v)
                    end
                    
                    -- Apply enlarged head properties
                    v.Character.Head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    v.Character.Head.Transparency = 1
                    v.Character.Head.BrickColor = BrickColor.new("Red")
                    v.Character.Head.Material = Enum.Material.Neon
                    v.Character.Head.CanCollide = false
                    v.Character.Head.Massless = true
                end)
            end
        end
    end
end)

-- Keybind for UI Toggle (G)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        Frame.Visible = not Frame.Visible
    end
end)
