local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local Games = {
	Shinden = {
		Lobby = 6808589067,
		Main = 10369535604,
	},
}

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Sense = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Sirius/request/library/sense/source.lua'))()

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

function onCharacterAdded(character)
	Character = character

	if game.PlaceId == 10369535604 then
		if getgenv().BodyFlicker == true and not Character:FindFirstChild("BodyFlicker") then
			local BodyFlicker = Instance.new("StringValue", Character)
			BodyFlicker.Name = "BodyFlicker"
		end

		if getgenv().TripleJump == true and not Player.Backpack:FindFirstChild("Triple Jump") then
			local TripleJump = Instance.new("Folder", Player.Backpack)
			TripleJump.Name = "Triple Jump"
		end

		if getgenv().CatCovering == true and not Character:FindFirstChild("Covering") then
			local BodyFlicker = Instance.new("StringValue", Character)
			BodyFlicker.Name = "Covering"
		end
	end
end

Player.CharacterAdded:Connect(onCharacterAdded)

local Window = Library:CreateWindow({
	Title = tostring("Tear - " .. game.PlaceId),
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Main = Window:AddTab('Main'),
	ESP = Window:AddTab('ESP'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

getgenv().HandSignTraining = false
getgenv().PushupTraining = false
getgenv().MeditationTraining = false
getgenv().FallDmg = false
getgenv().BodyFlicker = false
getgenv().CatCovering = false
getgenv().Streamable = false
getgenv().AlwaysRegen = false
getgenv().Noclip = false
getgenv().TripleJump = false
getgenv().AntiGrip = false

local Cheats = Tabs.Main:AddLeftGroupbox('')
local Cheats2 = Tabs.Main:AddRightGroupbox('')

Cheats:AddButton({
	Text = 'Respawn',
	Func = function()
		Character.HumanoidRootPart.CFrame = CFrame.new(20824.970703125, -901.434814453125, -3529.85595703125)
	end,
	DoubleClick = false,
})

Cheats:AddToggle('HoshigakiRegen', {
	Text = 'Hoshigaki Constant Regen',
	Default = false,
	Tooltip = "must be hoshigaki",
	Callback = function(Value)
		if Character:FindFirstChild("Clan").Value ~= "Hoshigaki" then
			return
		else
			if getgenv().AlwaysRegen == false then
				getgenv().AlwaysRegen = true
				RunService.RenderStepped:Connect(function()
					if getgenv().AlwaysRegen then
						local args = {
							[1] = CFrame.new(0, 0, 0),
							[2] = workspace:WaitForChild("World"):WaitForChild("Environment"):WaitForChild("Water")
						}

						Character.FootSteps.WaterStep:FireServer(unpack(args))
					end
				end)
			elseif getgenv().AlwaysRegen == true then
				getgenv().AlwaysRegen = false
			end
		end
	end
})

Cheats:AddToggle('FallDmg', {
	Text = 'No Fall Damage',
	Default = false,
	Callback = function(Value)
		if getgenv().FallDmg == false then
			getgenv().FallDmg = true
			local fallhook;
			fallhook = hookmetamethod(game, '__namecall', function(self, ...)
				local args = {...}
				local call_type = getnamecallmethod();
				if call_type == 'FireServer' and tostring(self) == 'SelfHarm' and getgenv().FallDmg == true then 
					if args[1] == 10000 then
						return
					end
					args[1] = 0
					return fallhook(self, unpack(args))
				else
					return fallhook(self, ...)
				end
			end)
		elseif getgenv().FallDmg == true then
			getgenv().FallDmg = false
		end
	end
})

Cheats:AddButton({
	Text = 'God Mode',
	Func = function()
		local args = {
			[1] = -math.huge
		}

		game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("Other"):WaitForChild("SelfHarm"):FireServer(unpack(args))
	end,
	DoubleClick = false,
})

Cheats:AddSlider('SpeedSlider', {
	Text = 'Speed',
	Default = 0,
	Min = 0,
	Max = 100,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)

	end
})

Cheats2:AddButton({
	Text = 'Rejoin Same Server',
	Func = function()
		TeleportService:Teleport(game.PlaceId, Player, game.JobId)
	end,
	DoubleClick = false,
})

Cheats2:AddToggle('AutoPushups', {
	Text = 'Auto Pushup Training',
	Default = false,
	Callback = function(Value)
		if getgenv().HandSignTraining == false then
			if getgenv().PushupTraining == true then
				warn("no work")
			else
				getgenv().HandSignTraining = true
				Character.HumanoidRootPart.ChildAdded:Connect(function(v)
					if v:IsA("Sound") and getgenv().HandSignTraining == true then
						if v.SoundId == "rbxassetid://147722227" then
							Character:WaitForChild("Handsign Training"):Activate()
						end
					end
				end)
			end
		elseif getgenv().HandSignTraining == true then
			getgenv().HandSignTraining = false
		end
	end
})

Cheats2:AddToggle('AutoHandsign', {
	Text = 'Auto Handsign Training',
	Default = false,
	Callback = function(Value)
		if getgenv().PushupTraining == false then
			if getgenv().HandSignTraining == true then
				warn("no work")
			else
				getgenv().PushupTraining = true
				while task.wait(1.5) and getgenv().PushupTraining == true do
					Character:WaitForChild("Pushup Training").RemoteEvent:FireServer()
				end
			end
		elseif getgenv().PushupTraining == true then
			getgenv().PushupTraining = false
		end
	end
})

Cheats2:AddToggle('AutoMeditation', {
	Text = 'Auto Meditation Training',
	Default = false,
	Callback = function(Value)
		if getgenv().MeditationTraining == false then
			if getgenv().HandSignTraining == true or getgenv().PushupTraining == true then
				return
			else
				getgenv().MeditationTraining = true
				Character.HumanoidRootPart.ChildAdded:Connect(function(v)
					if v:IsA("Sound") and getgenv().MeditationTraining == true then
						if v.SoundId == "rbxassetid://244264387" then
							if Character:FindFirstChild("Meditation Training") then
								Character:WaitForChild("Meditation Training"):Activate()
							end
						end
					end
				end)
			end
		elseif getgenv().MeditationTraining == true then
			getgenv().MeditationTraining = false
		end
	end
})

local speed = Options.SpeedSlider.Value

Options.SpeedSlider:OnChanged(function()
	speed = Options.SpeedSlider.Value
end)

local SpeedVal = Player.SpeedBuff
local speedhook;
speedhook = hookmetamethod(game,'__index',function(self,v)
	if self == SpeedVal and v == "Value" then
		return speed
	end
	return speedhook(self,v)
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
