--// Default Webhook URL
local function sendWebhook(itemName)
    local httpService = game:GetService("HttpService")
    
    local mentionEveryone = (itemName == "Tranquil Bloom Seed" or itemName == "Corrupted Kitsune")

    local data = {
        content = mentionEveryone and "@everyone" or nil,
        embeds = { {
            title = "🐶 You got a new pet",
            description = "**Item:** " .. itemName,
            color = 0x00FF00,
            timestamp = DateTime.now():ToIsoDate(),
            footer = {
                text = "Made by Zarqawi"
            }
        }},
        username = "Notifier by Zarqawi"
    }

    local jsonData = httpService:JSONEncode(data)
    local requestFunction = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

    if requestFunction then
        requestFunction({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    else
        warn("Your executor does not support HTTP requests.")
    end
end


--// Send webhook when quantity changes
local function sendQuantityChangeWebhook(itemName, newQty)
    local httpService = game:GetService("HttpService")

    local mentionEveryone = (itemName == "Tranquil Bloom Seed" or itemName == "Corrupted Kitsune")

    local data = {
        content = mentionEveryone and "@everyone" or nil,
        embeds = { {
            title = "🌱 You got a new seed",
            description = "**Item:** " .. itemName .. "\n**New Quantity:** " .. tostring(newQty),
            color = 0x00FF00,
            timestamp = DateTime.now():ToIsoDate(),
            footer = {
                text = "Made by Zarqawi"
            }
        }},
        username = "Notifier by Zarqawi"
    }

    local jsonData = httpService:JSONEncode(data)
    local requestFunction = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

    if requestFunction then
        requestFunction({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    else
        warn("Your executor does not support HTTP requests.")
    end
end

--// Create UI
local function createStatusUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptStatusUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")

    local container = Instance.new("Frame")
    container.Name = "MainFrame"
    container.Parent = screenGui
    container.Size = UDim2.new(0, 310, 0, 90)
    container.Position = UDim2.new(0, 10, 0, 10)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    container.BorderSizePixel = 0
    container.BackgroundTransparency = 0.2

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = container
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.Text = "✅ Notifier by Zarqawi"
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 18
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 5)

    -- X Button to close UI
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = container
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.BorderSizePixel = 0

    -- Open Button (initially hidden)
    local openButton = Instance.new("TextButton")
    openButton.Name = "OpenButton"
    openButton.Parent = screenGui
    openButton.Size = UDim2.new(0, 80, 0, 30)
    openButton.Position = UDim2.new(0, 10, 0, 110)
    openButton.Text = "Open UI"
    openButton.Visible = false
    openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    openButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    openButton.Font = Enum.Font.Gotham
    openButton.TextSize = 14
    openButton.BorderSizePixel = 0

    -- Webhook TextBox
    local webhookBox = Instance.new("TextBox")
    webhookBox.Name = "WebhookBox"
    webhookBox.Parent = container
    webhookBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    webhookBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    webhookBox.PlaceholderText = "Put your webhook link here and press Enter"
    webhookBox.Font = Enum.Font.Gotham
    webhookBox.TextSize = 14
    webhookBox.ClearTextOnFocus = false
    webhookBox.TextXAlignment = Enum.TextXAlignment.Left
    webhookBox.TextWrapped = false
    webhookBox.TextTruncate = Enum.TextTruncate.AtEnd
    webhookBox.ClipsDescendants = true
    webhookBox.Size = UDim2.new(1, -20, 0, 25)
    webhookBox.Position = UDim2.new(0, 10, 0, 40)
    webhookBox.BorderSizePixel = 0
    webhookBox.BackgroundTransparency = 0.1

    -- Logic to update webhookURL
    webhookBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if webhookBox.Text:match("^https://discord.com/api/webhooks/") then
                webhookURL = webhookBox.Text
                statusLabel.Text = "✅ Webhook updated!"
                task.delay(3, function()
                    if statusLabel then
                        statusLabel.Text = "✅ Notifier by Zarqawi"
                    end
                end)
            else
                statusLabel.Text = "❌ Invalid webhook URL"
                task.delay(3, function()
                    if statusLabel then
                        statusLabel.Text = "✅ Notifier by Zarqawi"
                    end
                end)
            end
        end
    end)

    -- Close and open logic
    closeButton.MouseButton1Click:Connect(function()
        container.Visible = false
        openButton.Visible = true
    end)

    openButton.MouseButton1Click:Connect(function()
        container.Visible = true
        openButton.Visible = false
    end)
end

-- Create UI
createStatusUI()

-- Track backpack items
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local previousQuantities = {}

local function trackTool(tool)
    if tool:IsA("Tool") then
        local toolName = tool.Name
        local lastQuantity = tool:GetAttribute("Quantity")
        previousQuantities[tool] = lastQuantity

        tool:GetAttributeChangedSignal("Quantity"):Connect(function()
            local newQuantity = tool:GetAttribute("Quantity")
            if newQuantity ~= previousQuantities[tool] then
                previousQuantities[tool] = newQuantity
                sendQuantityChangeWebhook(toolName, newQuantity)
            end
        end)
    end
end

for _, tool in ipairs(backpack:GetChildren()) do
    trackTool(tool)
end

backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        sendWebhook(tool.Name)
        task.wait(0.5)
        trackTool(tool)
    end
end)

backpack.ChildRemoved:Connect(function(tool)
    previousQuantities[tool] = nil
end)
