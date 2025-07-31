-- Detect when player equips a tool (including existing tools)
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

TextBox.ClearTextOnFocus = false
TextBox.TextWrapped = true  -- allows multiline wrapping (optional)
TextBox.TextXAlignment = Enum.TextXAlignment.Left  -- text aligns left
TextBox.TextTruncate = Enum.TextTruncate.None -- disables truncation

TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.ClearTextOnFocus = false

-- Optional: limit text length so it doesn't overflow
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    if #TextBox.Text > 100 then
        TextBox.Text = TextBox.Text:sub(1, 100) -- max 100 chars
    end
end)

-- After creating TextBox:
TextBox.ClearTextOnFocus = false
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextTruncate = Enum.TextTruncate.None
TextBox.TextWrapped = false  -- if you want multiline, set true

-- Limit max length (optional)
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    if #TextBox.Text > 100 then
        TextBox.Text = TextBox.Text:sub(1, 100)
    end
end)

