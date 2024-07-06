local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local Games = {
	FreedomWar = {
		Lobby = 11534222714,
		Campaign = 11564374799,
		Practice = 11567929685,
	}
}

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local VirtualManager = game:GetService("VirtualInputManager")

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Window = Library:CreateWindow({
	Title = tostring("Tear - " .. game.PlaceId),
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Main = Window:AddTab('Main'),
	--ESP = Window:AddTab('ESP'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

getgenv().InfiniteGas = false
getgenv().InfiniteBlades = false
getgenv().TitanDetection = false
getgenv().Skills = false
getgenv().DamageSpoof = false
getgenv().MindlessNapeHitbox = false
getgenv().ShifterNapeHitbox = false
getgenv().InfiniteHP = false
getgenv().Hood = false
getgenv().NoCooldown = false
getgenv().InfiniteTS = false
getgenv().InfSStamina = false
getgenv().ShifterNoCooldown = false
getgenv().horsespeed = false
getgenv().PlrESP = false
getgenv().AntiHook = false
getgenv().AutoHandcut = false
getgenv().Clothes = false
getgenv().SuperJumpAir = false
getgenv().TitanESP = false
getgenv().ShifterESP = false
getgenv().Timer = false
getgenv().HumanSpeed = false

getgenv().message = function(msg)
	Library:Notify(msg)
end

local Cheats = Tabs.Main:AddLeftGroupbox('')
local Cheats2 = Tabs.Main:AddRightGroupbox('')
--local ESP1 = Tabs.ESP:AddLeftGroupbox('')

local function IsNetworkOwner(Part)
	return Part.ReceiveAge == 0
end

local function setupInfiniteGas()
	local Gas = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Gas
	local freehook;
	freehook = hookmetamethod(game, '__index', function(self, v)
		if self == Gas and v == "Value" and getgenv().InfiniteGas then
			return 2000
		end
		return freehook(self, v)
	end)
end

local function getClosestModel(player)
	local playerCharacter = player.Character
	if not playerCharacter or not playerCharacter.PrimaryPart then
		return nil
	end

	local closestModel = nil
	local shortestDistance = math.huge

	for _, model in pairs(workspace.OnGameTitans:GetChildren()) do
		if model:IsA("Model") and model.PrimaryPart then
			local distance = (model.PrimaryPart.Position - playerCharacter.PrimaryPart.Position).Magnitude

			if distance < shortestDistance then
				closestModel = model
				shortestDistance = distance
			end
		end
	end

	return closestModel
end

local function setupInfiniteBlades()
	local Blades = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Blades
	local metahook;
	metahook = hookmetamethod(game, '__index', function(self, v)
		if self == Blades and v == "Value" and getgenv().InfiniteBlades then
			return 8
		end
		return metahook(self, v)
	end)
end

local function setupTitandetection()
	local titanhook;
	titanhook = hookmetamethod(game, '__namecall', function(self, ...)
		local args = {...}
		local call_type = getnamecallmethod();
		if call_type == 'FireServer' and tostring(self) == 'TitanTouchedEvent' and getgenv().TitanDetection then 
			args[1] = workspace.Camera:WaitForChild("CameraPart")
			return titanhook(self, unpack(args))
		else
			return titanhook(self, ...)
		end
	end)
end

local function setupShifterStamina()
	local Stamina = Character:WaitForChild("Humanoid").Stamina
	local StamHook;
	StamHook = hookmetamethod(game,'__index',function(self,v)
		if self == Stamina and v == "Value" and getgenv().InfSStamina == true then
			return 2400
		end
		return StamHook(self,v)
	end)
end

local function toggleSkills(enable)
	for _, v in pairs(Player.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
		v.Enabled = enable
	end

	local gearSkills = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Skills
	gearSkills.Dodge.Value = enable
	gearSkills.Impulse.Value = enable
	gearSkills.HandCut.Value = enable
	gearSkills.HandCutMk2.Value = enable
	gearSkills.SuperJump.Value = enable
	gearSkills.BladeThrow.Value = enable
	gearSkills.Counter.Value = enable

	local gearUpgrades = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Upgrades
	if enable then
		gearUpgrades.AttackSpeed.Value = 0.2
		gearUpgrades.HooksRange.Value = 160
	end
end

local function toggleTitanDetector()
	local titanDetector = Character:FindFirstChild("TitanDetector")
	if titanDetector then
		titanDetector.Enabled = not getgenv().TitanDetection
	end
end

Cheats:AddToggle('Infinite Gas', {
	Text = 'Infinite Gas',
	Default = false,
	Callback = function(Value)
		getgenv().InfiniteGas = Value
		if getgenv().InfiniteGas then
			setupInfiniteGas()
			Player.CharacterAdded:Connect(function(character)
				Character = character
				setupInfiniteGas()
			end)
		end
	end
})

Cheats:AddToggle('Infinite Blades', {
	Text = 'Infinite Blades',
	Default = false,
	Callback = function(Value)
		getgenv().InfiniteBlades = Value
		if getgenv().InfiniteBlades then
			setupInfiniteBlades()
			Player.CharacterAdded:Connect(function(character)
				Character = character
				setupInfiniteBlades()
			end)
		end
	end
})

Cheats:AddToggle('Autoreload', {
	Text = 'Autoreload Blades',
	Default = false,
	Callback = function(Value)
		getgenv().Reload = Value
		while getgenv().Reload do
			task.wait(1)
			local humanoid = Character:FindFirstChild("Humanoid")
			if humanoid then
				local gear = humanoid:FindFirstChild("Gear")
				if gear then
					local bladeDurability = gear:FindFirstChild("BladeDurability")
					if bladeDurability and bladeDurability.Value == 0 then
						VirtualManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
						task.wait(0.1)
						VirtualManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
					end
				end
			end
		end
	end
})

Cheats:AddToggle('Titan Detection', {
	Text = 'No Titan Detection',
	Default = false,
	Callback = function(Value)
		getgenv().TitanDetection = Value
		toggleTitanDetector()
		if getgenv().TitanDetection then
			setupTitandetection()
		end
		Player.CharacterAdded:Connect(function(character)
			Character = character
			if getgenv().TitanDetection then
				setupTitandetection()
			end
			toggleTitanDetector()
		end)
	end
})

Cheats:AddToggle('Hood', {
	Text = 'Dont Lose Hood',
	Default = false,
	Tooltip = "you wont lose your hood if your damaged",
	Callback = function(Value)
		if getgenv().Hood == false then
			getgenv().Hood = true
			Player.PlayerGui.LowHealthGui.LoseHoodEvent:Destroy()
		elseif getgenv().Hood == true then
			getgenv().Hood = false
			local HoodRemote = Instance.new("RemoteEvent", Player.PlayerGui.LowHealthGui)
			HoodRemote.Name = "LoseHoodEvent"
		end
	end
})

Cheats:AddToggle('Skills', {
	Text = 'Unlock Skills',
	Default = false,
	Callback = function(Value)
		getgenv().Skills = Value
		toggleSkills(getgenv().Skills)

		if getgenv().Skills then
			while task.wait(1) and getgenv().Skills do
				local gearSkills = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Skills
				gearSkills.Dodge.Value = true
				gearSkills.Impulse.Value = true
				gearSkills.HandCut.Value = true
				gearSkills.HandCutMk2.Value = true
				gearSkills.SuperJump.Value = true
				gearSkills.BladeThrow.Value = true
				gearSkills.Counter.Value = true

				local gearUpgrades = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Upgrades
				gearUpgrades.AttackSpeed.Value = 0.2
				gearUpgrades.HooksRange.Value = 160
			end
		elseif getgenv().Skills then
			local gearSkills = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Skills
			gearSkills.Dodge.Value = false
			gearSkills.Impulse.Value = false
			gearSkills.HandCut.Value = false
			gearSkills.HandCutMk2.Value = false
			gearSkills.SuperJump.Value = false
			gearSkills.BladeThrow.Value = false
			gearSkills.Counter.Value = false
		end

		Player.CharacterAdded:Connect(function(character)
			Character = character
			toggleSkills(getgenv().Skills)

			if getgenv().Skills then
				while task.wait(1) and getgenv().Skills do
					local gearSkills = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Skills
					gearSkills.Dodge.Value = true
					gearSkills.Impulse.Value = true
					gearSkills.HandCut.Value = true
					gearSkills.HandCutMk2.Value = true
					gearSkills.SuperJump.Value = true
					gearSkills.BladeThrow.Value = true
					gearSkills.Counter.Value = true

					local gearUpgrades = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Upgrades
					gearUpgrades.AttackSpeed.Value = 0.2
					gearUpgrades.HooksRange.Value = 160
				end
			elseif getgenv().Skills then
				local gearSkills = Character:WaitForChild("Humanoid"):WaitForChild("Gear").Skills
				gearSkills.Dodge.Value = false
				gearSkills.Impulse.Value = false
				gearSkills.HandCut.Value = false
				gearSkills.HandCutMk2.Value = false
				gearSkills.SuperJump.Value = false
				gearSkills.BladeThrow.Value = false
				gearSkills.Counter.Value = false
			end
		end)
	end
})

Cheats:AddToggle('NoCooldown', {
	Text = 'No Cooldown',
	Default = false,
	Callback = function(Value)
		if getgenv().NoCooldown == false then
			getgenv().NoCooldown = true
			while task.wait() and getgenv().NoCooldown do
				local AP = Character:FindFirstChild("APGear")
				local Normal = Character:FindFirstChild("Gear")
				
				if AP then
					for _, Move in pairs(Character:WaitForChild("APGear").SkillsSpamLimit:GetChildren()) do
						Move.Value = -1
					end
				elseif Normal then
					for _, Move in pairs(Character:WaitForChild("Gear").SkillsSpamLimit:GetChildren()) do
						Move.Value = -1
					end
				end

				for _, Skill in pairs(Player.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
					if Skill.Name == "Impulse" then
						Skill.Cooldown.Value = 100
					elseif Skill.Name == "Dodge" then
						Skill.Cooldown.Value = 25
					elseif Skill.Name == "HandCut" then
						Skill.Cooldown.Value = 3000
					elseif Skill.Name == "HandCutMk2" then
						Skill.Cooldown.Value = 3000
					elseif Skill.Name == "SuperJump" then
						Skill.Cooldown.Value = 150
					elseif Skill.Name == "BladeThrow" then
						Skill.Cooldown.Value = 100
					elseif Skill.Name == "Counter" then
						Skill.Cooldown.Value = 2000
					end
				end
			end
		elseif getgenv().NoCooldown == true then
			getgenv().NoCooldown = false
		end
	end
})

Cheats:AddToggle('AntiHook', {
	Text = 'Anti Hook',
	Default = false,
	Callback = function(Value)
		if getgenv().AntiHook == false then
			getgenv().AntiHook = true
			while getgenv().AntiHook do
				if Character:FindFirstChild("Humanoid"):WaitForChild("Gear") then
					local args = {[1] = Character:WaitForChild("HumanoidRootPart")}
					Character:WaitForChild("Gear").Events.MoreEvents.CastQKey:FireServer(unpack(args))
					task.wait(0.2)
				end
			end
		elseif getgenv().AntiHook == true then
			getgenv().AntiHook = false
			local args = {[1] = nil}
			Character:WaitForChild("Gear").Events.MoreEvents.CastQKey:FireServer(unpack(args))
		end
	end
})

Cheats:AddDivider()

Cheats:AddToggle('MindlessNape', {
	Text = 'Titan Nape Hitbox',
	Default = false,
	Callback = function(Value)
		if getgenv().MindlessNapeHitbox == false then
			getgenv().MindlessNapeHitbox = true
		elseif getgenv().MindlessNapeHitbox == true then
			getgenv().MindlessNapeHitbox = false
			for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
				if Titan:FindFirstChild("Nape") then
					Titan.Nape.Size = Vector3.new(1.762, 1.481, 0.648)
					Titan.Nape.Transparency = 1
					Titan.Nape.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end
	end
})

Cheats:AddSlider('MindlessNapeSliderX', {
	Text = 'X',
	Default = 1.762,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('MindlessNapeSliderY', {
	Text = 'Y',
	Default = 1.481,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('MindlessNapeSliderZ', {
	Text = 'Z',
	Default = 0.648,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('TitanNapeTransparency', {
	Text = 'Transparency',
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddToggle('ShifterNape', {
	Text = 'Shifter Nape Hitbox',
	Default = false,
	Callback = function(Value)
		if getgenv().ShifterNapeHitbox == false then
			getgenv().ShifterNapeHitbox = true
		elseif getgenv().ShifterNapeHitbox == true then
			getgenv().ShifterNapeHitbox = false
			for _, TitanS in pairs(workspace:GetChildren()) do
				if TitanS:FindFirstChild("Shifter") and not (TitanS.Name == "ArmoredTitan") then
					if TitanS:FindFirstChild("SNape") then
						TitanS.SNape.Size = Vector3.new(1.762, 1.481, 0.648)
						TitanS.SNape.Transparency = 1
						TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
					end
				end
			end
		end
	end
})

Cheats:AddSlider('ShifterNapeSliderX', {
	Text = 'X',
	Default = 1.762,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('ShifterNapeSliderY', {
	Text = 'Y',
	Default = 1.481,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('ShifterNapeSliderZ', {
	Text = 'Z',
	Default = 0.648,
	Min = 0,
	Max = 50,
	Rounding = 2,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddSlider('ShifterNapeTransparency', {
	Text = 'Transparency',
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats:AddDivider()

Cheats:AddButton({
	Text = 'God Mode',
	Func = function()
		local args = {
			[1] = -math.huge
		}

		workspace:WaitForChild("HumanEvents"):WaitForChild("DamageEvent"):FireServer(unpack(args))
	end,
	DoubleClick = false,
})

Cheats:AddButton({
	Text = 'Reset God Mode',
	Func = function()
		if Player.Backpack:FindFirstChild("Granada") then
			Player.Backpack:FindFirstChild("Granada").Eat:FireServer()
		elseif not Player.Backpack:FindFirstChild("Granada") then
			local Granada = game:GetService("ReplicatedStorage").BuyEvent:FireServer('Granada',100)

			repeat task.wait() until Player.Backpack:FindFirstChild("Granada")

			Player.Backpack:WaitForChild('Granada').Eat:FireServer()
		end
	end,
	DoubleClick = false,
})

Cheats:AddButton({
	Text = 'Spoof Death',
	Tooltip = 'only use if your spawned in, this makes you look like your dead on the leaderboard',
	Func = function()
		local args = {
			[1] = -math.huge
		}

		workspace:WaitForChild("HumanEvents"):WaitForChild("DamageEvent"):FireServer(unpack(args))
		task.wait(0.5)
		local args = {
			[1] = math.huge
		}

		workspace:WaitForChild("HumanEvents"):WaitForChild("DamageEvent"):FireServer(unpack(args))
	end,
	DoubleClick = false,
})

Cheats:AddLabel('Regenerate Health'):AddKeyPicker('KeyPicker', {
	Default = 'U',
	SyncToggleState = false,

	Mode = 'Toggle',

	Text = '',
	NoUI = false,

	Callback = function(Value)
		local maxHealth = Character.Humanoid.MaxHealth
		local currentHealth = Character.Humanoid.Health
		local healthToAdd = maxHealth - currentHealth
		local damage = -healthToAdd
		local damageTable = {[1] = damage}

		workspace:WaitForChild("HumanEvents").DamageEvent:FireServer(unpack(damageTable))
	end,

	ChangedCallback = function(New)

	end
})

Cheats:AddLabel('+100 Health'):AddKeyPicker('KeyPicker', {
	Default = 'Six',
	SyncToggleState = false,

	Mode = 'Toggle',

	Text = '',
	NoUI = false,

	Callback = function(Value)
		local args = {
			[1] = -100
		}

		workspace:WaitForChild("HumanEvents"):WaitForChild("DamageEvent"):FireServer(unpack(args))
	end,

	ChangedCallback = function(New)

	end
})

Cheats2:AddButton({
	Text = 'Rejoin Same Server',
	Func = function()
		TeleportService:Teleport(game.PlaceId, Player, game.JobId)
	end,
	DoubleClick = false,
})

--[[Cheats2:AddButton({
	Text = 'Join Stage',
	Tooltip = 'WIP ( DO NOT USE )',
	Func = function()
		local function Spawnpoint()
			if workspace:FindFirstChild("GameStateValues").Stage.Value == 1 then
				return workspace:WaitForChild("Shiganshina").Castle["LC-HQ"].Model.BigDetailedDoor
			elseif workspace:FindFirstChild("GameStateValues").Stage.Value == 2 then
				return workspace.Shiganshina.Castle["LC-HQ"].Model:GetChildren()[158].Nails
			elseif workspace:FindFirstChild("GameStateValues").Stage.Value == 3 then
				return workspace.Trost.Castle["MC-HQ"].Model:GetChildren()[61].Nails
			end
		end
		
		workspace.Camera.CameraType = Enum.CameraType.Custom
		
		for _, UI in pairs(Player.PlayerGui:WaitForChild("LobbyGui").LobbyScreen:GetChildren()) do
			UI.Visible = false
		end
		
		Player.PlayerGui:WaitForChild("Status").Bottom.Visible = false
		
		local args = {
			[1] = Spawnpoint()
		}

		game:GetService("ReplicatedStorage"):WaitForChild("ServerTeleportFunction"):InvokeServer(unpack(args))
	end,
	DoubleClick = false,
})]]

Cheats2:AddButton({
	Text = 'Unlock Emotes',
	Func = function()
		workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmPushUp.Value = 1
		workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmHandstandPushUp.Value = 1
		workspace.PlayersDataFolder:FindFirstChild(Player.Name).NoArmsPushUp.Value = 1
		workspace.PlayersDataFolder:FindFirstChild(Player.Name).HandstandPushUp.Value = 1
	end,
	DoubleClick = false,
})


Cheats2:AddButton({
	Text = 'Notify Warriors',
	Tooltip = 'tells you who are the warriors',
	Func = function()
		local Female = nil
		local Armored = nil
		local Colossal = nil

		for _, Object in pairs(game:GetDescendants()) do
			if Object.Name == "FELocal" then
				local Character = Object.Parent
				local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
				Female = tostring("Female: " .. Player.Name)
			end

			if Object.Name == "ARLocal" then
				local Character = Object.Parent
				local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
				Armored = tostring("Armored: " .. Player.Name)
			end

			if Object.Name == "COLocal" then
				local Character = Object.Parent
				local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
				Colossal = tostring("Colossal: " .. Player.Name)
			end
		end

		if Female then
			Library:Notify(Female)
		end
		if Armored then
			Library:Notify(Armored)
		end
		if Colossal then
			Library:Notify(Colossal)
		end
	end,
	DoubleClick = false,
})

Cheats2:AddButton({
	Text = 'Gas Remover',
	Tooltip = 'click this then go to a cart and the cart will have no more gas ( also turn off inf gas )',
	Func = function()
		Character:WaitForChild("Humanoid"):WaitForChild("Gear").Gas.Value = -100000
	end,
	DoubleClick = false,
})

Cheats2:AddToggle('Clothes', {
	Text = 'Remove Clothes',
	Default = false,
	Tooltip = "just removes some of your gear on your body",
	Callback = function(Value)
		if getgenv().Clothes == false then
			getgenv().Clothes = true
			local args = {
				[1] = "Choosing"
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
		elseif getgenv().Clothes == true then
			getgenv().Clothes = false
			local args = {
				[1] = "Soldiers"
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
		end
	end
})

Cheats2:AddDivider()

Cheats2:AddToggle('DamageSpoofer', {
	Text = 'Spoof Damage',
	Default = false,
	Callback = function(Value)
		if getgenv().DamageSpoof == false then
			getgenv().DamageSpoof = true
		elseif getgenv().DamageSpoof == true then
			getgenv().DamageSpoof = false
		end
	end
})

Cheats2:AddSlider('DamageSlider', {
	Text = 'Damage',
	Default = 670,
	Min = 0,
	Max = 1170,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats2:AddButton({
	Text = 'Kill Titan',
	Tooltip = 'click this if your grabbed to kill the titan',
	Func = function()
		local ClosestTitan = getClosestModel(Player)
		if Character:WaitForChild("Humanoid").Grabbed == true then 
			print(ClosestTitan.Name)
			if IsNetworkOwner(ClosestTitan:FindFirstChild("HumanoidRootPart")) then
				print(ClosestTitan.Name)
				ClosestTitan:WaitForChild("Humanoid").Health = 0
			end
		end
	end,
	DoubleClick = false,
})

Cheats2:AddDivider()

Cheats2:AddToggle('InfSStamina', {
	Text = 'Infinite Shifter Stamina',
	Default = false,
	Callback = function(Value)
		getgenv().InfSStamina = Value
		if getgenv().InfSStamina then
			setupShifterStamina()
			Player.CharacterAdded:Connect(function(character)
				Character = character
				setupShifterStamina()
			end)
		end
	end
})

Cheats2:AddToggle('NoCDShifter', {
	Text = 'Shifter No Cooldown',
	Default = false,
	Tooltip = "only works for heavyattack, recovery ( fem ), & roar",
	Callback = function(Value)
		if getgenv().ShifterNoCooldown == false then
			getgenv().ShifterNoCooldown = true
			if Character:FindFirstChild("Shifter") then
				while task.wait() and getgenv().ShifterNoCooldown do
					for _, Move in pairs(Player.PlayerGui:WaitForChild("ShiftersGui"):GetDescendants()) do
						if Move.Name == "HeavyAttack" then
							Move.Cooldown.Value = 300
						elseif Move.Name == "Roar" then
							Move.Cooldown.Value = 500
						elseif Move.Name == "HighSpeed" then
							Move.Cooldown.Value = 1000
						elseif Move.Name == "Charge" then
							Move.Cooldown.Value = 100
						end
					end
				end
			end
		elseif getgenv().ShifterNoCooldown == true then
			getgenv().ShifterNoCooldown = false
		end
	end
})

Cheats2:AddToggle('InfiniteTime', {
	Text = 'Infinite Timer',
	Default = false,
	Callback = function(Value)
		if getgenv().Timer == false then
			getgenv().Timer = true
			for _, Object in pairs(Character:GetDescendants()) do
				if Object:IsA("IntValue") and Object.Name == "Time" then
					Object:Destroy()
				end
			end
		elseif getgenv().Timer == true then
			getgenv().Timer = false
			for _, Object in pairs(Character:GetDescendants()) do
				if Object:IsA("LocalScript") and string.find(Object.Name, "Local") then
					local TimeValue = Instance.new("IntValue")
					local BuffedValue = Instance.new("BoolValue")
					TimeValue.Name = "Time"
					TimeValue.Value = 0
					TimeValue.Parent = Object:WaitForChild("Stats")
					BuffedValue.Parent = TimeValue
					BuffedValue.Name = "Buffed"
				end
			end
		end
	end
})


Cheats2:AddDivider()

Cheats2:AddToggle('Speed', {
	Text = 'Human Speed',
	Default = false,
	Callback = function(Value)
		if getgenv().HumanSpeed == false then
			getgenv().HumanSpeed = true
		elseif getgenv().HumanSpeed == true then
			getgenv().HumanSpeed = false
		end
	end
})

Cheats2:AddSlider('SpeedSlider', {
	Text = 'Speed',
	Default = 16,
	Min = 16,
	Max = 200,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)
		getgenv().Speed = Value
	end
})

--[[ESP1:AddToggle('PlrESP', {
	Text = 'Player ESP',
	Default = false,
	Callback = function(Value)
		if getgenv().PlrESP == false then
			getgenv().PlrESP = true
			Sense.teamSettings.enemy.enabled = true
			Sense.teamSettings.enemy.box = false
			Sense.teamSettings.enemy.boxFill = false
			Sense.teamSettings.enemy.name = true
			Sense.teamSettings.enemy.nameOutline = true
			Sense.teamSettings.enemy.distance = true
			Sense.teamSettings.enemy.nameColor = { Color3.new(0.666667, 0, 0), 1 }
			Sense.teamSettings.enemy.distanceColor = { Color3.new(0.666667, 0, 0), 1 }
			Sense.teamSettings.friendly.enabled = true
			Sense.teamSettings.friendly.box = false
			Sense.teamSettings.friendly.boxFill = false
			Sense.teamSettings.friendly.name = true
			Sense.teamSettings.friendly.nameOutline = true
			Sense.teamSettings.friendly.distance = true
			Sense.teamSettings.friendly.nameColor = { Color3.new(0.431373, 0.866667, 0.643137), 1 }
			Sense.teamSettings.friendly.distanceColor = { Color3.new(0.431373, 0.866667, 0.643137), 1 }
			Sense.sharedSettings.maxDistance = getgenv().espdistance
			Sense.sharedSettings.limitDistance = false
			Sense.Load()
		elseif getgenv().PlrESP == true then
			getgenv().PlrESP = false
			Sense.Unload()
		end
	end
})]]


--[[ESP1:AddSlider('DistanceSlider', {
	Text = 'Max Distance',
	Default = 1000,
	Min = 0,
	Max = 10000,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)

	end
})]]--

local damage = Options.DamageSlider.Value
--getgenv().espdistance = Options.DistanceSlider.Value

local napex = Options.MindlessNapeSliderX.Value
local napey = Options.MindlessNapeSliderY.Value
local napez = Options.MindlessNapeSliderZ.Value

local shifterx = Options.ShifterNapeSliderX.Value
local shiftery = Options.ShifterNapeSliderY.Value
local shifterz = Options.ShifterNapeSliderZ.Value

local napetransparency = Options.TitanNapeTransparency.Value
local shiftertransparency = Options.ShifterNapeTransparency.Value

Options.DamageSlider:OnChanged(function()
	damage = Options.DamageSlider.Value
end)

--[[Options.DistanceSlider:OnChanged(function()
	espdistance = Options.DistanceSlider.Value
end)]]

Options.MindlessNapeSliderX:OnChanged(function()
	napex = Options.MindlessNapeSliderX.Value
end)

Options.MindlessNapeSliderY:OnChanged(function()
	napey = Options.MindlessNapeSliderY.Value
end)

Options.MindlessNapeSliderZ:OnChanged(function()
	napez = Options.MindlessNapeSliderZ.Value
end)

Options.TitanNapeTransparency:OnChanged(function()
	napetransparency = Options.TitanNapeTransparency.Value
end)

--// shifter

Options.ShifterNapeSliderX:OnChanged(function()
	shifterx = Options.ShifterNapeSliderX.Value
end)

Options.ShifterNapeSliderY:OnChanged(function()
	shiftery = Options.ShifterNapeSliderY.Value
end)

Options.ShifterNapeSliderZ:OnChanged(function()
	shifterz = Options.ShifterNapeSliderZ.Value
end)

Options.ShifterNapeTransparency:OnChanged(function()
	shiftertransparency = Options.ShifterNapeTransparency.Value
end)

local hhook;
hhook = hookmetamethod(game, '__namecall', function(self, ...)
	local args = {...}
	local call_type = getnamecallmethod();
	if call_type == 'FireServer' and tostring(self) == 'HitEvent' and getgenv().DamageSpoof then 
		args[2] = damage
		return hhook(self, unpack(args))
	else
		return hhook(self, ...)
	end
end)

RunService.RenderStepped:Connect(function()
	if getgenv().MindlessNapeHitbox then
		for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
			if Titan:FindFirstChild("Nape") then
				Titan.Nape.Size = Vector3.new(napex, napey, napez)
				Titan.Nape.Transparency = napetransparency
				Titan.Nape.BrickColor = BrickColor.new("Institutional white")
			end
		end
	end
	
	if getgenv().HumanSpeed and not Character:FindFirstChild("Shifter") then
		Character:WaitForChild("Humanoid").WalkSpeed = getgenv().Speed
	elseif getgenv().HumanSpeed == false and not Character:FindFirstChild("Shifter") then
		Character:WaitForChild("Humanoid").WalkSpeed = 16
	end

	if getgenv().ShifterNapeHitbox then
		for _, TitanS in pairs(workspace:GetChildren()) do
			if TitanS:FindFirstChild("Shifter") and not (TitanS.Name == "ArmoredTitan") then
				if TitanS:FindFirstChild("SNape") then
					TitanS.SNape.Size = Vector3.new(shifterx, shiftery, shifterz)
					TitanS.SNape.Transparency = shiftertransparency
					TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end
	end
end)

Library:SetWatermarkVisibility(false)

Library.KeybindFrame.Visible = false;

Library:OnUnload(function()
	Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'KeypadEight', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

SaveManager:SetFolder('Tear/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
