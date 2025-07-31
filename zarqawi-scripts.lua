-- Delta Executor Script: Server Job ID GUI with Teleport Button

-- Load Services
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local jobId = game.JobId
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

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Current Job ID:\n" .. (jobId ~= "" and jobId or "Unavailable")
titleLabel.TextWrapped = true
titleLabel.Parent = frame

-- TextBox for Input
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 90)
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
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 140)
button.Text = "Join Server by Job ID"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = button

-- Button Function
button.MouseButton1Click:Connect(function()
    local targetJobId = textBox.Text
    if targetJobId ~= "" then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, targetJobId, LocalPlayer)
        end)
    else
        button.Text = "Enter a valid Job ID!"
        wait(2)
        button.Text = "Join Server by Job ID"
    end
end)
