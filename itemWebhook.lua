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

-- 🔍 Detect when player equips a tool (including existing tools)
local function onToolEquipped(tool)
    if detectionEnabled and tool:IsA("Tool") then
        local msg = "🛠️ Player equipped item: `" .. tool.Name .. "`"
        print(msg)
        sendToWebhook(msg)
    end
end

local function setupTool(tool)
    if tool:IsA("Tool") then
        tool.Equipped:Connect(function()
            onToolEquipped(tool)
        end)
    end
end

local function monitorTools()
    -- Check existing tools in Backpack and Character
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        setupTool(tool)
    end
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            setupTool(tool)
        end
    end

    -- Listen for new tools added to Backpack and Character
    LocalPlayer.Backpack.ChildAdded:Connect(setupTool)
    LocalPlayer.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(setupTool)
    end)
    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(setupTool)
    end
end

-- 🖼️ Create UI with Toggle and TextBox
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WebhookUI"
    ScreenGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 170)
    Frame.Position = UDim2.new(0, 20, 0, 100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local TextBox = Instance.new("TextBox")
    TextBox.PlaceholderText = "Enter message to send"
    TextBox.Size = UDim2.new(1, -20, 0, 40)
    TextBox.Position = UDim2.new(0, 10, 0, 10)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1,1,1)
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TextBox.BorderSizePixel = 0
    TextBox.ClearTextOnFocus = false
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextTruncate = Enum.TextTruncate.None
    TextBox.TextWrapped = false
    TextBox.Parent = Frame

    -- Limit max length to 100 chars
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if #TextBox.Text > 100 then
            TextBox.Text = TextBox.Text:sub(1, 100)
        end
    end)

    local SendButton = Instance.new("TextButton")
    SendButton.Text = "Send to Webhook"
    SendButton.Size = UDim2.new(1, -20, 0, 40)
    SendButton.Position = UDim2.new(0, 10, 0, 60)
    SendButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    SendButton.TextColor3 = Color3.new(1,1,1)
    SendButton.BorderSizePixel = 0
    SendButton.Parent = Frame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Text = "Detection: ON"
    ToggleButton.Size = UDim2.new(1, -20, 0, 40)
    ToggleButton.Position = UDim2.new(0, 10, 0, 110)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Green by default
    ToggleButton.TextColor3 = Color3.new(1,1,1)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = Frame

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

-- 🚀 Start everything
monitorTools()
createUI()
