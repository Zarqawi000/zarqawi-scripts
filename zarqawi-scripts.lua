-- Variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI Setup (using Delta or similar, pseudo code)
local Delta = require(game.ReplicatedStorage.Delta) -- adjust to your setup

local window = Delta:CreateWindow("Item Discord Sender")

-- Textbox for webhook URL (limit length)
local webhookTextbox = window:AddTextbox("Discord Webhook URL", "", function(text)
    if #text > 200 then -- limit length to 200 chars (adjust as needed)
        return false -- reject input if too long
    end
    return true
end)

-- Toggle for enabling sending
local enabledToggle = window:AddToggle("Enable Webhook Sender", false)

-- Button to send item name
local sendButton = window:AddButton("Send Item Name to Discord", function()
    if not enabledToggle.Value then
        print("Feature disabled.")
        return
    end

    local webhookUrl = webhookTextbox.Value
    if webhookUrl == "" then
        warn("Webhook URL not set!")
        return
    end

    local heldItemName = getHeldItemName()
    if not heldItemName then
        warn("No item held!")
        return
    end

    sendToDiscord(webhookUrl, heldItemName)
end)

-- Label to show held item name
local heldItemLabel = window:AddLabel("Held Item: None")

-- Function to detect held item name
function getHeldItemName()
    local character = player.Character
    if not character then return nil end

    -- Adjust this part based on how held item is represented
    -- Example: look for Tool in character's Backpack or character model
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item.Name
        end
    end
    return nil
end

-- Update held item label every frame or periodically
game:GetService("RunService").RenderStepped:Connect(function()
    if enabledToggle.Value then
        local name = getHeldItemName()
        if name then
            heldItemLabel.Text = "Held Item: " .. name
        else
            heldItemLabel.Text = "Held Item: None"
        end
    else
        heldItemLabel.Text = "Held Item: (disabled)"
    end
end)

-- Function to send a message to Discord webhook
function sendToDiscord(webhookUrl, message)
    local HttpService = game:GetService("HttpService")

    local data = {
        content = message
    }

    local jsonData = HttpService:JSONEncode(data)

    local success, err = pcall(function()
        HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Sent item name to Discord!")
    else
        warn("Failed to send webhook: " .. tostring(err))
    end
end
