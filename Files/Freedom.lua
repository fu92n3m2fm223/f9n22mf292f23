local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/refs/heads/main/Files/ESP.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

task.wait(0.7)

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(New)
	Character = New
end)

local Options = Fluent.Options

local function toggleTitanDetector()
	Character:WaitForChild("Humanoid"):WaitForChild("Invinsible").Value = Options.Titandetection.Value
end

local originalKick = hookfunction(Player.Kick, function()
	return nil
end)

local originalWarn = hookfunction(warn, function()
	return nil
end)

getgenv().InfiniteGas = false
getgenv().InfiniteBlades = false
getgenv().Autoreload = false
getgenv().titandetection = false
getgenv().InfiniteHookTime = false
getgenv().Skills = false
getgenv().Cooldown = false
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
getgenv().hoodkey = false
getgenv().soldieresp = false
getgenv().warrioreesp = false
getgenv().interior = false
getgenv().horsegod = false
getgenv().horsestam = false
getgenv().instanthook = false
getgenv().bladespam = false
getgenv().cannoncd = false
getgenv().noblind = false
getgenv().Stun = false
getgenv().autopickup = false
getgenv().staffnotify = false

local StaffList = {
	39716623, -- Administrator
	5052488353, -- Owner
	989251425, -- Head Staff
	3891230967, -- Developer
	923860344, -- Developer
	3349285656, -- Administrator
	563460081, -- Head Administrator
	2840164930, -- Moderator
	320954812, -- Administrator
	1218375944, -- Moderator
	291309580, -- Moderator
	1649580586, -- Moderator
	2664727049, -- Moderator
}

for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
	if table.find(StaffList, Player.UserId) then
		Fluent:Notify({
			Title = "Tear",
			Content = "Staff Member " .. Player.Name .. " is in this server",
			Duration = 8
		})
	end
end

local currentAnimationTracks = {}
local CartInstances = {}
local TitanInstances = {}

Player.CharacterAdded:Connect(function()
	if getgenv().NoGear then
		local args = {
			[1] = "Choosing"
		}

		game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
	end
	
	if getgenv().fire then
		Character:WaitForChild("Humanoid"):WaitForChild("Burning"):Destroy()
	end
	
	if getgenv().hood then
		Player:WaitForChild("PlayerGui"):WaitForChild("LowHealthGui").LoseHoodEvent:Destroy()
	end
end)

local function findLocalFunction(scriptName, functionName)
	for _, obj in pairs(getgc(true)) do
		if typeof(obj) == "function" and getfenv(obj).script == scriptName then
			if debug.getinfo(obj).name == functionName then
				return obj
			end
		end
	end
	return nil
end

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

local function findLocalScriptWithName(character, namePattern)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("LocalScript") and string.find(child.Name, namePattern) then
			return child
		end
	end
	return nil
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
	["Jaw Run"] = 7018026891,
	["Yoga"] = 7466046574,
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
	Main = Window:AddTab({ Title = "Human", Icon = "rbxassetid://10709752906" }),
	Third = Window:AddTab({ Title = "Shifter", Icon = "rbxassetid://10709805144" }),
	Secondary = Window:AddTab({ Title = "Hitboxes", Icon = "rbxassetid://10734953451" }),
	Sixth = Window:AddTab({ Title = "Horse", Icon = "rbxassetid://10709775704" }),
	Fifth = Window:AddTab({ Title = "ESP", Icon = "rbxassetid://10747384037" }),
	Fourth = Window:AddTab({ Title = "Animations", Icon = "rbxassetid://10709789686" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://10709782497" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

do
	local GasBool = Tabs.Main:AddToggle("InfiniteGas", {Title = "Infinite Gas", Default = false })
	local BladesBool = Tabs.Main:AddToggle("InfiniteBlades", {Title = "Infinite Blades", Default = false })
	local AutoreloadBool = Tabs.Main:AddToggle("Autoreload", {Title = "Autoreload Blades", Default = false })
	local TitanDetectionBool = Tabs.Main:AddToggle("Titandetection", {Title = "Disable Titan Detection", Default = false })
	local HookTimeBool = Tabs.Main:AddToggle("Hooktime", {Title = "Infinite Hook Time", Default = false })
	local UnlockSkillsBool = Tabs.Main:AddToggle("UnlockSkill", {Title = "Unlock Skills", Default = false, })
	local HoodBool = Tabs.Main:AddToggle("Hood", {Title = "Dont Lose Hood", Default = false, Description = "☉ if your damaged you wont lose your hood" })
	local HoodKeyBool = Tabs.Main:AddToggle("HoodKey", {Title = "Quick Hood", Default = false, Description = "☉ lets you quickly put on & take off your hood, you can change your keybind below" })
	local HoodKeybind
	HoodKeybind = Tabs.Main:AddKeybind("HoodKeybind", {
		Title = "Hood Keybind",
		Mode = "Toggle",
		Default = "LeftControl",
		Callback = function(Value)

		end,

		ChangedCallback = function(New)

		end
	})
	local FireBool = Tabs.Main:AddToggle("Fire", {Title = "Anti-Burn", Default = false, })
	local CannonBool = Tabs.Main:AddToggle("Cannon", {Title = "No Cooldown Cannon", Default = false, })
	local BladeSpamBool = Tabs.Main:AddToggle("BladeSpam", {Title = "Blade Throw Spam", Default = false, Description = "☉ You need rage mode activated for this" })
	--[[local HookSlider = Tabs.Main:AddSlider("Slider8", {
		Title = "Hooks Range",
		Default = 160,
		Min = 100,
		Max = 1000,
		Rounding = 0,
		Callback = function(Value)

		end
	})]]
	local InstantHookBool = Tabs.Main:AddToggle("InstantHook", {Title = "Instant Hook", Default = false })
	InstantHookKeybind = Tabs.Main:AddKeybind("InstantHookKey", {
		Title = "Instant Hook Keybind",
		Mode = "Toggle",
		Default = "LeftControl",
		Callback = function(Value)

		end,

		ChangedCallback = function(New)

		end
	})
	local NoCooldownBool = Tabs.Main:AddToggle("Nocooldown", {Title = "No Cooldown", Default = false })
	local TitanDmg = Tabs.Main:AddToggle("dmgslid", {Title = "Titan Damage", Default = false, Description = "☉ Allows you to constantly do the same damage to any titans you kill" })
	local TitanDmgSlider = Tabs.Main:AddSlider("TitanDmgSlid", {
		Title = "Damage",
		Default = 670,
		Min = 100,
		Max = 1170,
		Rounding = 0,
		Callback = function(Value)

		end
	})
	local AntiHookBool = Tabs.Main:AddToggle("antihook", {Title = "Anti Hook", Default = false })
	local AntiHookSlider = Tabs.Main:AddSlider("Slider9", {
		Title = "Anti Hook Speed",
		Description = "☉ Configure how fast someone is unhooked off you",
		Default = 1,
		Min = 1,
		Max = 4,
		Rounding = 0,
		Callback = function(Value)

		end
	})
	local PlayerSpeed = Tabs.Main:AddSlider("PlayerSpeed", {
		Title = "Speed",
		Default = 16,
		Min = 16,
		Max = 200,
		Rounding = 1,
		Callback = function(Value)
			if Character:FindFirstChild("Shifter") then
				return
			else
				Character:WaitForChild("Humanoid").WalkSpeed = Value
			end
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
	Tabs.Secondary:AddParagraph({
		Title = "_______________________________________________________________",
	})
	local HumanHitbox = Tabs.Secondary:AddToggle("Human", {Title = "Human Hitbox", Default = false })
	HumanHitbox:OnChanged(function()
		getgenv().HumanHitbox = Options.Human.Value
		if getgenv().HumanHitbox == false then
			for _, Victim in pairs(game:GetService("Players"):GetPlayers()) do
				if Victim.Character and not Victim.Character:FindFirstChild("Shifter") then
					local Hitbox = Victim.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("BulletsHitbox")
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
		Max = 20,
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

	local dmg = Options.TitanDmgSlid.Value
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
	TitanDmgSlider:OnChanged(function(Value)
		dmg = Options.TitanDmgSlid.Value
	end)
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
	local NoBlindBool = Tabs.Third:AddToggle("noblind", {Title = "No Blind", Default = false, Description = "☉ makes it so you wont go blind if your eyes are cut" })
	local StunBool = Tabs.Third:AddToggle("nostun", {Title = "No Stun", Default = false, })
	--local NoSCooldown = Tabs.Third:AddToggle("nocds", {Title = "No Cooldown", Default = false })
	--local SpecialSkills = Tabs.Third:AddToggle("spskills", {Title = "Never Lose Special Skills", Default = false, Description = "☉ Hoard Roar, Berserk, if you reshift you get hoard roar back and every stage you get berserk back" })

	local NoGear = Tabs.Misc:AddToggle("gear", {Title = "No Gear", Default = false, Description = "☉ Removes some gear off your character" })
	
	NoBlindBool:OnChanged(function(Value)
		getgenv().noblind = Options.noblind.Value
	end)
	
	StunBool:OnChanged(function(Value)
		getgenv().Stun = Options.nostun.Value
	end)

	Tabs.Misc:AddButton({
		Title = "Unlock Emotes",
		Callback = function()
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).OneArmHandstandPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).NoArmsPushUp.Value = 1
			workspace.PlayersDataFolder:FindFirstChild(Player.Name).HandstandPushUp.Value = 1
		end
	})
	
	local function returnstable()
		for _, Object in pairs(workspace:GetDescendants()) do
			if Object.Name == "Stable" then
				return Object:WaitForChild("CarriageSpawns"):WaitForChild("CarriageSpawn")
			end
		end
	end

	--[[local Input = Tabs.Misc:AddInput("GP", {
		Title = "GP Addon",
		Default = "0",
		Placeholder = "how much gp u want added",
		Numeric = false,
		Finished = true,
		Callback = function(Value)
			local args = {
				[1] = "CannonCarriage",
				[2] = returnstable(),
				[3] = -Value
			}

			game:GetService("ReplicatedStorage"):WaitForChild("DeployEvent"):FireServer(unpack(args))
		end
	})]]
	
	local staffnotiff = Tabs.Misc:AddToggle("staffnotif", {Title = "Staff Notification", Default = true, Description = "☉ notifies you if a staff member joins"})
	staffnotiff:OnChanged(function()
		getgenv().staffnotify = Options.staffnotif.Value
	end)
	
	if fireproximityprompt then
		local PickupBool = Tabs.Misc:AddToggle("autopick", {Title = "Auto-Pickup Gifts", Default = false, })

		PickupBool:OnChanged(function()
			getgenv().autopickup = Options.autopick.Value
			while getgenv().autopickup do
				local cache = {}

				local function isPlayerWithinDistance(prompt)
					local player = game:GetService("Players").LocalPlayer
					if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local playerPosition = player.Character.HumanoidRootPart.Position
						local promptPosition = prompt.Parent.Position
						return (playerPosition - promptPosition).Magnitude <= prompt.MaxActivationDistance
					end
					return false
				end

				local function processGift(gift)
					local proximityPrompt = gift:FindFirstChild("GToOpen")
					if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
						if not table.find(cache, proximityPrompt) then
							table.insert(cache, proximityPrompt)
						end
					end
				end

				for _, gift in ipairs(workspace:GetDescendants()) do
					if gift:IsA("BasePart") and gift.Name == "Gift" then
						processGift(gift)
					end
				end

				workspace.ChildAdded:Connect(function(child)
					if child:IsA("BasePart") and child.Name == "Gift" then
						processGift(child)
					end
				end)

				while task.wait(0.001) and getgenv().autopickup do
					for i = #cache, 1, -1 do
						local prompt = cache[i]
						if prompt and prompt.Parent and prompt.Enabled then
							if isPlayerWithinDistance(prompt) then
								prompt.RequiresLineOfSight = false
								fireproximityprompt(prompt)
							end
						else
							table.remove(cache, i)
						end
					end
				end
			end
		end)
	end

	local TeamDropdown = Tabs.Misc:AddDropdown("Team Change", {
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
		Content = "☉ dont use interior police unless its Stage 11 or Stage 12, if you switch to soldiers as a warrior itll make you a soldier shifter"
	})

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
			if not Character:FindFirstChild("Shifter") then
				if Player.Team.Name == "Rogue" then
					local args = {
						[1] = "Soldiers"
					}

					game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
					task.wait(0.3)
					local ohString1 = "Cloak"
					local ohNil2 = nil
					local ohBoolean3 = true

					Player:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ClothesChange:InvokeServer(ohString1, ohNil2, ohBoolean3)
				else
					local args = {
						[1] = Player.Team.Name
					}

					game:GetService("ReplicatedStorage"):WaitForChild("Wear3DClothesEvent"):FireServer(unpack(args))
				end
			end
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

	--[[SpecialSkills:OnChanged(function()
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
	end)]]

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

	Tabs.Third:AddButton({
		Title = "Infinite Timer",
		Callback = function()
			local function onKeyPress(input, gameProcessed)
				if input.KeyCode == Enum.KeyCode.P and Character:FindFirstChild("Shifter") and not gameProcessed then
					local scriptWithEvent = findLocalScriptWithName(Character, "Local")
					if scriptWithEvent then
						for i,v in pairs(Character:WaitForChild("Humanoid"):GetPlayingAnimationTracks()) do
							v:Stop()
						end
						local args = {
							[1] = false,
							[3] = false
						}

						scriptWithEvent.Events.ShiftEvent:FireServer(unpack(args))
						Animate(16428277926)
						task.wait(0.7)
						Animate(16428283646)
					end
				end
			end
			local function callback()
				local ShifterScript = findLocalScriptWithName(Character, "Local")

				if ShifterScript then
					local Unshift = findLocalFunction(ShifterScript, "Unshift")

					if Unshift then
						local old
						old = hookfunction(Unshift, function(...)
							return nil
						end)
					else
						return
					end
				else
					return
				end

				game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
			end

			callback()
		end
	})
	
	local ShifterSpeed = Tabs.Third:AddSlider("ShifterSpeed", {
		Title = "Speed",
		Default = 16,
		Min = 16,
		Max = 200,
		Rounding = 1,
		Callback = function(Value)
			if not Character:FindFirstChild("ShifterHolder") then
				return
			else
				for _, child in pairs(Character:GetChildren()) do
					if string.find(child.Name, "Local") then
						local stats = child:FindFirstChild("Stats")
						if stats then
							local runningSpeed = stats:FindFirstChild("RunningSpeed")
							if runningSpeed then
								runningSpeed.Value = Value
							end
						end
					end
				end
			end
		end
	})

	GasBool:OnChanged(function()
		getgenv().InfiniteGas = Options.InfiniteGas.Value
	end)
	
	local function setupOdmInstantHook()
		local normal = {}
		local four, two = nil, nil
		local savefunc

		for i, func in next, getreg() do
			if type(func) ~= 'function' then continue end
			local info = debug.getinfo(func)
			if not (info.source:find('Gear') or info.source:find('APGear')) then continue end
			if not info.source:find('Gear') then continue end
			local upValues = debug.getupvalues(func)
			local constants = debug.getconstants(func)
			for up, value in next, constants do
				if value == 400 or value == 200 then
					if value == 400 then four = up end
					if value == 200 then two = up end
					savefunc = func
				end
			end
		end

		return savefunc, four, two
	end

	local function waitforodm(callback)
		task.spawn(function()
			local odmHookFunction, odmHookOne, odmHookTwo = setupOdmInstantHook()
			while not (odmHookFunction and odmHookOne and odmHookTwo) do
				task.wait()
				odmHookFunction, odmHookOne, odmHookTwo = setupOdmInstantHook()
			end
			callback(odmHookFunction, odmHookOne, odmHookTwo)
		end)
	end

	local odmHookFunction, odmHookOne, odmHookTwo

	waitforodm(function(func, one, two)
		odmHookFunction = func
		odmHookOne = one
		odmHookTwo = two
	end)

	InstantHookBool:OnChanged(function()
		getgenv().instanthook = Options.InstantHook.Value
		if odmHookFunction and odmHookOne and odmHookTwo then
			if getgenv().instanthook then
				debug.setconstant(odmHookFunction, odmHookOne, 10000000)
				debug.setconstant(odmHookFunction, odmHookTwo, 10000000)
			else
				debug.setconstant(odmHookFunction, odmHookOne, 400)
				debug.setconstant(odmHookFunction, odmHookTwo, 200)
			end
		else
			return
		end
	end)

	Player.CharacterAdded:Connect(function(character)
		repeat task.wait() until character:FindFirstChild("Gear")
		waitforodm(function(func, one, two)
			odmHookFunction = func
			odmHookOne = one
			odmHookTwo = two
			if odmHookFunction and odmHookOne and odmHookTwo then
				if getgenv().instanthook then
					debug.setconstant(odmHookFunction, odmHookOne, 10000000)
					debug.setconstant(odmHookFunction, odmHookTwo, 10000000)
				else
					debug.setconstant(odmHookFunction, odmHookOne, 400)
					debug.setconstant(odmHookFunction, odmHookTwo, 200)
				end
			end
		end)
	end)

	
	game:GetService("UserInputService").InputBegan:Connect(function(Input, GPE)
		if not GPE and Input.KeyCode == Enum.KeyCode[InstantHookKeybind.Value] then
			Options.InstantHook.Value = not Options.InstantHook.Value
			getgenv().instanthook = Options.InstantHook.Value
			Options.InstantHook:SetValue(Options.InstantHook.Value)

			local status = getgenv().instanthook and "enabled" or "disabled"

			Fluent:Notify({
				Title = "Tear",
				Content = "Instant Hook has been " .. status .. ".",
				Duration = 3
			})
		end
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
	
	CannonBool:OnChanged(function()
		getgenv().cannoncd = Options.Cannon.Value
		game:GetService("UserInputService").InputBegan:Connect(function(Input, GPE)
			if GPE then return end
			if Input.KeyCode == Enum.KeyCode.F then
				if getgenv().cannoncd then
					if Character:WaitForChild("Humanoid").SeatPart then
						if Character:WaitForChild("Humanoid").SeatPart.Parent.Name == "GroundCannon" or Character:WaitForChild("Humanoid").SeatPart.Parent.Name == "WallCannon" then
							Character:WaitForChild("Humanoid").SeatPart.Parent:WaitForChild("TurretControlScript"):WaitForChild("FireEvent"):InvokeServer()
						end
					else
						return
					end
				end
			end
		end)
	end)
	
	BladeSpamBool:OnChanged(function()
		getgenv().bladespam = Options.BladeSpam.Value
		while getgenv().bladespam do
			local Mouse = Player:GetMouse()
			local MousePosition = Mouse.Hit.p
			local args = {
				[1] = CFrame.new(MousePosition, MousePosition + Vector3.new(0, 0, 0))
			}

			local team = Player.Team
			local teams = game:GetService("Teams")

			if team ~= teams.Choosing then
				if team == teams.Soldiers then
					local gear = Character:FindFirstChild("Gear") or Character:FindFirstChild("APGear")
					if gear and gear:FindFirstChild("Events") and gear.Events:FindFirstChild("MoreEvents") and gear.Events.MoreEvents:FindFirstChild("BladeThrow") then
						gear.Events.MoreEvents.BladeThrow:FireServer(unpack(args))
					end
				end
			end
			task.wait(0.01)
		end
	end)

	HookTimeBool:OnChanged(function()
		getgenv().InfiniteHookTime = Options.Hooktime.Value
		while getgenv().InfiniteHookTime do
			if Character then
				local humanoid = Character:WaitForChild("Humanoid")
				if humanoid then
					local Gear = Character:FindFirstChild("Humanoid"):FindFirstChild("Gear")
					local APGear = Character:FindFirstChild("Humanoid"):FindFirstChild("APGear")

					local TensionR, TensionL

					if Gear then
						TensionR = Gear:FindFirstChild("HookTensionR")
						TensionL = Gear:FindFirstChild("HookTensionL")
					elseif APGear then
						TensionR = APGear:FindFirstChild("HookTensionR")
						TensionL = APGear:FindFirstChild("HookTensionL")
					end

					if TensionR.Value > 60 then
						TensionR.Value = 60
					end

					if TensionL.Value > 60 then
						TensionL.Value = 60
					end
				end
			end
			task.wait(0.01)
		end
	end)

	AntiHookBool:OnChanged(function()
		getgenv().AntiHook = Options.antihook.Value
		if getgenv().AntiHook then
			local debounce1 = false
			local maindebounce = false

			local function setupCharacter(character)
				Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
					if getgenv().AntiHook then
						if (child.Name == "EAttachment" or child.Name == "QAttachment") then
							if not debounce1 then
								debounce1 = true
								if not maindebounce then
									maindebounce = true
									local args = { [1] = Character:WaitForChild("HumanoidRootPart") }
									local gear = Character:FindFirstChild("APGear") or Character:WaitForChild("Gear")
									local hookL = Character:WaitForChild("Humanoid").Gear:FindFirstChild("HookTensionL").Value
									local hookR = Character:WaitForChild("Humanoid").Gear:FindFirstChild("HookTensionR").Value
									local hook

									if hookL == 0 and hookR == 0 then
										hook = Character:WaitForChild("Gear").Events.MoreEvents.CastEKey
									elseif hookR > 0 and hookL == 0 then
										hook = Character:WaitForChild("Gear").Events.MoreEvents.CastQKey
									elseif hookR == 0 and hookL > 0 then
										hook = Character:WaitForChild("Gear").Events.MoreEvents.CastEKey
									end

									if hook then
										hook:FireServer(unpack(args))
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

			if Character then
				setupCharacter(Character)
			end

			Player.CharacterAdded:Connect(function(character)
				setupCharacter(character)
			end)
		end
	end)
	
	TitanDmg:OnChanged(function()
		getgenv().DamageSpoof = Options.dmgslid.Value
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
	
	HoodKeyBool:OnChanged(function()
		getgenv().hoodkey = Options.HoodKey.Value
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(Input, GPE)
		if not GPE and getgenv().hoodkey == true and Input.KeyCode == Enum.KeyCode[HoodKeybind.Value] then
			if Character:FindFirstChild("Humanoid") and workspace:WaitForChild("PlayersDataFolder")[Player.Name].Cloak.Value == 1 then
				if Character:FindFirstChild("Humanoid"):WaitForChild("Hood").Value == false then
					local ohString1 = "Hood"
					local ohNil2 = nil
					local ohBoolean3 = true

					Player:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ClothesChange:InvokeServer(ohString1, ohNil2, ohBoolean3)
				else
					local ohString1 = "Hood"
					local ohNil2 = nil
					local ohBoolean3 = false

					Player:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ClothesChange:InvokeServer(ohString1, ohNil2, ohBoolean3)
				end
			else
				return
			end
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
		Title = "Stop Animation",
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
	
	ESP.Load()
	
	local function addCartToESP(Cart)
		if string.find(Cart.Name, "Carriage") then
			if not CartInstances[Cart] then
				local object = ESP.AddInstance(Cart, {
					text = Cart:WaitForChild("Carriage"):WaitForChild("Humanoid"):WaitForChild("Type").Value,
					textColor = { Color3.new(0.784314, 0.678431, 0.713725), 1 },
					textOutline = true,
					textOutlineColor = Color3.new(),
					textSize = 13,
					textFont = 2,
					limitDistance = false,
					maxDistance = 150
				})
				CartInstances[Cart] = object
			end
			CartInstances[Cart].options.enabled = true
		end
	end

	local function addTitanToESP(Titan)
		if not TitanInstances[Titan] then
			local object = ESP.AddInstance(Titan, {
				text = Titan.Name,
				textColor = { Color3.new(0.784314, 0.678431, 0.713725), 1 },
				textOutline = true,
				textOutlineColor = Color3.new(),
				textSize = 13,
				textFont = 2,
				limitDistance = false,
				maxDistance = 150
			})
			TitanInstances[Titan] = object
		end
		TitanInstances[Titan].options.enabled = true
	end

	local function initializeCartESP()
		for _, Cart in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
			addCartToESP(Cart)
		end

		workspace:WaitForChild("OnGameHorses").ChildAdded:Connect(function(newCart)
			if Options.CartESP.Value then
				addCartToESP(newCart)
			end
		end)
	end

	local function initializeTitanESP()
		for _, Titan in pairs(workspace:WaitForChild("OnGameTitans"):GetChildren()) do
			addTitanToESP(Titan)
		end

		workspace:WaitForChild("OnGameTitans").ChildAdded:Connect(function(newTitan)
			if Options.TitanESP.Value then
				addTitanToESP(newTitan)
			end
		end)
	end

	local ESPBool = Tabs.Fifth:AddToggle("ESP", {Title = "ESP", Default = false, })
	local ESPBoxBool = Tabs.Fifth:AddToggle("ESPBox", {Title = "Boxes", Default = false, })
	local ESPHealthBool = Tabs.Fifth:AddToggle("ESPHealth", {Title = "Health", Default = false, })
	Tabs.Fifth:AddParagraph({
		Title = "___________________________________________________________",
	})
	local TitanBool = Tabs.Fifth:AddToggle("TitanESP", {Title = "Titan ESP", Default = false, })
	local CartBool = Tabs.Fifth:AddToggle("CartESP", {Title = "Cart ESP", Default = false, })
	ESPBool:OnChanged(function()
		local Val = Options.ESP.Value
		if Val then
			ESP.sharedSettings.includeLocalPlayer = true

			ESP.teamSettings.enemy.enabled = true
			ESP.teamSettings.enemy.name = true
			ESP.teamSettings.enemy.nameColor[1] = Color3.fromRGB(167, 51, 51)

			ESP.teamSettings.friendly.enabled = true
			ESP.teamSettings.friendly.name = true
			ESP.teamSettings.friendly.nameColor[1] = Color3.fromRGB(90, 167, 99)
		else
			ESP.sharedSettings.includeLocalPlayer = false

			ESP.teamSettings.enemy.enabled = false
			ESP.teamSettings.enemy.name = false

			ESP.teamSettings.friendly.enabled = false
			ESP.teamSettings.friendly.name = false
		end
	end)

	ESPBoxBool:OnChanged(function()
		local Val = Options.ESPBox.Value
		if Val then
			ESP.teamSettings.enemy.box = true
			ESP.teamSettings.enemy.boxOutline = true
			ESP.teamSettings.enemy.boxColor[1] = Color3.fromRGB(167, 51, 51)

			ESP.teamSettings.friendly.box = true
			ESP.teamSettings.friendly.boxOutline = true
			ESP.teamSettings.friendly.boxColor[1] = Color3.fromRGB(90, 167, 99)
		else
			ESP.teamSettings.enemy.box = false
			ESP.teamSettings.enemy.boxOutline = false

			ESP.teamSettings.friendly.box = false
			ESP.teamSettings.friendly.boxOutline = false
		end
	end)

	ESPHealthBool:OnChanged(function()
		local Val = Options.ESPHealth.Value
		if Val then
			ESP.teamSettings.enemy.healthText = true
			ESP.teamSettings.enemy.healthTextColor[1] = Color3.fromRGB(200, 173, 182)

			ESP.teamSettings.friendly.healthText = true
			ESP.teamSettings.friendly.healthTextColor[1] = Color3.fromRGB(200, 173, 182)
		else
			ESP.teamSettings.friendly.healthText = false
			ESP.teamSettings.enemy.healthText = false
		end
	end)

	CartBool:OnChanged(function()
		if Options.CartESP.Value then
			initializeCartESP()
		else
			for Cart, object in pairs(CartInstances) do
				object.options.enabled = false
			end
		end
	end)

	TitanBool:OnChanged(function()
		if Options.TitanESP.Value then
			initializeTitanESP()
		else
			for Cart, object in pairs(TitanInstances) do
				object.options.enabled = false
			end
		end
	end)

	TitanDetectionBool:OnChanged(function()
		getgenv().titandetection = Options.Titandetection.Value
		local TitanHook;
		TitanHook = hookmetamethod(game, '__namecall', function(self, ...)
			local args = {...}
			local call_type = getnamecallmethod();
			if call_type == 'FireServer' and tostring(self) == 'TitanTouchedEvent' and getgenv().titandetection then 
				args[1] = workspace.Camera:WaitForChild("CameraPart")
				return TitanHook(self, unpack(args))
			else
				return TitanHook(self, ...)
			end
		end)
		toggleTitanDetector()
	end)
	
	
	local TitanDmgHook; TitanDmgHook = hookmetamethod(game, '__namecall', function(self, ...)
		local args = {...}
		local call_type = getnamecallmethod();
		if call_type == 'FireServer' and tostring(self) == 'HitEvent' and getgenv().DamageSpoof then 
			args[2] = dmg
			return TitanDmgHook(self, unpack(args))
		else
			return TitanDmgHook(self, ...)
		end
	end)
	
	--local HorseGod = Tabs.Sixth:AddToggle("HorseGod", {Title = "Horse God Mode", Default = false, })

	--[[HorseGod:OnChanged(function()
		getgenv().horsegod = Options.HorseGod.Value
	end)]]

	local HorseStamina = Tabs.Sixth:AddToggle("HorseStamina", {Title = "Infinite Horse Stamina", Default = false, })

	HorseStamina:OnChanged(function()
		getgenv().horsestam = Options.HorseStamina.Value
	end)

	local HorseSpeed = Tabs.Sixth:AddSlider("HorseSpeedSlider", {
		Title = "Horse Speed",
		Default = 30,
		Min = 30,
		Max = 100,
		Rounding = 1,
		Callback = function(Value)

		end
	})

	local HorseSpeedVal = Options.HorseSpeedSlider.Value

	HorseSpeed:OnChanged(function(Value)
		HorseSpeedVal = Options.HorseSpeedSlider.Value
	end)
	
	game:GetService("Players").PlayerAdded:Connect(function(Player)
		if table.find(StaffList, Player.UserId) and getgenv().staffnotify then
			Fluent:Notify({
				Title = "Tear",
				Content = "Staff Member " .. Player.Name .. " Has Joined",
				Duration = 8
			})
		end
	end)
	
	game:GetService("Players").PlayerRemoving:Connect(function(Player)
		if table.find(StaffList, Player.UserId) and getgenv().staffnotify then
			Fluent:Notify({
				Title = "Tear",
				Content = "Staff Member " .. Player.Name .. " Has Left",
				Duration = 8
			})
		end
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
		
		if Fluent.Unloaded then
			ESP.sharedSettings.includeLocalPlayer = false

			ESP.teamSettings.enemy.enabled = false
			ESP.teamSettings.enemy.name = false

			ESP.teamSettings.friendly.enabled = false
			ESP.teamSettings.friendly.name = false

			ESP.teamSettings.friendly.healthText = false
			ESP.teamSettings.enemy.healthText = false

			ESP.teamSettings.enemy.box = false
			ESP.teamSettings.enemy.boxOutline = false

			ESP.teamSettings.friendly.box = false
			ESP.teamSettings.friendly.boxOutline = false
			
			for Cart, object in pairs(CartInstances) do
				object.options.enabled = false
				CartInstances[Cart] = nil
			end
		end
		
		if Character:FindFirstChild("Shifter") then
			for _, v in pairs(Player.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
				v.Enabled = false
			end
		end
		
		if ahspeed == 1 then
			getgenv().AHSpeed = 0.3
		elseif ahspeed == 2 then
			getgenv().AHSpeed = 0.25
		elseif ahspeed == 3 then
			getgenv().AHSpeed = 0.2
		elseif ahspeed == 4 then
			getgenv().AHSpeed = 0.15
		end
		
		if getgenv().noblind then
			for _, Object in pairs(Player.PlayerGui:WaitForChild("ShiftersGui"):GetDescendants()) do
				if Object.Name == "LBlind" or Object.Name == "RBlind" or Object.Name == "FullBlind" then
					if Object.Visible == true then
						Object.Visible = false
					end
				end
			end
		end

		if getgenv().Stun then
			if Character:FindFirstChild("Shifter") then
				for _, Object in pairs(Character:GetDescendants()) do
					if Object:IsA("BoolValue") and Object.Name == "Stun" and Object.Parent and Object.Parent.Name == "PunchImpact" then
						if Object.Value == true then
							for _, Descendant in pairs(Character:GetDescendants()) do
								if Descendant:IsA("RemoteEvent") and Descendant.Name == "UnstunnedEvent" then
									Descendant:FireServer(true)
									break
								end
							end
						end
					end
				end
			end
		end

		if getgenv().ShifterLegHitbox then
			for _, TitanS in pairs(workspace:GetChildren()) do
				if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
					local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
					local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
					if TitanS:FindFirstChild("RLegTendons") and TitanS:FindFirstChild("LLegTendons") then
						if not (TitanS.Name == "ArmoredTitan" and TitanS.LLegTendons:FindFirstChild("Armored") and TitanS.LLegTendons:WaitForChild("Armored").Value == true) and not (TitanS.Name == "ColossalTitan") then
							if Player.Team.Name ~= Team or Player.Team.Name == "Rogue" or Team == "Rogue" then
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
		
		for i, horse in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
			local horseHumanoid = horse:FindFirstChild("Humanoid")
			local carriage = horse:FindFirstChild("Carriage")

			if carriage then
				pcall(function()
					horseHumanoid = carriage.Humanoid
				end)
			end

			if horseHumanoid then
				if horseHumanoid.Health > 0 then
					if horseHumanoid:WaitForChild("Owner") then
						local horseOwner = horseHumanoid.Owner.Value

						if horseOwner == Player.Name and horseHumanoid.Mounted.Value == true then
							local config = horseHumanoid.Parent.Configuration

							local god = horseHumanoid.God
							local Stam = config.Stamina
							local speed = config.CurrentSpeed
							local maxspeed = config.MaxSpeed

							if god and getgenv().horsegod then
								god.Value = Options.HorseGod.Value
							end

							if Stam and getgenv().horsestam then
								Stam.Value = 4000
							end

							if speed and maxspeed then
								maxspeed.Value = HorseSpeedVal
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

		if getgenv().InfiniteGas then
			Character:WaitForChild("Humanoid"):WaitForChild("Gear"):WaitForChild("Gas").Value = 2000
		end

		if getgenv().InfiniteGas then
			Character:WaitForChild("Humanoid"):WaitForChild("Gear"):WaitForChild("Gas").Value = 2000
		end
		
		Character:WaitForChild("Humanoid"):WaitForChild("Invinsible").Value = Options.Titandetection.Value
		
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

		if getgenv().ShifterNapeHitbox then
			for _, TitanS in pairs(workspace:GetChildren()) do
				if TitanS:FindFirstChild("Shifter") and TitanS ~= Character and not (TitanS.Name == "ArmoredTitan") then
					local ShifterPlr = game:GetService("Players"):GetPlayerFromCharacter(TitanS)
					local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
					if Player.Team.Name ~= Team or Player.Team.Name == "Rogue" or Team == "Rogue" then
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
