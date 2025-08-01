--// Webhook URL
local webhookURL = "https://discord.com/api/webhooks/1398936697651200011/HWm20r9J3M4gUcvTvU-bIo9z77U7BSDJgLlVc_ijKJxFYFiZ2n3OWZqgwWpg9FfkqWoe"

--// Function to send webhook with embed
local function sendWebhook(itemName)
    local httpService = game:GetService("HttpService")

    local data = {
        embeds = {{
            title = "🎯 You got a new pet",
            description = "**Item:** " .. itemName,
            color = 0x00FF00, -- Green
            timestamp = DateTime.now():ToIsoDate()
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

--// Function to send webhook when quantity changes
local function sendQuantityChangeWebhook(itemName, newQty)
    local httpService = game:GetService("HttpService")

    local data = {
        embeds = { {
            title = "🔄 You got a new seed",
            description = "**Item:** " .. itemName .. "\n**New Quantity:** " .. tostring(newQty),
            color = 0x00FF00,
            timestamp = DateTime.now():ToIsoDate()
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

--// UI Indicator
local function createStatusUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptStatusUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = screenGui
    statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.Text = "✅ Notifier by Zarqawi"
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 18
    statusLabel.Size = UDim2.new(0, 280, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 10)
    statusLabel.BorderSizePixel = 0
    statusLabel.BackgroundTransparency = 0.2
end

--// Create UI
createStatusUI()

--// Monitor Player's Backpack
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Track previous quantities
local previousQuantities = {}

-- Function to track quantity of tools
local function trackTool(tool)
    if tool:IsA("Tool") then
        local toolName = tool.Name
        local lastQuantity = tool:GetAttribute("Quantity")
        previousQuantities[tool] = lastQuantity

        -- React to quantity change
        tool:GetAttributeChangedSignal("Quantity"):Connect(function()
            local newQuantity = tool:GetAttribute("Quantity")
            if newQuantity ~= previousQuantities[tool] then
                previousQuantities[tool] = newQuantity
                sendQuantityChangeWebhook(toolName, newQuantity)
            end
        end)
    end
end

-- Handle already existing tools
for _, tool in ipairs(backpack:GetChildren()) do
    trackTool(tool)
end

-- New tool added
backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        sendWebhook(tool.Name)
        task.wait(0.5) -- Give time for attributes to load
        trackTool(tool)
    end
end)

-- Tool removed
backpack.ChildRemoved:Connect(function(tool)
    previousQuantities[tool] = nil
end)
