-- Load Services
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JobID_TeleportUI"
screenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

screenGui.Parent = game.CoreGui

-- Main UI Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Join a Server by Job ID"
titleLabel.TextWrapped = true
titleLabel.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0, 6)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

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

-- Floating Open Button (hidden by default)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 140, 0, 30)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Text = "Open Teleport UI"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextScaled = true
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

-- Teleport Logic
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

-- Close and Open Logic
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    frame.Visible = true
    openButton.Visible = false
end)
