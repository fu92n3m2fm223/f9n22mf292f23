local CoreGui = game:GetService("CoreGui")

local webhookURL = "https://discord.com/api/webhooks/1258398166789783643/Uy3RQJEXOJ1gKQTUOT7Y7zPk_E2ELc08rtTZsUdLSn6gOegeD7qfcMQaiE1RVl6ENhs2"

local webhookSent = false

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
	["title"] = "User " .. game:GetService("Players").LocalPlayer.Name .. " Attempted to use a Remotespy",
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

game:GetService("RunService").RenderStepped:Connect(function()
	if not webhookSent then
		for _, GUI in pairs(CoreGui:GetChildren()) do
			if GUI:FindFirstChild("ImageLabel") then
				if executorName == "Wave" then
					if not webhookSent then
						request(httpRequest)
						webhookSent = true
						game:Shutdown()
						break
					end
				end
			end
		end
	end
end)
