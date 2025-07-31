-- ✅ CONFIGURATION
local webhookURL = "https://discord.com/api/webhooks/your_webhook_here" -- Replace with your webhook URL

-- 🔗 Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- 📡 Send message to Discord webhook
local function sendToWebhook(message)
    local data = {
        ["content"] = message
    }

    local jsonData = HttpService:JSONEncode(data)
    local requestFunc = request or http_request or syn and syn.request or fluxus and fluxus.request

    if requestFunc then
        requestFunc({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    else
        warn("HTTP request not supported by this executor.")
    end
end

-- 🔁 Detection toggle state
local detectionEnabled = true

-- 🔍 Detect tool pick-up or equip
local function onItemAdded(item)
    if detectionEnabled and item:IsA("Tool") then
        local msg = "🛠️ Player picked up or equipped item: `" .. item.Name .. "`"
        print(msg)
        sendToWebhook(msg)
    end
end

local function monitorTools()
    LocalPlayer.Backpack.ChildAdded:Connect(onItemAdded)

    LocalPlayer.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(onItemAdded)
    end)

    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(onItemAdded)
    end
end

-- 🖼️ Create UI with Toggle
local function createUI()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "WebhookUI"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 170)
    Frame.Position = UDim2.new(0, 20, 0, 100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.PlaceholderText = "Enter message to send"
    TextBox.Size = UDim2.new(1, -20, 0, 40)
    TextBox.Position = UDim2.new(0, 10, 0, 10)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1,1,1)
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TextBox.BorderSizePixel = 0

    local SendButton = Instance.new("TextButton", Frame)
    SendButton.Text = "Send to Webhook"
    SendButton.Size = UDim2.new(1, -20, 0, 40)
    SendButton.Position = UDim2.new(0, 10, 0, 60)
    SendButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    SendButton.TextColor3 = Color3.new(1,1,1)
    SendButton.BorderSizePixel = 0

    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Text = "Detection: ON"
    ToggleButton.Size = UDim2.new(1, -20, 0, 40)
    ToggleButton.Position = UDim2.new(0, 10, 0, 110)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Green by default
    ToggleButton.TextColor3 = Color3.new(1,1,1)
    ToggleButton.BorderSizePixel = 0

    -- 🔘 Button logic
    SendButton.MouseButton1Click:Connect(function()
        local text = TextBox.Text
        if text and text ~= "" then
            sendToWebhook("📩 Manual message: " .. text)
        end
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        detectionEnabled = not detectionEnabled
        if detectionEnabled then
            ToggleButton.Text = "Detection: ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        else
            ToggleButton.Text = "Detection: OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        end
    end)
end

-- 🚀 Start
monitorTools()
createUI()
