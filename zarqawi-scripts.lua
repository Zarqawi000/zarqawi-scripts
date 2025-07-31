-- Load Services
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JobID_TeleportUI"
screenGui.ResetOnSpawn = false

-- Executor UI protection
if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

screenGui.Parent = game.CoreGui

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Show Teleport UI"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Join a Server by Job ID"
titleLabel.TextWrapped = true
titleLabel.Parent = frame

-- TextBox for Input
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 50)
textBox.PlaceholderText = "Paste Job ID here..."
textBox.Text = ""
textBox.TextScaled = true
textBox.Font = Enum.Font.SourceSans
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
textBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = textBox

-- Teleport Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 95)
button.Text = "Join Server by Job ID"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = button

-- Teleport Function
button.MouseButton1Click:Connect(function()
    local targetJobId = textBox.Text
    if targetJobId ~= "" then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, targetJobId, LocalPlayer)
        end)
    else
        button.Text = "Enter a valid Job ID!"
        task.wait(2)
        button.Text = "Join Server by Job ID"
    end
end)

-- Toggle Function
local isOpen = false
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    frame.Visible = isOpen
    toggleButton.Text = isOpen and "Hide Teleport UI" or "Show Teleport UI"
end)
