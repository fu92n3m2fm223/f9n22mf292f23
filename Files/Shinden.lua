local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
	Title = "Tear - " .. game.PlaceId,
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main",}),
	Training = Window:AddTab({ Title = "Training",}),
	Settings = Window:AddTab({ Title = "Settings"})
}

local Options = Fluent.Options

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

Player.CharacterAdded:Connect(function(New)
	Character = New
end)

getgenv().TripleJump = false
getgenv().BodyFlicker = false
getgenv().Regen = false
getgenv().FallDmg = false
getgenv().Pushups = false
getgenv().Handsigns = false
getgenv().Meditation = false

do
	Tabs.Main:AddButton({
		Title = "Respawn",
		Callback = function()
			Character.HumanoidRootPart.CFrame = CFrame.new(20824.970703125, -901.434814453125, -3529.85595703125)
		end
	})
	local TripleJump = Tabs.Main:AddToggle("TJ", {Title = "Triple Jump", Default = false })
	TripleJump:OnChanged(function()
		getgenv().TripleJump = Options.TJ.Value
		if getgenv().TripleJump == false then
			local TripleJumpF = Player.Backpack:FindFirstChild("Triple Jump")
			if TripleJumpF then
				TripleJumpF:Destroy()
			end
		else
			local TripleJumpS = Instance.new("Folder", Player.Backpack)
			TripleJumpS.Name = "Triple Jump"
		end
	end)
	local BodyFlicker = Tabs.Main:AddToggle("BF", {Title = "Body Flicker", Default = false })
	BodyFlicker:OnChanged(function()
		getgenv().BodyFlicker = Options.BF.Value
		if getgenv().BodyFlicker == false then
			local BodyFlickerF = Character:FindFirstChild("BodyFlicker")
			if BodyFlickerF then
				BodyFlickerF:Destroy()
			end
		else
			local BodyFlickerS = Instance.new("Folder", Character)
			BodyFlickerS.Name = "BodyFlicker"
		end
	end)
	local FallDmg = Tabs.Main:AddToggle("FD", {Title = "No Fall Damage", Default = false,})
	FallDmg:OnChanged(function()
		getgenv().FallDmg = Options.FD.Value
		local fallhook;
		fallhook = hookmetamethod(game, '__namecall', function(self, ...)
			local args = {...}
			local call_type = getnamecallmethod();
			if call_type == 'FireServer' and tostring(self) == 'SelfHarm' and getgenv().FallDmg == true then 
				args[1] = 0
				return fallhook(self, unpack(args))
			else
				return fallhook(self, ...)
			end
		end)
	end)
	local HoshRegen = Tabs.Main:AddToggle("HR", {Title = "Constant Health Regen", Default = false, Description = "only works if your a hoshigaki & have waterwalking" })
	HoshRegen:OnChanged(function()
		getgenv().Regen = Options.HR.Value
		game:GetService("RunService").RenderStepped:Connect(function()
			if getgenv().Regen then
				local args = {
					[1] = CFrame.new(0, 0, 0),
					[2] = workspace:WaitForChild("World"):WaitForChild("Environment"):WaitForChild("Water")
				}

				Character.FootSteps.WaterStep:FireServer(unpack(args))
			end
		end)
	end)
	local SpeedSlider = Tabs.Main:AddSlider("Slider1", {
		Title = "Run Speed",
		Default = 0,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Callback = function(Value)

		end
	})
	
	local Pushups = Tabs.Training:AddToggle("PS", {Title = "Auto Pushups", Default = false,})
	Pushups:OnChanged(function()
		getgenv().Pushups = Options.PS.Value
		while task.wait(1.5) and getgenv().Pushups == true do
			if Character:FindFirstChild("Pushup Training") then
				Character:WaitForChild("Pushup Training").RemoteEvent:FireServer()
			end
		end
	end)
	
	local Handsigns = Tabs.Training:AddToggle("HS", {Title = "Auto Handsigns", Default = false,})
	Handsigns:OnChanged(function()
		getgenv().Handsigns = Options.HS.Value
	end)
	
	local Meditation = Tabs.Training:AddToggle("MT", {Title = "Auto Meditation", Default = false,})
	Handsigns:OnChanged(function()
		getgenv().Meditation = Options.MT.Value
	end)
	
	local Speed = Options.Slider1.Value

	SpeedSlider:OnChanged(function(Value)
		Speed = Options.Slider1.Value
	end)
	
	Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(v)
		if getgenv().Meditation then
			if v.SoundId == "rbxassetid://244264387" then
				if Character:FindFirstChild("Meditation Training") then
					Character:WaitForChild("Meditation Training"):Activate()
				end
			end
		end
		
		if getgenv().Handsigns then
			if v:IsA("Sound") and v.SoundId == "rbxassetid://147722227" then
				if Character:FindFirstChild("Handsign Training") then
					Character:WaitForChild("Handsign Training"):Activate()
				end
			end
		end
	end)
	
	local SpeedVal = Player.SpeedBuff
	local speedhook;
	speedhook = hookmetamethod(game,'__index',function(self,v)
		if self == SpeedVal and v == "Value" then
			return Speed
		end
		return speedhook(self,v)
	end)
	
	Player.CharacterAdded:Connect(function()
		local SpeedVal = Player.SpeedBuff
		local speedhook;
		speedhook = hookmetamethod(game,'__index',function(self,v)
			if self == SpeedVal and v == "Value" then
				return Speed
			end
			return speedhook(self,v)
		end)
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
