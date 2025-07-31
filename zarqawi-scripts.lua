-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Executor HTTP request function
local request = (syn and syn.request) or (http and http.request) or (request) or (http_request)
if not request then
    warn("HTTP not supported.")
    return
end

-- Webhook URL (replace this)
local webhookURL = "https://discord.com/api/webhooks/1398936697651200011/HWm20r9J3M4gUcvTvU-bIo9z77U7BSDJgLlVc_ijKJxFYFiZ2n3OWZqgwWpg9FfkqWoe"

-- Items to watch for
local watchNames = {
    ["Tranquil Blossom"] = true,
    ["Corrupted Kitsune Seed"] = true,
    ["Dezen Seed"] = true
}

-- Track already notified (prevent spam)
local notified = {}

-- Send notification
local function notify(name, parentName)
    if notified[name] then return end
    notified[name] = true

    local message = {
        content = string.format("🎉 **New Item Hatched!**\n• Name: `%s`\n• From: `%s`", name, parentName)
    }

    request({
        Url = webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(message)
    })
end

-- Scan a folder for matching items
local function watchFolder(folder)
    folder.ChildAdded:Connect(function(child)
        task.wait(0.5) -- allow name to settle
        if watchNames[child.Name] then
            notify(child.Name, folder.Name)
        end
    end)

    -- Scan existing
    for _, child in pairs(folder:GetChildren()) do
        if watchNames[child.Name] then
            notify(child.Name, folder.Name)
        end
    end
end

-- === Folders to monitor ===
local foldersToWatch = {
    LocalPlayer:WaitForChild("Backpack"),
    LocalPlayer:WaitForChild("PlayerGui"),
    game:GetService("ReplicatedStorage"),
}

-- Start watching
for _, folder in ipairs(foldersToWatch) do
    watchFolder(folder)
end

-- Optional UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ItemHatchNotifier"

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 320, 0, 40)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.TextXAlignment = Enum.TextXAlignment.Left
label.Text = "📡 Hatch Notifier Running..."

task.spawn(function()
    while true do
        local found = {}
        for name in pairs(notified) do
            table.insert(found, name)
        end
        if #found > 0 then
            label.Text = "✅ Hatched: " .. table.concat(found, ", ")
        end
        task.wait(2)
    end
end)
