local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/ESP.lua"))()

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(New)
	Character = New
end)

local function toggleTitanDetector()
	if not Character:FindFirstChild("Shifter") then
		local titanDetector = Character:WaitForChild("TitanDetector")
		if titanDetector then
			titanDetector.Enabled = not getgenv().titandetection
		end
	end
end

Player.CharacterAdded:Connect(function()
	toggleTitanDetector()
end)

getgenv().InfiniteGas = false
getgenv().InfiniteBlades = false
getgenv().Autoreload = false
getgenv().titandetection = false
getgenv().InfiniteHookTime = false
getgenv().Skills = false
getgenv().SpecialSkills = false
getgenv().Cooldown = false
getgenv().HookPlayer = false
getgenv().AntiHook = false
getgenv().AHSpeed = false
getgenv().MindlessNapeHitbox = false
getgenv().ShifterNapeHitbox = false
getgenv().MindlessLegHitbox = false
getgenv().ShifterLegHitbox = false
getgenv().InfStamina = false
getgenv().DamageSpoof = false
getgenv().NoGear = false
getgenv().hood = false
getgenv().fire = false
getgenv().ESP = false
getgenv().HumanHitbox = false
getgenv().soldieresp = false
getgenv().warrioreesp = false
getgenv().interior = false

local currentAnimationTracks = {}

local function Animate(ID)
	local Animation = Instance.new("Animation")
	Animation.AnimationId = 'rbxassetid://' .. ID
	local humanoid = Character:WaitForChild("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if animator then
		local loadedAnimation = animator:LoadAnimation(Animation)
		loadedAnimation:Play()
	end
end

local function toggleSkills(enable)
	if not Character:FindFirstChild("Shifter") then
		for _, v in pairs(Player.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
			v.Enabled = enable
		end
	end

	if Character:FindFirstChild("Shifter") then
		for _, v in pairs(Player.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
			v.Enabled = false
		end
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
		if gearUpgrades:FindFirstChild("HooksRange") then
			gearUpgrades.HooksRange.Value = 160
		end
	end
end

local Animations = {
	["Dophin Dance"] = 5918726674,
	["Applaud"] = 5915693819,
	["Country Line  Dance"] = 5915712534,
	["Floss  Dance"] = 5917459365,
	["Panini Dance"] = 5915713518,
	["Rock On"] = 5915714366,
	["Rodeo Dance"] = 5918728267,
	["Break Dance"] = 5915648917,
	["Fashionable"] = 3333331310,
	["Robot"] = 3338025566,
	["Twirl"] = 3334968680,
	["Idol"] = 4101966434,
	["Haha"] = 3337966527,
	["Salute"] = 3333474484,
	["Hello"] = 3344650532,
	["Shrug"] = 3334392772,
	["Point2"] = 3344585679,
	["Tilt"] = 3334538554,
	["Pushups"] = 17124634317,
	["Crawler"] = 6807728809,
	["Hype"] = 3695333486,
	["Spinner"] = 7921684457,
	["Jaw Walk"] = 7018026891,
}

local Window = Fluent:CreateWindow({
	Title = "Tear - " .. game.PlaceId,
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main = Window:AddTab({ Title = "Human", Icon = "" }),
	Third = Window:AddTab({ Title = "Shifter", Icon = "" }),
	Secondary = Window:AddTab({ Title = "Hitboxes", Icon = "" }),
	Fifth = Window:AddTab({ Title = "ESP", Icon = "" }),
	Fourth = Window:AddTab({ Title = "Animations", Icon = "" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local Options = Fluent.Options

do
	local GasBool = Tabs.Main:AddToggle("InfiniteGas", {Title = "Infinite Gas", Default = false })
	local BladesBool = Tabs.Main:AddToggle("InfiniteBlades", {Title = "Infinite Blades", Default = false })
	local AutoreloadBool = Tabs.Main:AddToggle("Autoreload", {Title = "Autoreload Blades", Default = false })
	local TitanDetectionBool = Tabs.Main:AddToggle("Titandetection", {Title = "Disable Titan Detection", Default = false })
	local HookTimeBool = Tabs.Main:AddToggle("Hooktime", {Title = "Infinite Hook Time", Default = false })
	local UnlockSkillsBool = Tabs.Main:AddToggle("UnlockSkill", {Title = "Unlock Skills", Default = false, })
	local HoodBool = Tabs.Main:AddToggle("Hood", {Title = "Dont Lose Hood", Default = false, Description = "☉ if your damaged you wont lose your hood" })
	local FireBool = Tabs.Main:AddToggle("Fire", {Title = "Anti-Burn", Default = false, })
	local NoCooldownBool = Tabs.Main:AddToggle("Nocooldown", {Title = "No Cooldown", Default = false })
	local AntiHookBool = Tabs.Main:AddToggle("antihook", {Title = "Anti Hook", Default = false, })
	local HookPlayerBool = Tabs.Main:AddToggle("antihook2", {Title = "Legit Anti Hook", Default = false, Description = "☉ when you hook a player itll unhook them" })
	local AntiHookSlider = Tabs.Main:AddSlider("Slider9", {
		Title = "Anti Hook Speed",
		Description = "☉ Configure how fast someone is unhooked off you 1 = Slowest, move up for AntiHook to be faster",
		Default = 1,
		Min = 1,
		Max = 4,
		Rounding = 0,
		Callback = function(Value)

		end
	})
	--[[local DamageSpoof = Tabs.Secondary:AddToggle("damage", {Title = "Damage Spoof", Default = false, Description = "☉ only works on titans | BUGGY" })
	local Slider7 = Tabs.Secondary:AddSlider("Slider7", {
		Title = "Damage",
		Default = 670,
		Min = 0,
		Max = 1170,
		Rounding = 1,
		Callback = function(Value)

		end
	})]]

	local MindlessHitbox = Tabs.Secondary:AddToggle("mindless", {Title = "Mindless Nape Hitbox", Default = false })
	MindlessHitbox:OnChanged(function()
		getgenv().MindlessNapeHitbox = Options.mindless.Value
		if getgenv().MindlessNapeHitbox == false then
			for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
				if Titan:FindFirstChild("Nape") then
					Titan.Nape.Size = Vector3.new(1.762, 1.481, 0.648)
					Titan.Nape.Transparency = 1
					Titan.Nape.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end
	end)
	local Slider1 = Tabs.Secondary:AddSlider("Slider1", {
		Title = "X",
		Default = 1.762,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Slider2 = Tabs.Secondary:AddSlider("Slider2", {
		Title = "Y",
		Default = 1.481,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Slider3 = Tabs.Secondary:AddSlider("Slider3", {
		Title = "Z",
		Default = 0.648,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Trans1 = Tabs.Secondary:AddSlider("Trans1", {
		Title = "Tranparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local MindlessLegHitbox = Tabs.Secondary:AddToggle("mindlessleg", {Title = "Mindless Leg Hitbox", Default = false })
	MindlessLegHitbox:OnChanged(function()
		getgenv().MindlessLegHitbox = Options.mindlessleg.Value
		if getgenv().MindlessLegHitbox == false then
			for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
				if Titan:FindFirstChild("TendonsLeft") and Titan:FindFirstChild("TendonsRight") then
					Titan.TendonsLeft.Size = Vector3.new(2.865738868713379, 3.403064727783203, 1.9776231050491333)
					Titan.TendonsLeft.Transparency = 1
					Titan.TendonsLeft.BrickColor = BrickColor.new("Institutional white")
					Titan.TendonsRight.Size = Vector3.new(2.865738868713379, 3.403064727783203, 1.9776231050491333)
					Titan.TendonsRight.Transparency = 1
					Titan.TendonsRight.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end
	end)
	local Leg1 = Tabs.Secondary:AddSlider("Leg1", {
		Title = "X",
		Default = 2.866,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Leg2 = Tabs.Secondary:AddSlider("Leg2", {
		Title = "Y",
		Default = 3.403,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Leg3 = Tabs.Secondary:AddSlider("Leg3", {
		Title = "Z",
		Default = 1.978,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Trans3 = Tabs.Secondary:AddSlider("Trans3", {
		Title = "Tranparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	Tabs.Secondary:AddParagraph({
		Title = "_______________________________________________________________",
	})
	local ShifterHitbox = Tabs.Secondary:AddToggle("shifter", {Title = "Shifter Nape Hitbox", Default = false })
	ShifterHitbox:OnChanged(function()
		getgenv().ShifterNapeHitbox = Options.shifter.Value
		if getgenv().ShifterNapeHitbox == false then
			for _, TitanS in pairs(workspace:GetChildren()) do
				local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
				if ShifterPlr and ShifterPlr.Team ~= Player.Team then
					if TitanS:FindFirstChild("Shifter") and not (TitanS.Name == "ArmoredTitan") and TitanS ~= Character then
						if TitanS:FindFirstChild("SNape") then
							TitanS.SNape.Size = Vector3.new(1.762, 1.481, 0.648)
							TitanS.SNape.Transparency = 1
							TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
						end
					end
				end
			end
		end
	end)
	local Slider4 = Tabs.Secondary:AddSlider("Slider4", {
		Title = "X",
		Default = 1.762,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Slider5 = Tabs.Secondary:AddSlider("Slider5", {
		Title = "Y",
		Default = 1.481,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Slider6 = Tabs.Secondary:AddSlider("Slider6", {
		Title = "Z",
		Default = 0.648,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Trans2 = Tabs.Secondary:AddSlider("Trans2", {
		Title = "Tranparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local ShifterLegHitbox = Tabs.Secondary:AddToggle("shifterleg", {Title = "Shifter Leg Hitbox", Default = false })
	ShifterLegHitbox:OnChanged(function()
		getgenv().ShifterLegHitbox = Options.shifterleg.Value
		if getgenv().ShifterLegHitbox == false then
			for _, TitanS in pairs(workspace:GetChildren()) do
				local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
				if ShifterPlr and ShifterPlr.Team ~= Player.Team then
					if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
						if TitanS:FindFirstChild("RLegTendons") and TitanS:FindFirstChild("LLegTendons") then
							local LLegTendons = TitanS:FindFirstChild("LLegTendons")
							if not (TitanS.Name == "ArmoredTitan" and LLegTendons:FindFirstChild("Armored") and LLegTendons:WaitForChild("Armored").Value == true) then
								TitanS.RLegTendons.Size = Vector3.new(3.469383478164673, 3.469383478164673, 2.4444448947906494)
								TitanS.RLegTendons.Transparency = 1
								TitanS.RLegTendons.BrickColor = BrickColor.new("Institutional white")
								TitanS.LLegTendons.Size = Vector3.new(3.469383478164673, 3.469383478164673, 2.4444448947906494)
								TitanS.LLegTendons.Transparency = 1
								TitanS.LLegTendons.BrickColor = BrickColor.new("Institutional white")
							end
						end
					end
				end
			end
		end
	end)
	local Leg4 = Tabs.Secondary:AddSlider("Leg4", {
		Title = "X",
		Default = 3.469,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Leg5 = Tabs.Secondary:AddSlider("Leg5", {
		Title = "Y",
		Default = 3.469,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Leg6 = Tabs.Secondary:AddSlider("Leg6", {
		Title = "Z",
		Default = 2.444,
		Min = 0,
		Max = 30,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local Trans4 = Tabs.Secondary:AddSlider("Trans4", {
		Title = "Tranparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local HumanHitbox = Tabs.Secondary:AddToggle("Human", {Title = "Human Hitbox", Default = false })
	HumanHitbox:OnChanged(function()
		getgenv().HumanHitbox = Options.Human.Value
		if getgenv().HumanHitbox == false then
			for _, Victim in pairs(game:GetService("Players"):GetPlayers()) do
				if Victim.Character and not Victim.Character:FindFirstChild("Shifter") then
					local Hitbox = Victim.Character:WaitForChild("HumanoidRootPart"):WaitForChild("BulletsHitbox")
					if Hitbox then
						Hitbox.Size = Vector3.new(3, 3, 2)
						Hitbox.Transparency = 1
						Hitbox.BrickColor = BrickColor.new("Institutional white")
						Hitbox.Shape = Enum.PartType.Block
					end
				end
			end
		end
	end)
	local HumanSize = Tabs.Secondary:AddSlider("Size", {
		Title = "Size",
		Default = 3,
		Min = 3,
		Max = 10,
		Rounding = 1,
		Callback = function(Value)

		end
	})
	local HumanTrans = Tabs.Secondary:AddSlider("Size2", {
		Title = "Transparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Callback = function(Value)

		end
	})

	local napex = Options.Slider1.Value
	local napey = Options.Slider2.Value
	local napez = Options.Slider3.Value
	local trans1 = Options.Trans1.Value

	local legx = Options.Leg1.Value
	local legy = Options.Leg2.Value
	local legz = Options.Leg3.Value
	local trans3 = Options.Trans3.Value

	local shifterx = Options.Slider4.Value
	local shiftery = Options.Slider5.Value
	local shifterz = Options.Slider6.Value
	local trans2 = Options.Trans2.Value

	local shifterlegx = Options.Leg4.Value
	local shifterlegy = Options.Leg5.Value
	local shifterlegz = Options.Leg6.Value
	local trans4 = Options.Trans4.Value
	
	local humanhitbox = Options.Size.Value
	local humantrans = Options.Size2.Value

	--local dmg = Options.Slider7.Value
	--local hooks = Options.Slider8.Value
	local ahspeed = Options.Slider9.Value

	Slider1:OnChanged(function(Value)
		napex = Options.Slider1.Value
	end)
	Slider2:OnChanged(function(Value)
		napey = Options.Slider2.Value
	end)
	Slider3:OnChanged(function(Value)
		napez = Options.Slider3.Value
	end)
	Trans1:OnChanged(function(Value)
		trans1 = Options.Trans1.Value
	end)
	Slider4:OnChanged(function(Value)
		shifterx = Options.Slider4.Value
	end)
	Slider5:OnChanged(function(Value)
		shiftery = Options.Slider5.Value
	end)
	Slider6:OnChanged(function(Value)
		shifterz = Options.Slider6.Value
	end)
	Trans2:OnChanged(function(Value)
		trans2 = Options.Trans2.Value
	end)
	--[[Slider7:OnChanged(function(Value)
		dmg = Options.Slider7.Value
	end)]]
	--[[HookSlider:OnChanged(function(Value)
		hooks = Options.Slider8.Value
	end)]]

	Leg1:OnChanged(function(Value)
		legx = Options.Leg1.Value
	end)
	Leg2:OnChanged(function(Value)
		legy = Options.Leg2.Value
	end)
	Leg3:OnChanged(function(Value)
		legz = Options.Leg3.Value
	end)
	Trans3:OnChanged(function(Value)
		trans3 = Options.Trans3.Value
	end)
	Leg4:OnChanged(function(Value)
		shifterlegx = Options.Leg4.Value
	end)
	Leg5:OnChanged(function(Value)
		shifterlegy = Options.Leg5.Value
	end)
	Leg6:OnChanged(function(Value)
		shifterlegz = Options.Leg6.Value
	end)
	Trans4:OnChanged(function(Value)
		trans4 = Options.Trans4.Value
	end)
	
	HumanSize:OnChanged(function(Value)
		humanhitbox = Options.Size.Value
	end)
	HumanTrans:OnChanged(function(Value)
		humantrans = Options.Size2.Value
	end)

	AntiHookSlider:OnChanged(function(Value)
		ahspeed = Options.Slider9.Value
	end)

	local InfStaminaBool = Tabs.Third:AddToggle("infshiftstam", {Title = "Infinite Stamina", Default = false, Description = "☉ also gives you inf stamina as a human" })
	--local NoSCooldown = Tabs.Third:AddToggle("nocds", {Title = "No Cooldown", Default = false })
	local SpecialSkills = Tabs.Third:AddToggle("spskills", {Title = "Never Lose Special Skills", Default = false, Description = "☉ Hoard Roar, Berserk, if you reshift you get hoard roar back and every stage you get berserk back" })

	local NoGear = Tabs.Misc:AddToggle("gear", {Title = "No Gear", Default = false, Description = "☉ Removes some gear off your character" })

	Tabs.Misc:AddButton({
		Title = "Unlock Emotes",
		Callback = function()
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmHandstandPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).NoArmsPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).HandstandPushUp.Value = 1
		end
	})

	--[[local TeamDropdown = Tabs.Misc:AddDropdown("Team Change", {
		Title = "Change Team",
		Values = {"Soldiers", "Interior Police"},
		Multi = false,
		Default = "None",
	})

	TeamDropdown:OnChanged(function(Value)
		Player.PlayerGui:WaitForChild("LobbyGui").TeamSelectionEvent:FireServer(Value)
	end)
	
	Tabs.Misc:AddParagraph({
		Title = "Changable Teams",
		Content = "☉ Soldier: N/A\n☉ Interior Police: N/A"
	})]]

	Tabs.Misc:AddButton({
		Title = "Notify Warriors",
		Description = "☉ tells you the warriors",
		Callback = function()
			if game.PlaceId == 11564374799 then
				local Female = nil
				local Armored = nil
				local Colossal = nil

				for _, Plr in pairs(game:GetService("Players"):GetPlayers()) do
					if Plr.Character:FindFirstChild("FELocal") then
						Female = "Female: " .. Plr.Name
					end

					if Plr.Character:FindFirstChild("ARLocal") then
						Armored = "Armored: " .. Plr.Name
					end

					if Plr.Character:FindFirstChild("COLocal") then
						Colossal = "Colossal: " .. Plr.Name
					end
				end

				local function Content()
					local content = ""

					if Female then
						content = content .. Female .. "\n"
					end

					if Armored then
						content = content .. Armored .. "\n"
					end

					if Colossal then
						content = content .. Colossal .. "\n"
					end

					return content ~= "" and content or "No shifters found"
				end

				Fluent:Notify({
					Title = "Tear",
					Content = Content(),
					Duration = 8
				})
			else
				Fluent:Notify({
					Title = "Tear",
					Content = "Must be in campaign",
					Duration = 8
				})
			end
		end
	})

	Tabs.Misc:AddParagraph({
		Title = "_______________________________________________________________",
	})

	Tabs.Misc:AddButton({
		Title = "Rejoin Same Server",
		Callback = function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
		end
	})

	Tabs.Misc:AddButton({
		Title = "Serverhop",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
		end
	})

	--[[Tabs.Misc:AddButton({
		Title = "God Mode",
		Description = "if you eat a fruit itll reset your health back to normal",
		Callback = function()
			local args = {
				[1] = -math.huge
			}

			workspace:WaitForChild("HumanEvents"):WaitForChild("DamageEvent"):FireServer(unpack(args))
		end
	})]]

	NoGear:OnChanged(function()
		getgenv().NoGear = Options.gear.Value
		if getgenv().NoGear then
			local args = {
				[1] = "Choosing"
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
		else
			local args = {
				[1] = Player.Team.Name
			}

			game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
		end
	end)

	InfStaminaBool:OnChanged(function()
		getgenv().InfStamina = Options.infshiftstam.Value
		while getgenv().InfStamina do
			Character:WaitForChild("Humanoid").Stamina.Value = 2400
			task.wait(0.01)
		end
	end)

	--[[NoSCooldown:OnChanged(function()
		getgenv().NoSCooldown = Options.nocds.Value
		if Character:FindFirstChild("Shifter") then
			while task.wait() and getgenv().NoSCooldown do
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
	end)]]

	SpecialSkills:OnChanged(function()
		getgenv().SpecialSkills = Options.spskills.Value
		while getgenv().SpecialSkills do
			for _, Object in pairs(Player.PlayerGui:WaitForChild("ShiftersGui"):GetDescendants()) do
				if Object:IsA("NumberValue") then
					if Object.Parent.Name == "HordeRoar" then
						Object.Value = 100
					elseif Object.Parent.Name == "Berserker" then
						Object.Value = 100
					end
				end
			end
			task.wait(0.1)
		end
	end)

	--[[Tabs.Misc:AddButton({
		Title = "Enable Shifting",
		Description = "if it dosent allow you to shift press this to enable it",
		Callback = function()
			
		end
	})]]

	Tabs.Third:AddButton({
		Title = "Quick Uppercut",
		Description = "☉ Press 4 as a titan to do a uppercut without endlag",
		Callback = function()
			game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
				if input.UserInputType == Enum.UserInputType.Keyboard and not gpe then
					local args = {}

					if input.KeyCode == Enum.KeyCode.Four then
						args = {
							[1] = "AttackCombo3"
						}

						if Character.Name == "ArmoredTitan" then
							Character.ARLocal.Events.AttackEvent:FireServer(unpack(args))
						elseif Character.Name == "FemaleTitan" then
							Character.FELocal.Events.AttackEvent:FireServer(unpack(args))
						elseif Character.Name == "AttackTitan" then
							Character.ATLocal.Events.AttackEvent:FireServer(unpack(args))
						elseif Character.Name == "JawTitan" then
							Character.JALocal.Events.AttackEvent:FireServer(unpack(args))
						end
					end
				end
			end)
		end
	})

	GasBool:OnChanged(function()
		getgenv().InfiniteGas = Options.InfiniteGas.Value
	end)

	BladesBool:OnChanged(function()
		getgenv().InfiniteBlades = Options.InfiniteBlades.Value
		if getgenv().InfiniteBlades then
			while getgenv().InfiniteBlades do
				Character:WaitForChild("Humanoid"):WaitForChild("Gear"):WaitForChild("Blades").Value = 8
				task.wait(0.01)
			end
		end
	end)
	
	local reloading = false

	AutoreloadBool:OnChanged(function()
		getgenv().Reload = Options.Autoreload.Value
		while getgenv().Reload do
			task.wait(0.01)
			local humanoid = Character:FindFirstChild("Humanoid")
			if humanoid then
				local gear = humanoid:FindFirstChild("Gear")
				if gear then
					local bladeDurability = gear:FindFirstChild("BladeDurability")
					if bladeDurability then
						if bladeDurability.Value == 0 and not reloading then
							reloading = true
							game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
							task.wait(0.1)
							game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
						elseif bladeDurability.Value > 0 then
							reloading = false
						end
					end
				end
			end
		end
	end)

	UnlockSkillsBool:OnChanged(function()
		getgenv().Skills = Options.UnlockSkill.Value
		toggleSkills(getgenv().Skills)
		Player.CharacterAdded:Connect(function()
			toggleSkills(getgenv().Skills)
		end)
	end)

	HookTimeBool:OnChanged(function()
		getgenv().InfiniteHookTime = Options.Hooktime.Value
		while getgenv().InfiniteHookTime do
			if Character then
				local humanoid = Character:WaitForChild("Humanoid")
				if humanoid then
					local TensionR = Character:FindFirstChild("Humanoid"):FindFirstChild("Gear"):FindFirstChild("HookTensionR")
					local TensionL = Character:FindFirstChild("Humanoid"):FindFirstChild("Gear"):FindFirstChild("HookTensionL")

					if TensionR.Value >= 100 then
						TensionR.Value = 0
					end

					if TensionL.Value >= 100 then
						TensionL.Value = 0
					end
				end
			end
			task.wait(0.01)
		end
	end)

	AntiHookBool:OnChanged(function()
		getgenv().AntiHook = Options.antihook.Value
		if getgenv().AntiHook then
			if getgenv().PlayerHook then
				Options.antihook:SetValue(false)
				Fluent:Notify({
					Title = "Tear",
					Content = "Turn off Legit Anti Hook",
					Duration = 8
				})
				return
			end
			local debounce1 = false
			local maindebounce = false

			Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
				if getgenv().AntiHook then
					if (child.Name == "EAttachment" or child.Name == "QAttachment") then
						if not debounce1 then
							debounce1 = true
							if not maindebounce then
								maindebounce = true
								local args = {[1] = Character:WaitForChild("HumanoidRootPart")}
								if Character:FindFirstChild("APGear") then
									Character:WaitForChild("APGear").Events.MoreEvents.CastQKey:FireServer(unpack(args))
								else
									Character:WaitForChild("Gear").Events.MoreEvents.CastQKey:FireServer(unpack(args))
								end
								task.delay(0.05, function()
									maindebounce = false
								end)
							end
							task.wait(getgenv().AHSpeed)
							debounce1 = false
						else
							child:Destroy()
						end
					end
				end
			end)
		end
	end)
	
	local debounce = false

	HookPlayerBool:OnChanged(function()
		getgenv().PlayerHook = Options.antihook2.Value
		while getgenv().PlayerHook do
			if getgenv().AntiHook then
				Options.antihook2:SetValue(false)
				Fluent:Notify({
					Title = "Tear",
					Content = "Turn off Anti Hook",
					Duration = 8
				})
				return
			end
			task.wait(0.1)
			local HookL = Character:WaitForChild("Humanoid").Gear:FindFirstChild("HookTensionL").Value
			local HookR = Character:WaitForChild("Humanoid").Gear:FindFirstChild("HookTensionR").Value
			local args = {[1] = Character:WaitForChild("HumanoidRootPart")}
			local todoai = nil

			if HookL ~= HookR then
				if HookL < HookR then
					todoai = Character:WaitForChild("Gear").Events.MoreEvents.CastQKey
				elseif HookL > HookR then
					todoai = Character:WaitForChild("Gear").Events.MoreEvents.CastEKey
				end

				todoai:FireServer(unpack(args))
			end
			task.wait(getgenv().AHSpeed)
		end
	end)


	NoCooldownBool:OnChanged(function()
		getgenv().NoCooldown = Options.Nocooldown.Value
		while task.wait() and getgenv().NoCooldown do
			local AP = Character:FindFirstChild("APGear")
			local Normal = Character:FindFirstChild("Gear")

			if AP then
				for _, Move in pairs(Character:WaitForChild("APGear"):WaitForChild("SkillsSpamLimit"):GetChildren()) do
					Move.Value = -1
				end
			elseif Normal then
				for _, Move in pairs(Character:WaitForChild("Gear"):WaitForChild("SkillsSpamLimit"):GetChildren()) do
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
	end)

	HoodBool:OnChanged(function()
		getgenv().hood = Options.Hood.Value

		if getgenv().hood then
			Player.PlayerGui.LowHealthGui.LoseHoodEvent:Destroy()
		else
			local HoodRemote = Instance.new("RemoteEvent", Player.PlayerGui.LowHealthGui)
			HoodRemote.Name = "LoseHoodEvent"
		end
	end)
	
	FireBool:OnChanged(function()
		getgenv().fire = Options.Fire.Value

		if getgenv().fire then
			Character:WaitForChild("Humanoid").Burning:Destroy()
		else
			local BurnBool = Instance.new("BoolValue", Character:WaitForChild("Humanoid"))
			BurnBool.Name = "Burning"
		end
	end)

	Tabs.Fourth:AddButton({
		Title = "Stop Current Animation",
		Callback = function()
			for _, track in ipairs(currentAnimationTracks) do
				track:Stop()
			end
		end
	})

	local AnimSpeedSlider = Tabs.Fourth:AddSlider("Slider10", {
		Title = "Animation Speed",
		Description = "☉ changes the speed of your animation",
		Default = 1,
		Min = 1,
		Max = 10,
		Rounding = 1,
		Callback = function(Value)
			for _, track in ipairs(currentAnimationTracks) do
				track:AdjustSpeed(Value)
			end
		end
	})

	local anspeed = Options.Slider10.Value

	AnimSpeedSlider:OnChanged(function(Value)
		for _, track in ipairs(currentAnimationTracks) do
			track:AdjustSpeed(Value)
			anspeed = Value
		end
	end)

	Tabs.Fourth:AddParagraph({
		Title = "_______________________________________________________________",
	})

	for AnimationName, AnimationID in pairs(Animations) do
		Tabs.Fourth:AddButton({
			Title = AnimationName,
			Callback = function()
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					for _, track in ipairs(currentAnimationTracks) do
						track:Stop()
					end
					currentAnimationTracks = {}

					local animator = Humanoid:FindFirstChildOfClass("Animator")

					local animation = Instance.new("Animation")
					animation.AnimationId = "rbxassetid://" .. AnimationID

					local animationTrack = animator:LoadAnimation(animation)
					table.insert(currentAnimationTracks, animationTrack)
					animationTrack:Play()

					animationTrack:AdjustSpeed(anspeed)
				end
			end
		})
	end

	local ESPBool = Tabs.Fifth:AddToggle("ESP", {Title = "ESP", Default = false, })
	local SoldierBool = Tabs.Fifth:AddToggle("SoldierESP", {Title = "Soldiers", Default = false, })
	local WarriorBool = Tabs.Fifth:AddToggle("WarriorESP", {Title = "Warriors", Default = false, })
	local InteriorBool = Tabs.Fifth:AddToggle("InteriorESP", {Title = "Interior Police", Default = false, })
	ESPBool:OnChanged(function()
		ESP.Names = not ESP.Names
	end)
	SoldierBool:OnChanged(function()
		getgenv().soldieresp = Options.SoldierESP.Value
	end)
	WarriorBool:OnChanged(function()
		getgenv().warrioreesp = Options.WarriorESP.Value
	end)
	InteriorBool:OnChanged(function()
		getgenv().interior = Options.InteriorESP.Value
	end)
	ESPBool:OnChanged(function()
		getgenv().ESP = Options.ESP.Value
	end)

	TitanDetectionBool:OnChanged(function()
		getgenv().titandetection = Options.Titandetection.Value
		toggleTitanDetector()
	end)

	game:GetService("RunService").RenderStepped:Connect(function()
		if getgenv().MindlessNapeHitbox then
			for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
				if Titan:FindFirstChild("Nape") then
					Titan.Nape.Size = Vector3.new(napex, napey, napez)
					Titan.Nape.Transparency = trans1
					Titan.Nape.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end

		if getgenv().MindlessLegHitbox then
			for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
				if Titan:FindFirstChild("TendonsLeft") and Titan:FindFirstChild("TendonsRight") then
					Titan.TendonsLeft.Size = Vector3.new(legx, legy, legz)
					Titan.TendonsLeft.Transparency = trans3
					Titan.TendonsLeft.BrickColor = BrickColor.new("Institutional white")
					Titan.TendonsRight.Size = Vector3.new(legx, legy, legz)
					Titan.TendonsRight.Transparency = trans3
					Titan.TendonsRight.BrickColor = BrickColor.new("Institutional white")
				end
			end
		end
		
		if getgenv().HumanHitbox then
			local localPlayer = game:GetService("Players").LocalPlayer
			for _, Victim in pairs(game:GetService("Players"):GetPlayers()) do
				if Victim ~= localPlayer and Victim.Character and not Victim.Character:FindFirstChild("Shifter") then
					local Hitbox = Victim.Character:WaitForChild("HumanoidRootPart"):FindFirstChild("BulletsHitbox")
					if Hitbox then
						if Victim.Team.Name ~= localPlayer.Team.Name or localPlayer.Team.Name == "Rogue" or Victim.Team.Name == "Rogue" then
							Hitbox.Size = Vector3.new(humanhitbox, humanhitbox, humanhitbox)
							Hitbox.Transparency = humantrans
							Hitbox.BrickColor = BrickColor.new("Institutional white")
							Hitbox.Shape = Enum.PartType.Ball
						end
					end
				end
			end
		end

		if ahspeed == 1 then
			getgenv().AHSpeed = 0.5
		elseif ahspeed == 2 then
			getgenv().AHSpeed = 0.37
		elseif ahspeed == 3 then
			getgenv().AHSpeed = 0.25
		elseif ahspeed == 4 then
			getgenv().AHSpeed = 0.1
		end

		if getgenv().ShifterLegHitbox then
			for _, TitanS in pairs(workspace:GetChildren()) do
				if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
					local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
					local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
					if TitanS:FindFirstChild("RLegTendons") and TitanS:FindFirstChild("LLegTendons") then
						if not (TitanS.Name == "ArmoredTitan" and TitanS.LLegTendons:FindFirstChild("Armored") and TitanS.LLegTendons:WaitForChild("Armored").Value == true) then
							if Player.Team.Name ~= Team then
								TitanS.RLegTendons.Size = Vector3.new(shifterlegx, shifterlegy, shifterlegz)
								TitanS.RLegTendons.Transparency = trans4
								TitanS.RLegTendons.BrickColor = BrickColor.new("Institutional white")
								TitanS.LLegTendons.Size = Vector3.new(shifterlegx, shifterlegy, shifterlegz)
								TitanS.LLegTendons.Transparency = trans4
								TitanS.LLegTendons.BrickColor = BrickColor.new("Institutional white")
							end
						end
					end
				end
			end
		end

		--[[if not Character:FindFirstChild("Shifter") then
			local humanoid = Character:WaitForChild("Humanoid")
			local gear = humanoid:WaitForChild("Gear")
			local upgrades = gear:WaitForChild("Upgrades")
			local hooksRange = upgrades:FindFirstChild("HooksRange")

			if hooksRange then
				hooksRange.Value = hooks
			else
				return
			end
		end]]

		if getgenv().InfStamina then
			Character:WaitForChild("Humanoid").Stamina.Value = 2400
		end

		if getgenv().InfiniteGas then
			Character:WaitForChild("Humanoid"):WaitForChild("Gear"):WaitForChild("Gas").Value = 2000
		end

		if getgenv().ShifterNapeHitbox then
			for _, TitanS in pairs(workspace:GetChildren()) do
				if TitanS:FindFirstChild("Shifter") and TitanS ~= Character and not (TitanS.Name == "ArmoredTitan") then
					local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
					local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
					if Player.Team.Name ~= Team then
						if TitanS:FindFirstChild("SNape") then
							TitanS.SNape.Size = Vector3.new(shifterx, shiftery, shifterz)
							TitanS.SNape.Transparency = trans2
							TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
						end
					end
				end
			end
		end
	end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("Tear")
SaveManager:SetFolder("Tear/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
