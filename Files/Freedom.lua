--!nolint
--!nocheck

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local VisualLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/refs/heads/main/Files/BESP.lua'))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/0n93f03f222n90/refs/heads/main/adbyp.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
	Title = "Tear",
	Footer = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = false,
	Resizable = false,
})

local Tabs = {
	["Main"] = Window:AddTab("Main", "user"),
    ["Hitboxes"] = Window:AddTab("Hitboxes", "diamond-minus"),
    ["Visuals"] = Window:AddTab("Visual", "scan-eye"),
	["UI Settings"] = Window:AddTab("Settings", "settings"),
}

local Services, Remotes do
	Remotes = setmetatable({}, {
		__index = function(_, Name)
			local Remote = game:GetService("ReplicatedStorage"):FindFirstChild(Name)
			if Remote then
				return Remote
			else
				return nil
			end
		end
	})

	Services = setmetatable({}, {
		__index = function(_, Name)
			local Service = game:GetService(Name)
			if Service then
				return Service
			else
				return nil
			end
		end
	})
end

local Connections = {}

local LocalPlayer = Services.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)

local odmHookFunction, odmHookOne, odmHookTwo

local function setupOdmInstantHook()
    local normal = {}
    local four, two = nil, nil
    local savefunc

    for i, func in next, getreg() do
        if type(func) ~= 'function' then continue end
        local info = debug.getinfo(func)
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

waitforodm(function(func, one, two)
    odmHookFunction = func
    odmHookOne = one
    odmHookTwo = two
end)

Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(New)
    Character = New
	Humanoid = New:WaitForChild("Humanoid", 10)
    repeat task.wait() until New:FindFirstChild("Gear")
    waitforodm(function(func, one, two)
        odmHookFunction = func
        odmHookOne = one
        odmHookTwo = two
        if odmHookFunction and odmHookOne and odmHookTwo then
            if Toggles.InstantHook.Value then
                debug.setconstant(odmHookFunction, odmHookOne, 10000000)
                debug.setconstant(odmHookFunction, odmHookTwo, 10000000)
            else
                debug.setconstant(odmHookFunction, odmHookOne, 400)
                debug.setconstant(odmHookFunction, odmHookTwo, 200)
            end
        end
    end)
end)

local MainGroup = Tabs["Main"]:AddLeftTabbox()
local GearTab = MainGroup:AddTab('Gear')
local CharTab = MainGroup:AddTab('Character')

local HorseBox = Tabs["Main"]:AddRightGroupbox("Horse")
local ShifterBox = Tabs["Main"]:AddRightGroupbox("Shifter")

local MainBox = Tabs["Main"]:AddRightGroupbox("Extra")

local HitboxGroup = Tabs["Hitboxes"]:AddLeftTabbox()
local MindlessHitBox = HitboxGroup:AddTab('Mindless')
local ShifterHitBox = HitboxGroup:AddTab('Shifter')
local HumanBox = Tabs["Hitboxes"]:AddRightGroupbox("Human")

local VisualGroup = Tabs["Visuals"]:AddLeftTabbox()
local PlayerVisual = VisualGroup:AddTab('Player')
local TitanVisual = VisualGroup:AddTab('Titan')
local CartVisual = VisualGroup:AddTab('Cart')

local FlareBox = Tabs["Main"]:AddLeftGroupbox("Flare")
local AnimationBox = Tabs["Main"]:AddLeftGroupbox("Animations")

--// GEAR TAB

GearTab:AddToggle("InfiniteGas", {
	Text = "Infinite Gas",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local InfiniteGas = function()
                if Humanoid then
                    if Humanoid:FindFirstChild("Gear") then
                        Humanoid:WaitForChild("Gear"):WaitForChild("Gas").Value = 2000
                    end
                end
            end
			Connections.InfiniteGas = Services.RunService.RenderStepped:Connect(InfiniteGas)
		else
			if Humanoid then
				if Connections.InfiniteGas then
					Connections.InfiniteGas:Disconnect()
                    Connections.InfiniteGas = nil
				end
			end
        end
	end,
}):AddKeyPicker("InfiniteGasKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Gas",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteGas:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddToggle("InfiniteBlades", {
	Text = "Infinite Blades",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local InfiniteBlades = function()
                if Humanoid then
                    if Humanoid:FindFirstChild("Gear") then
                        Humanoid:WaitForChild("Gear"):WaitForChild("Blades").Value = 8
                    end
                end
            end
			Connections.InfiniteBlades = Services.RunService.RenderStepped:Connect(InfiniteBlades)
		else
			if Humanoid then
				if Connections.InfiniteBlades then
					Connections.InfiniteBlades:Disconnect()
                    Connections.InfiniteBlades = nil
				end
			end
        end
	end,
}):AddKeyPicker("InfiniteBladesKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Blades",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteBlades:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

Reloading = false

GearTab:AddToggle("AutoReloadBlades", {
	Text = "Auto Reload Blades",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local AutoReload = function()
                if Humanoid then
                    local Gear = Humanoid:FindFirstChild("Gear")
                    if Gear then
                        local bladeDurability = Gear:FindFirstChild("BladeDurability")
                        if bladeDurability then
                            if bladeDurability.Value == 0 and not Reloading then
                                Reloading = true
                                Services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.1)
                                Services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                            elseif bladeDurability.Value > 0 then
                                Reloading = false
                            end
                        end
                    end
                end
            end
			Connections.AutoReload = Services.RunService.RenderStepped:Connect(AutoReload)
		else
			if Humanoid then
				if Connections.AutoReload then
					Connections.AutoReload:Disconnect()
                    Connections.AutoReload = nil
				end
			end
        end
	end,
}):AddKeyPicker("AutoReloadBladesKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Auto Reload Blades",
	NoUI = false,

	Callback = function(Value)
		Toggles.AutoReloadBlades:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddToggle("BladeThrowSpam", {
	Text = "Blade Throw Spam",

    Tooltip = "RageMode is needed for this",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local BladeThrowSpam = function()
                if Humanoid then
                    local args = {
                        [1] = CFrame.new(LocalPlayer:GetMouse().Hit.p, LocalPlayer:GetMouse().Hit.p + Vector3.new(0, 0, 0))
                    }
                    if LocalPlayer.Team ~= Services.Teams.Choosing then
                        if LocalPlayer.Team == Services.Teams.Soldiers then
                            local Gear = Character:FindFirstChild("Gear") or Character:FindFirstChild("APGear")
                            if Gear and Gear:FindFirstChild("Events") and Gear.Events:FindFirstChild("MoreEvents") and Gear.Events.MoreEvents:FindFirstChild("BladeThrow") then
                                if Humanoid:FindFirstChild("RageMode").Value then
                                    Gear.Events.MoreEvents.BladeThrow:FireServer(unpack(args))
                                end
                            end
                        end
                    end
                end
            end
			Connections.BladeThrowSpam = Services.RunService.RenderStepped:Connect(BladeThrowSpam)
		else
			if Humanoid then
				if Connections.BladeThrowSpam then
					Connections.BladeThrowSpam:Disconnect()
                    Connections.BladeThrowSpam = nil
				end
			end
        end
	end,
}):AddKeyPicker("BladeThrowSpamKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Blade Throw Spam",
	NoUI = false,

	Callback = function(Value)
		Toggles.BladeThrowSpam:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddToggle("InfiniteHookTime", {
	Text = "Infinite Hook Time",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local InfiniteHookTime = function()
                if Character then
                    if Humanoid then
                        local Gear = Humanoid:FindFirstChild("Gear")
                        local APGear = Humanoid:FindFirstChild("APGear")
    
                        local TensionR, TensionL
    
                        if Gear then
                            TensionR = Gear:FindFirstChild("HookTensionR")
                            TensionL = Gear:FindFirstChild("HookTensionL")
                        elseif APGear then
                            TensionR = APGear:FindFirstChild("HookTensionR")
                            TensionL = APGear:FindFirstChild("HookTensionL")
                        end

                        if TensionR then
                            if TensionR.Value > 60 then
                                TensionR.Value = 60
                            end
                        end
                        
                        if TensionL then
                            if TensionL.Value > 60 then
                                TensionL.Value = 60
                            end 
                        end
                    end
                end
            end
			Connections.InfiniteHookTime = Services.RunService.RenderStepped:Connect(InfiniteHookTime)
		else
			if Humanoid then
				if Connections.InfiniteHookTime then
					Connections.InfiniteHookTime:Disconnect()
                    Connections.InfiniteHookTime = nil
				end
			end
        end
	end,
}):AddKeyPicker("InfiniteHookTimeKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Hook Time",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteHookTime:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddToggle("InstantHook", {
	Text = "Instant Hook",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if odmHookFunction and odmHookOne and odmHookTwo then
            if Value then
                debug.setconstant(odmHookFunction, odmHookOne, 10000000)
				debug.setconstant(odmHookFunction, odmHookTwo, 10000000)
            else
                debug.setconstant(odmHookFunction, odmHookOne, 400)
				debug.setconstant(odmHookFunction, odmHookTwo, 200)
            end
        end
	end,
}):AddKeyPicker("InfiniteHookTimeKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Instant Hook",
	NoUI = false,

	Callback = function(Value)
		Toggles.InstantHook:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

--[[GearTab:AddToggle("SilentAimHooks", {
	Text = "Hook Silent Aim",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.SilentAimHooksSlider then
			Options.SilentAimHooksSlider:SetVisible(Value)
		end
        if Value then
            local SilentAimHooks = function()
                if Character then
                    if Humanoid then
                        
                    end
                end
            end
			Connections.SilentAimHooks = Services.RunService.RenderStepped:Connect(SilentAimHooks)
		else
			if Humanoid then
				if Connections.SilentAimHooks then
					Connections.SilentAimHooks:Disconnect()
                    Connections.SilentAimHooks = nil
				end
			end
        end
	end,
}):AddKeyPicker("SilentAimHooksKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Hook Silent Aim",
	NoUI = false,

	Callback = function(Value)
		Toggles.SilentAimHooks:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddSlider("SilentAimHooksSlider", {
	Text = "Radius",
	Default = 20,
	Min = 20,
	Max = 120,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})]]

GearTab:AddToggle("HookRotationSpeed", {
	Text = "Hook Rotation Speed",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.HookRotationSpeedSlider then
			Options.HookRotationSpeedSlider:SetVisible(Value)
		end
        if Value then
            Connections.InstantHookRotation = Services.UserInputService.InputBegan:Connect(function(Input, Event)
                if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Enum.KeyCode.A and not Event then
                    if Services.UserInputService:IsKeyDown(Enum.KeyCode.Q) or Services.UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        if Character then
                            if Humanoid then
                                local RootPart = Character:FindFirstChild("HumanoidRootPart")
                                if RootPart then
                                    Humanoid:ChangeState(0)
                                    RootPart.Velocity = RootPart.CFrame.LookVector * Options.HookRotationSpeedSlider.Value
                                end
                            end
                        end
                    end
                elseif Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Enum.KeyCode.D and not Event then
                    if Services.UserInputService:IsKeyDown(Enum.KeyCode.Q) or Services.UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        if Character then
                            if Humanoid then
                                local RootPart = Character:FindFirstChild("HumanoidRootPart")
                                if RootPart then
                                    Humanoid:ChangeState(0)
                                    RootPart.Velocity = RootPart.CFrame.LookVector * Options.HookRotationSpeedSlider.Value
                                end
                            end
                        end
                    end
                end
            end)
        else
            if Connections.InstantHookRotation then
                Connections.InstantHookRotation:Disconnect()
                Connections.InstantHookRotation = nil
            end
        end
	end,
}):AddKeyPicker("HookRotationSpeedKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Hook Rotation Speed",
	NoUI = false,

	Callback = function(Value)
		Toggles.HookRotationSpeed:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddSlider("HookRotationSpeedSlider", {
	Text = "Speed",
	Default = 5,
	Min = 5,
	Max = 30,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})

GearTab:AddToggle("NoSkillCooldown", {
	Text = "No Skill Cooldown",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoSkillCooldown = function()
                if Humanoid then
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
                    
                    if LocalPlayer.PlayerGui then
                        for _, Skill in pairs(LocalPlayer.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
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
                end
            end
			Connections.NoSkillCooldown = Services.RunService.RenderStepped:Connect(NoSkillCooldown)
		else
			if Humanoid then
				if Connections.NoSkillCooldown then
					Connections.NoSkillCooldown:Disconnect()
                    Connections.NoSkillCooldown = nil
				end
			end
        end
	end,
}):AddKeyPicker("NoSkillCooldownKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Skill Cooldown",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoSkillCooldown:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddToggle("AntiHook", {
	Text = "Anti Hook",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.AntiHookSlider then
			Options.AntiHookSlider:SetVisible(Value)
		end

        if Value then
            local MainDebounce, SecondaryDebounce do
                MainDebounce = false
                SecondaryDebounce = false
            end

            Connections.AntiHook = Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(Object)
                if (Object.Name == "EAttachment" or Object.Name == "QAttachment") then
                    if not MainDebounce then
                        MainDebounce = true
                        if not SecondaryDebounce then
                            SecondaryDebounce = true
                            local args = { [1] = Character:WaitForChild("HumanoidRootPart") }
                            local gear = Character:FindFirstChild("APGear") or Character:WaitForChild("Gear")
                            local hookL = Humanoid.Gear:FindFirstChild("HookTensionL").Value
                            local hookR = Humanoid.Gear:FindFirstChild("HookTensionR").Value
                            local hook = nil

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
                                MainDebounce = false
                            end)
                        end
                        task.wait(Options.AntiHookSlider.Value)
                        SecondaryDebounce = false
                    else
                        Object:Destroy()
                    end
                end
            end)
        else
			if Humanoid then
				if Connections.AntiHook then
					Connections.AntiHook:Disconnect()
                    Connections.AntiHook = nil
				end
			end
        end
	end,
}):AddKeyPicker("AntiHookKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Anti Hook",
	NoUI = false,

	Callback = function(Value)
		Toggles.AntiHook:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

GearTab:AddSlider("AntiHookSlider", {
	Text = "Speed",
	Default = 1,
	Min = 0,
	Max = 4,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})

GearTab:AddDivider()

GearTab:AddToggle("HookRange", {
	Text = "Hook Range",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.HookRangeSlider then
			Options.HookRangeSlider:SetVisible(Value)
		end

        if Value then
            local HookRange = function()
                if Character then
                    if Humanoid then
                        local Gear = Humanoid:FindFirstChild("Gear") or Humanoid:FindFirstChild("APGear")
                        if not Gear then
                            return
                        end
                    
                        local upgrades = Gear:WaitForChild("Upgrades")
                        local hooksRange = upgrades:FindFirstChild("HooksRange")
                    
                        if hooksRange then
                            hooksRange.Value = Options.HookRangeSlider.Value
                        else
                            return
                        end
                    end
                end
            end
			Connections.HookRange = Services.RunService.RenderStepped:Connect(HookRange)
		else
			if Humanoid then
				if Connections.HookRange then
					Connections.HookRange:Disconnect()
                    Connections.HookRange = nil
				end
			end
        end
	end,
})

GearTab:AddSlider("HookRangeSlider", {
	Text = "Range",
	Default = 160,
	Min = 100,
	Max = 1000,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})

GearTab:AddToggle("UnlockSkills", {
	Text = "Unlock Skills",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        local function IsInLobby()
            if LocalPlayer and LocalPlayer.PlayerGui then
                local LobbyGui = LocalPlayer.PlayerGui:FindFirstChild("LobbyGui")
                if LobbyGui then
                    for _, Object in pairs(LobbyGui:GetChildren()) do
                        if Object:IsA("ScreenGui") and Object.Enabled == true then
                            return true
                        end
                    end
                end
            end
            return false
        end
        local UnlockSkills = function(Toggle)
            if Character then
                if Humanoid then
                    if not Character:FindFirstChild("Shifter") then
                        for _, Object in pairs(LocalPlayer.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
                            if IsInLobby() then
                                Object.Enabled = false
                            else
                                Object.Enabled = Toggle
                            end
                        end
                    end
                
                    if Character:FindFirstChild("Shifter") then
                        for _, Object in pairs(LocalPlayer.PlayerGui:WaitForChild("SkillsGui"):GetChildren()) do
                            Object.Enabled = false
                        end
                    end
        
                    local Skills, Upgrades do
                        Skills = Humanoid:WaitForChild("Gear"):WaitForChild("Skills")
                        Upgrades = Humanoid:WaitForChild("Gear"):WaitForChild("Upgrades")
                    end
        
                    if Skills then
                        coroutine.resume(coroutine.create(function()
                            if Skills.Dodge then
                                Skills.Dodge.Value = Toggle
                            end
                            if Skills.Impulse then
                                Skills.Impulse.Value = Toggle
                            end
                            if Skills.HandCut then
                                Skills.HandCut.Value = Toggle
                            end
                            if Skills.HandCutMk2 then
                                Skills.HandCutMk2.Value = Toggle
                            end
                            if Skills.SuperJump then
                                Skills.SuperJump.Value = Toggle
                            end
                            if Skills.BladeThrow then
                                Skills.BladeThrow.Value = Toggle
                            end
                            if Skills.Counter then
                                Skills.Counter.Value = Toggle
                            end
                        end))
                    end                    
        
                    if Upgrades then
                        Upgrades.AttackSpeed.Value = 0.2
                    end
                end
            end
        end
        if Value then
            Connections.UnlockSkills = Services.RunService.RenderStepped:Connect(UnlockSkills)
        else
            if Connections.UnlockSkills then
                Connections.UnlockSkills:Disconnect()
                Connections.UnlockSkills = nil
                UnlockSkills(false)
            end
        end
	end,
})

--// CHARACTER TAB

CharTab:AddToggle("Flight", {
	Text = "Flight",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.FlightSlider then
			Options.FlightSlider:SetVisible(Value)
		end

        if Value then
            if Character then
                if Humanoid then
                    local Head = Character:FindFirstChild("Shifter") and Character.Head.Head or Character.Head
                    if Head then
                        Head.Anchored = true
                        Humanoid.PlatformStand = true
                        Connections.Flight = Services.RunService.Heartbeat:Connect(function(Delta)
                            local moveDirection = Humanoid.MoveDirection * (Options.FlightSlider.Value * Delta)
                            local headCFrame = Head.CFrame
                            local cameraCFrame = workspace.CurrentCamera.CFrame
                            local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
                            cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
                            local cameraPosition = cameraCFrame.Position
                            local headPosition = headCFrame.Position
                    
                            local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
                            Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
                        end)
                    end
                end
            end
        else
            if Character then
                if Humanoid then
                    local Head = Character:FindFirstChild("Shifter") and Character.Head.Head or Character.Head
                    if Head then
                        Head.Anchored = false
                        Humanoid.PlatformStand = false
                    end
                end
            end
            if Connections.Flight then
                Connections.Flight:Disconnect()
                Connections.Flight = nil
            end
        end
	end,
}):AddKeyPicker("FlightKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Flight",
	NoUI = false,

	Callback = function(Value)
		Toggles.Flight:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

CharTab:AddSlider("FlightSlider", {
	Text = "Speed",
	Default = 50,
	Min = 50,
	Max = 200,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})


--[[CharTab:AddToggle("WalkspeedModifier", {
	Text = "Walkspeed",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.WalkspeedModifierSlider then
			Options.WalkspeedModifierSlider:SetVisible(Value)
		end
	end,
}):AddKeyPicker("WalkspeedModifierKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Walkspeed",
	NoUI = false,

	Callback = function(Value)
		Toggles.WalkspeedModifier:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

CharTab:AddSlider("WalkspeedModifierSlider", {
	Text = "Speed",
	Default = 16,
	Min = 16,
	Max = 200,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})]]

CharTab:AddToggle("NoTitanDetection", {
	Text = "No Titan Detection",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoTitanDetection = function()
                if Character then
                    if Humanoid then
                        if Humanoid:FindFirstChild("Invinsible") then
                            Humanoid:FindFirstChild("Invinsible").Value = Value
                        end
                    end
                end
            end
			Connections.NoTitanDetection = Services.RunService.RenderStepped:Connect(NoTitanDetection)
		else
			if Humanoid then
				if Connections.NoTitanDetection then
					Connections.NoTitanDetection:Disconnect()
                    Connections.NoTitanDetection = nil
				end
                if Humanoid:FindFirstChild("Invinsible") then
                    Humanoid:FindFirstChild("Invinsible").Value = false
                end
			end
        end
	end,
}):AddKeyPicker("NoTitanDetectionKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Titan Detection",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoTitanDetection:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

CharTab:AddToggle("NoHoodLoss", {
	Text = "No Hood Loss",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoHoodLoss = function()
                if Humanoid then
                    if LocalPlayer.PlayerGui then
                        if LocalPlayer.PlayerGui:FindFirstChild("LowHealthGui") then
                            if LocalPlayer.PlayerGui:FindFirstChild("LowHealthGui"):FindFirstChild("LoseHoodEvent") then
                                LocalPlayer.PlayerGui:FindFirstChild("LowHealthGui"):FindFirstChild("LoseHoodEvent"):Destroy()
                            end
                        end
                    end
                end
            end
			Connections.NoHoodLoss = Services.RunService.RenderStepped:Connect(NoHoodLoss)
		else
			if Humanoid then
				if Connections.NoHoodLoss then
					Connections.NoHoodLoss:Disconnect()
                    Connections.NoHoodLoss = nil
                    local HoodRemote = Instance.new("RemoteEvent", LocalPlayer.PlayerGui.LowHealthGui)
			        HoodRemote.Name = "LoseHoodEvent"
				end
			end
        end
	end,
}):AddKeyPicker("NoHoodLossKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Hood Loss",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoHoodLoss:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

CharTab:AddToggle("NoBurn", {
	Text = "No Burn",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            if Character then
                if Humanoid then
                    local NoBurn = function()
                        local Burning = Humanoid:FindFirstChild("Burning")
                        if Burning then
                            if Burning.Value then
                                if workspace.HumanEvents then
                                    if workspace.HumanEvents.LocalBurningEvent then
                                        workspace.HumanEvents.LocalBurningEvent:FireServer(-5, true)
                                    end
                                end
                            end
                        end
                    end
                    Connections.NoBurn = Services.RunService.RenderStepped:Connect(NoBurn)
                end
            end
        else
            if Connections.NoBurn then
                Connections.NoBurn:Disconnect()
                Connections.NoBurn = nil
            end
        end
	end,
}):AddKeyPicker("WalkspeedModifierKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Walkspeed",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoBurn:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

CharTab:AddToggle("QuickHood", {
	Text = "Quick Hood",

    Tooltip = "Allows you to quickly take off/on your hood based on your selected keybind",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)

	end,
}):AddKeyPicker("QuickHoodKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Quick Hood",
	NoUI = false,

	Callback = function(Value)
        if Value then
            if Toggles.QuickHood.Value then
                if Humanoid then
                    if workspace:WaitForChild("PlayersDataFolder")[LocalPlayer.Name].Cloak.Value == 1 then
                        if LocalPlayer.Team ~= Services.Teams["Interior Police"] then
                            if Humanoid:FindFirstChild("Hood") then
                                if Humanoid:FindFirstChild("Hood").Value == false then
                                    LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ClothesChange:InvokeServer("Hood", nil, true)
                                else
                                    LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ClothesChange:InvokeServer("Hood", nil, false)
                                end
                            end
                        else
                            return
                        end
                    end
                end
            end
        end
	end,

	ChangedCallback = function(New)

	end,
})

--// HORSE TAB

HorseBox:AddToggle("HorseGodMode", {
	Text = "God Mode",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local HorseGodMode = function()
                for _, Horse in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
                    local HorseHumanoid = Horse:FindFirstChild("Humanoid")
                    local Carriage = Horse:FindFirstChild("Carriage")
    
                    if Carriage then
                        pcall(function()
                            HorseHumanoid = Carriage.Humanoid
                        end)
                    end
    
                    if HorseHumanoid then
                        if HorseHumanoid.Health > 0 then
                            if HorseHumanoid:FindFirstChild("Owner") then
                                local HorseOwner = HorseHumanoid.Owner.Value
                                if HorseOwner == LocalPlayer.Name then
                                    if Horse:FindFirstChild("HumanoidRootPart") then
                                        if isnetworkowner then
                                            if isnetworkowner(Horse:FindFirstChild("HumanoidRootPart")) then
                                                if HorseHumanoid.Health ~= "nan" then
                                                    HorseHumanoid.Health = "nan"
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Connections.HorseGodMode = Services.RunService.RenderStepped:Connect(HorseGodMode)
        else
            if Connections.HorseGodMode then
                Connections.HorseGodMode:Disconnect()
                Connections.HorseGodMode = nil
            end
            if workspace.OnGameHorses then
                for _, Horse in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
                    local humanoid = nil
                    local owner = nil
    
                    for _, descendant in pairs(Horse:GetDescendants()) do
                        if descendant:IsA("Humanoid") then
                            humanoid = descendant
                        elseif descendant.Name == "Owner" then
                            owner = descendant
                        end
                        if humanoid and owner then
                            break
                        end
                    end
    
                    if humanoid and owner and owner.Value == LocalPlayer.Name then
                        if isnetworkowner(Horse:FindFirstChild("HumanoidRootPart")) then
                            humanoid.Health = 100
                        end
                    end
                end
            end
        end
	end,
}):AddKeyPicker("HorseGodModeKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Horse God Mode",
	NoUI = false,

	Callback = function(Value)
		Toggles.HorseGodMode:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

HorseBox:AddToggle("InfiniteHorseStamina", {
	Text = "Infinite Stamina",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local InfiniteHorseStamina = function()
                for _, Horse in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
                    local HorseHumanoid = Horse:FindFirstChild("Humanoid")
                    local Carriage = Horse:FindFirstChild("Carriage")
    
                    if Carriage then
                        pcall(function()
                            HorseHumanoid = Carriage.Humanoid
                        end)
                    end
    
                    if HorseHumanoid then
                        if HorseHumanoid.Health > 0 then
                            if HorseHumanoid:FindFirstChild("Owner") then
                                local HorseOwner = HorseHumanoid.Owner.Value
                                if HorseOwner == LocalPlayer.Name then
                                    local Config = HorseHumanoid.Parent:FindFirstChild("Configuration")
                                    if Config then
                                        local Stam = Config.Stamina

                                        if Stam and Value then
                                            Stam.Value = 4000
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Connections.InfiniteHorseStamina = Services.RunService.RenderStepped:Connect(InfiniteHorseStamina)
        else
            if Connections.InfiniteHorseStamina then
                Connections.InfiniteHorseStamina:Disconnect()
                Connections.InfiniteHorseStamina = nil
            end
        end
	end,
}):AddKeyPicker("InfiniteHorseStaminaKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Horse Stamina",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteHorseStamina:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

HorseBox:AddToggle("HorseSpeed", {
	Text = "Speed",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.HorseSpeedSlider then
			Options.HorseSpeedSlider:SetVisible(Value)
		end

        if Value then
            local HorseSpeed = function()
                for _, Horse in pairs(workspace:WaitForChild("OnGameHorses"):GetChildren()) do
                    local HorseHumanoid = Horse:FindFirstChild("Humanoid")
                    local Carriage = Horse:FindFirstChild("Carriage")
    
                    if Carriage then
                        pcall(function()
                            HorseHumanoid = Carriage.Humanoid
                        end)
                    end
    
                    if HorseHumanoid then
                        if HorseHumanoid.Health > 0 then
                            if HorseHumanoid:FindFirstChild("Owner") then
                                local HorseOwner = HorseHumanoid.Owner.Value
                                if HorseOwner == LocalPlayer.Name then
                                    local Config = HorseHumanoid.Parent:FindFirstChild("Configuration")
                                    if Config then
                                        local Speed = Config.CurrentSpeed
                                        local MaxSpeed = Config.MaxSpeed

                                        if Speed and MaxSpeed and Value then
                                            MaxSpeed.Value = Options.HorseSpeedSlider.Value
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Connections.HorseSpeed = Services.RunService.RenderStepped:Connect(HorseSpeed)
        else
            if Connections.HorseSpeed then
                Connections.HorseSpeed:Disconnect()
                Connections.HorseSpeed = nil
            end
        end
	end,
}):AddKeyPicker("HorseSpeedKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Horse Speed",
	NoUI = false,

	Callback = function(Value)
		Toggles.HorseSpeed:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

HorseBox:AddSlider("HorseSpeedSlider", {
	Text = "Speed",
	Default = 30,
	Min = 30,
	Max = 100,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})

--// MAIN TAB

MainBox:AddToggle("AntiWipe", {
	Text = "Anti Wipe",

    Tooltip = "If anti-wipe is activated you will not wipe if you happen to die",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = true,

	Callback = function(Value)
        if Value then
            local AntiWipe = function()
                if Humanoid then
                    if Humanoid.Health == 0 then
                        LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGui").ChangeTeamEvent:FireServer()
                    end
                end
            end
			Connections.AntiWipe = Services.RunService.RenderStepped:Connect(AntiWipe)
		else
			if Humanoid then
				if Connections.AntiWipe then
					Connections.AntiWipe:Disconnect()
                    Connections.AntiWipe = nil
				end
			end
        end
	end,
}):AddKeyPicker("AntiWipeKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Anti Wipe",
	NoUI = false,

	Callback = function(Value)
		Toggles.AntiWipe:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

MainBox:AddToggle("NoCannonCooldown", {
	Text = "No Cannon Cooldown",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoCannonCooldown = function()
                if Humanoid then
                    if Humanoid.SeatPart then
						if Humanoid.SeatPart.Parent.Name == "GroundCannon" or Humanoid.SeatPart.Parent.Name == "WallCannon" then
							Humanoid.SeatPart.Parent:WaitForChild("TurretControlScript"):WaitForChild("FireEvent"):InvokeServer()
						end
					else
						return
					end
                end
            end
			Connections.NoCannonCooldown = Services.UserInputService.InputBegan:Connect(function(Input, Event)
                if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Enum.KeyCode.F and not Event then
                    NoCannonCooldown()
                end
            end)
		else
			if Humanoid then
				if Connections.NoCannonCooldown then
					Connections.NoCannonCooldown:Disconnect()
                    Connections.NoCannonCooldown = nil
				end
			end
        end
	end,
}):AddKeyPicker("NoCannonCooldownKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Cannon Cooldown",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoCannonCooldown:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

MainBox:AddToggle("RemoveBarriers", {
	Text = "Remove Barriers",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        local Limits = {}

        if Value then
            Connections.BarrierAdded = workspace.DescendantAdded:Connect(function(Object)
                if Object.Name == "Limits" and Object:IsA("BasePart") and Object.Color == Color3.fromRGB(151, 0, 0) then
                    Limits[Object] = true
                end
            end)
    
            Connections.BarrierRemoved = workspace.DescendantAdded:Connect(function(Object)
                if Limits[Object] then
                    Limits[Object] = nil
                end
            end)
    
            for _, Object in pairs(workspace:GetDescendants()) do
                if Object.Name == "Limits" and Object:IsA("BasePart") and Object.Color == Color3.fromRGB(151, 0, 0) then
                    Limits[Object] = true
                end
            end

            local RemoveBarriers = function()
                for Object, _ in pairs(Limits) do
                    Object.CanCollide = not Value
                end
            end
            Connections.RemoveBarriers = Services.RunService.RenderStepped:Connect(RemoveBarriers)
        else
            if Connections.BarrierAdded then
                Connections.BarrierAdded:Disconnect()
                Connections.BarrierAdded = nil
            end

            if Connections.BarrierRemoved then
                Connections.BarrierRemoved:Disconnect()
                Connections.BarrierRemoved = nil
            end

            if Connections.RemoveBarriers then
                Connections.RemoveBarriers:Disconnect()
                Connections.RemoveBarriers = nil
            end
        end
	end,
})

MainBox:AddButton("Notify Warriors", function()
    if game.PlaceId == 11564374799 then
        local Female = nil
        local Armored = nil
        local Colossal = nil
        
        for _, Shifters in pairs(workspace:WaitForChild("WarriorsCandidatesFolder"):WaitForChild("ShifterHolders"):GetChildren()) do
            if Shifters.Name == "Female" and Shifters.Value ~= "Dead" then
                Female = "Female: " .. tostring(Shifters.Value)
            end
        
            if Shifters.Name == "Armored" and Shifters.Value ~= "Dead" then
                Armored = "Armored: " .. tostring(Shifters.Value)
            end
        
            if Shifters.Name == "Colossal" and Shifters.Value ~= "Dead" then
                Colossal = "Colossal: " .. tostring(Shifters.Value)
            end
        end
        
        local function Content()
            local content = {}
            if Female then
                table.insert(content, Female)
            end
        
            if Armored then
                table.insert(content, Armored)
            end
        
            if Colossal then
                table.insert(content, Colossal)
            end
        
            return #content > 0 and table.concat(content, "\n") or "No shifters found"
        end
        Library:Notify(Content())
    else
        Library:Notify("Must be in campaign")
    end
end)

MainBox:AddButton("Unlock Emotes", function()
    workspace.PlayersDataFolder:FindFirstChild(LocalPlayer.Name).OneArmPushUp.Value = 1
    workspace.PlayersDataFolder:FindFirstChild(LocalPlayer.Name).OneArmHandstandPushUp.Value = 1
    workspace.PlayersDataFolder:FindFirstChild(LocalPlayer.Name).NoArmsPushUp.Value = 1
    workspace.PlayersDataFolder:FindFirstChild(LocalPlayer.Name).HandstandPushUp.Value = 1
end)

MainBox:AddDivider()

MainBox:AddDropdown("TeamChanger", {
    Values = {"Soldiers", "Interior Police"},
    Default = nil,
    Multi = false,

    Tooltip = "dont use interior police unless its Stage 11 or Stage 12, if you switch to soldiers as a warrior itll make you a soldier shifter",

    Text = "Team Changer",

    Searchable = false,

    Callback = function(Value)
        if LocalPlayer.PlayerGui then
            LocalPlayer.PlayerGui:WaitForChild("LobbyGui").TeamSelectionEvent:FireServer(Value)
        end
    end,

    Disabled = false,
    Visible = true,
})

MainBox:AddDivider()

MainBox:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

MainBox:AddButton("Serverhop", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

--// SHIFTER TAB

ShifterBox:AddToggle("InfiniteShifterStamina", {
	Text = "Infinite Stamina",

    Tooltip = "Also gives you infinite stamina in human form",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local InfiniteShifterStamina = function()
                if Character then
                    if Humanoid then
                        if Humanoid:FindFirstChild("Stamina") then
                            Humanoid.Stamina.Value = 2400
                        end
                    end
                end
            end
			Connections.InfiniteShifterStamina = Services.RunService.RenderStepped:Connect(InfiniteShifterStamina)
		else
			if Humanoid then
				if Connections.InfiniteShifterStamina then
					Connections.InfiniteShifterStamina:Disconnect()
                    Connections.InfiniteShifterStamina = nil
				end
			end
        end
	end,
}):AddKeyPicker("InfiniteShifterStaminaKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Shifter Stamina",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteShifterStamina:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

ShifterBox:AddToggle("InfiniteShifterTimer", {
	Text = "Infinite Timer",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            if Character then
                if Humanoid then
                    local InfiniteShifterTimer = function()
                        if Character:FindFirstChild("Shifter") then
                            for _, Object in pairs(Character:GetDescendants()) do
                                if Object:IsA("IntValue") and Object.Name == "Time" then
                                    local ObjectClone = Object:Clone()
                                    ObjectClone.Parent = Object.Parent
                                    Object:Destroy()
                                end
                            end
                        end
                    end
                    Connections.InfiniteShifterTimer = Services.RunService.RenderStepped:Connect(InfiniteShifterTimer)
                end
            end
        else
            if Connections.InfiniteShifterTimer then
                Connections.InfiniteShifterTimer:Disconnect()
                Connections.InfiniteShifterTimer = nil
            end
        end
	end,
}):AddKeyPicker("InfiniteShifterTimerKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Infinite Timer",
	NoUI = false,

	Callback = function(Value)
		Toggles.InfiniteShifterTimer:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

ShifterBox:AddToggle("NoShifterBlind", {
	Text = "No Blind",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoShifterBlind = function()
                if Character then
                    if Humanoid then
                        if LocalPlayer.PlayerGui then
                            for _, Object in pairs(LocalPlayer.PlayerGui:WaitForChild("ShiftersGui"):GetDescendants()) do
                                if Object.Name == "LBlind" or Object.Name == "RBlind" or Object.Name == "FullBlind" then
                                    if Object.Visible == true then
                                        Object.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
			Connections.NoShifterBlind = Services.RunService.RenderStepped:Connect(NoShifterBlind)
		else
			if Humanoid then
				if Connections.NoShifterBlind then
					Connections.NoShifterBlind:Disconnect()
                    Connections.NoShifterBlind = nil
				end
			end
        end
	end,
}):AddKeyPicker("NoShifterBlindKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Blind",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoShifterBlind:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

ShifterBox:AddToggle("QuickUppercut", {
	Text = "Quick Uppercut",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)

	end,
}):AddKeyPicker("QuickUppercutKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Blind",
	NoUI = false,

	Callback = function(Value)
        if Toggles.QuickUppercut.Value then
            if Character then
                if Humanoid then
                    if Character:FindFirstChild("Shifter") then
                        for _, Object in pairs(Character:GetDescendants()) do
                            if Object:IsA("RemoteEvent") and Object.Name == "AttackEvent" then
                                Object:FireServer("AttackCombo3")
                                break
                            end
                        end
                    end
                end
            end
        end
	end,

	ChangedCallback = function(New)

	end,
})

ShifterBox:AddToggle("NoShifterStun", {
	Text = "No Stun",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local NoShifterStun = function()
                if Character then
                    if Humanoid then
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
                end
            end
			Connections.NoShifterStun = Services.RunService.RenderStepped:Connect(NoShifterStun)
		else
			if Humanoid then
				if Connections.NoShifterStun then
					Connections.NoShifterStun:Disconnect()
                    Connections.NoShifterStun = nil
				end
			end
        end
	end,
}):AddKeyPicker("NoShifterStunKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "No Blind",
	NoUI = false,

	Callback = function(Value)
		Toggles.NoShifterStun:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

--// MINDLESS HITBOXES

MindlessHitBox:AddToggle("TitanKillAura", {
	Text = "Kill Aura",
	Tooltip = "Doesn't include shifters, only mindless",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local TitanKillAura = function()
                if Character then
                    if Humanoid then
                        for _, Titan in pairs(workspace:WaitForChild("OnGameTitans"):GetChildren()) do
                            if Titan:IsA("Model") and Titan:FindFirstChild("Nape") and Titan:FindFirstChild("Humanoid") then
                                if Titan.Humanoid.Health > 0 then
                                    local distance = (Titan.Nape.Position - Character:WaitForChild("HumanoidRootPart").Position).Magnitude
                                    if distance <= 20 then
                                        if Character:FindFirstChild("Gear") then
                                            local args = {
                                                Titan.Nape,
                                                Toggles.TitanDamageModifier.Value and Options.TitanDamageModifierSlider.Value or 670,
                                                "591872138111"
                                            }
                                            
                                            Character.Gear:WaitForChild("Events"):WaitForChild("HitEvent"):FireServer(unpack(args))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
			Connections.TitanKillAura = Services.RunService.RenderStepped:Connect(TitanKillAura)
		else
			if Humanoid then
				if Connections.TitanKillAura then
					Connections.TitanKillAura:Disconnect()
                    Connections.TitanKillAura = nil
				end
			end
        end
	end,
}):AddKeyPicker("TitanKillAuraKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Titan Kill Aura",
	NoUI = false,

	Callback = function(Value)
		Toggles.TitanKillAura:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

MindlessHitBox:AddToggle("TitanDamageModifier", {
	Text = "Damage Modifier",
	Tooltip = "Doesn't include shifters, only mindless",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Options.TitanDamageModifierSlider then
			Options.TitanDamageModifierSlider:SetVisible(Value)
		end
	end,
}):AddKeyPicker("TitanDamageModifierKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Titan Damage Modifier",
	NoUI = false,

	Callback = function(Value)
		Toggles.TitanDamageModifier:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

MindlessHitBox:AddSlider("TitanDamageModifierSlider", {
	Text = "Damage",
	Default = 670,
	Min = 670,
	Max = 1200,
	Rounding = 1,
	Compact = true,

	Callback = function(Value)

	end,

	Disabled = false,
	Visible = false,
})

MindlessHitBox:AddDivider()

MindlessHitBox:AddToggle("MindlessNape", {
    Text = "Nape Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local MindlessNape = function()
                if workspace.OnGameTitans then
                    for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
                        if Titan:FindFirstChild("Humanoid") then
                            if Titan:FindFirstChild("Nape") then
                                if Titan.Humanoid.Health ~= 0 then
                                    Titan.Nape.Size = Vector3.new(Options.MindlessNapeX.Value, Options.MindlessNapeY.Value, Options.MindlessNapeZ.Value)
                                    Titan.Nape.Transparency = Options.MindlessNapeTransparency.Value
                                    Titan.Nape.BrickColor = BrickColor.new("Institutional white")
                                else
                                    Titan.Nape.Size = Vector3.new(1.762, 1.481, 0.648)
                                    Titan.Nape.Transparency = 1
                                    Titan.Nape.BrickColor = BrickColor.new("Institutional white")
                                end
                            end
                        end
                    end
                end
            end
            Connections.MindlessNape = Services.RunService.RenderStepped:Connect(MindlessNape)
        else
            if workspace.OnGameTitans then
                for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
                    if Titan:FindFirstChild("Nape") then
                        Titan.Nape.Size = Vector3.new(1.762, 1.481, 0.648)
                        Titan.Nape.Transparency = 1
                        Titan.Nape.BrickColor = BrickColor.new("Institutional white")
                    end
                end
            end
            if Connections.MindlessNape then
                Connections.MindlessNape:Disconnect()
                Connections.MindlessNape = nil
            end
        end
    end,
})

MindlessHitBox:AddSlider("MindlessNapeX", {
    Text = "X",
    Default = 1.762,
    Min = 1.762,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessNapeY", {
    Text = "Y",
    Default = 1.481,
    Min = 1.481,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessNapeZ", {
    Text = "Z",
    Default = 0.648,
    Min = 0.648,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessNapeTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddDivider()

MindlessHitBox:AddToggle("MindlessLeg", {
    Text = "Leg Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local MindlessLeg = function()
                if workspace.OnGameTitans then
                    for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
                        if Titan:FindFirstChild("TendonsLeft") and Titan:FindFirstChild("TendonsRight") then
                            if Titan:FindFirstChild("Humanoid") then
                                if Titan.Humanoid.Health ~= 0 then
                                    Titan.TendonsLeft.Size = Vector3.new(Options.MindlessLegX.Value, Options.MindlessLegY.Value, Options.MindlessLegZ.Value)
                                    Titan.TendonsLeft.Transparency = Options.MindlessLegTransparency.Value
                                    Titan.TendonsLeft.BrickColor = BrickColor.new("Institutional white")
                                    Titan.TendonsRight.Size = Vector3.new(Options.MindlessLegX.Value, Options.MindlessLegY.Value, Options.MindlessLegZ.Value)
                                    Titan.TendonsRight.Transparency = Options.MindlessLegTransparency.Value
                                    Titan.TendonsRight.BrickColor = BrickColor.new("Institutional white")
                                else
                                    Titan.TendonsLeft.Size = Vector3.new(2.865738868713379, 3.403064727783203, 1.9776231050491333)
                                    Titan.TendonsLeft.Transparency = 1
                                    Titan.TendonsLeft.BrickColor = BrickColor.new("Institutional white")
                                    Titan.TendonsRight.Size = Vector3.new(2.865738868713379, 3.403064727783203, 1.9776231050491333)
                                    Titan.TendonsRight.Transparency = 1
                                    Titan.TendonsRight.BrickColor = BrickColor.new("Institutional white")
                                end
                            end
                        end
                    end
                end
            end
            Connections.MindlessLeg = Services.RunService.RenderStepped:Connect(MindlessLeg)
        else
            if workspace.OnGameTitans then
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
            if Connections.MindlessLeg then
                Connections.MindlessLeg:Disconnect()
                Connections.MindlessLeg = nil
            end
        end
    end,
})

MindlessHitBox:AddSlider("MindlessLegX", {
    Text = "X",
    Default = 2.866,
    Min = 2.866,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessLegY", {
    Text = "Y",
    Default = 3.403,
    Min = 3.403,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessLegZ", {
    Text = "Z",
    Default = 1.978,
    Min = 1.978,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessLegTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddDivider()

MindlessHitBox:AddToggle("MindlessEye", {
    Text = "Eye Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local MindlessEye = function()
                if workspace.OnGameTitans then
                    for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
                        if Titan:FindFirstChild("Eyes")  then
                            if Titan:FindFirstChild("Humanoid") then
                                if Titan.Humanoid.Health ~= 0 then
                                    Titan.Eyes.Size = Vector3.new(Options.MindlessEyeX.Value, Options.MindlessEyeY.Value, Options.MindlessEyeZ.Value)
                                    Titan.Eyes.Transparency = Options.MindlessEyeTransparency.Value
                                    Titan.Eyes.BrickColor = BrickColor.new("Institutional white")
                                else
                                    Titan.Eyes.Size = Vector3.new(2.009599447250366, 0.5480725765228271, 1.0961451530456543)
                                    Titan.Eyes.Transparency = 1
                                    Titan.Eyes.BrickColor = BrickColor.new("Institutional white")
                                end
                            end
                        end
                    end
                end
            end
            Connections.MindlessEye = Services.RunService.RenderStepped:Connect(MindlessEye)
        else
            if workspace.OnGameTitans then
                for _, Titan in pairs(workspace.OnGameTitans:GetChildren()) do
                    if Titan:FindFirstChild("Eyes") then
                        Titan.Eyes.Size = Vector3.new(2.009599447250366, 0.5480725765228271, 1.0961451530456543)
                        Titan.Eyes.Transparency = 1
                        Titan.Eyes.BrickColor = BrickColor.new("Institutional white")
                    end
                end
            end
            if Connections.MindlessEye then
                Connections.MindlessEye:Disconnect()
                Connections.MindlessEye = nil
            end
        end
    end,
})

MindlessHitBox:AddSlider("MindlessEyeX", {
    Text = "X",
    Default = 2.01,
    Min = 2.01,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessEyeY", {
    Text = "Y",
    Default = 0.548,
    Min = 0.548,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessEyeZ", {
    Text = "Z",
    Default = 1.096,
    Min = 1.096,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

MindlessHitBox:AddSlider("MindlessEyeTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

--// SHIFTER HITBOXES

ShifterHitBox:AddToggle("ShifterNape", {
    Text = "Nape Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local ShifterNape = function()
                for _, TitanS in pairs(workspace:GetChildren()) do
                    if TitanS:FindFirstChild("Shifter") and TitanS ~= Character and not (TitanS.Name == "ArmoredTitan") then
                        local ShifterPlr = Services.Players:GetPlayerFromCharacter(TitanS)
                        if TitanS:WaitForChild("ShifterHolder").TrueTeam then
                            local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
                            if LocalPlayer.Team.Name ~= Team or LocalPlayer.Team.Name == "Rogue" or Team == "Rogue" then
                                if ShifterPlr then
                                    if TitanS:FindFirstChild("SNape") and TitanS.SNape:FindFirstChild("Armored") and not TitanS.SNape.Armored.Value then
                                        TitanS.SNape.Size = Vector3.new(Options.ShifterNapeX.Value, Options.ShifterNapeY.Value, Options.ShifterNapeZ.Value)
                                        TitanS.SNape.Transparency = Options.ShifterNapeTransparency.Value
                                        TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
                                    else
                                        TitanS.SNape.Size = Vector3.new(1.762, 1.481, 0.648)
                                        TitanS.SNape.Transparency = 1
                                        TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
                                    end
                                elseif ShifterPlr == nil then
                                    TitanS.SNape.Size = Vector3.new(1.762, 1.481, 0.648)
                                    TitanS.SNape.Transparency = 1
                                    TitanS.SNape.BrickColor = BrickColor.new("Institutional white")
                                end
                            end
                        end
                    end
                end
            end
            Connections.ShifterNape = Services.RunService.RenderStepped:Connect(ShifterNape)
        else
            for _, TitanS in pairs(workspace:GetChildren()) do
				local ShifterPlr = Services.Players:GetPlayerFromCharacter(TitanS)
				local ShifterHolder = TitanS:FindFirstChild("ShifterHolder")
				
				if ShifterHolder and ShifterHolder:FindFirstChild("TrueTeam") then
                    if ShifterHolder.TrueTeam then
                        local Team = ShifterHolder.TrueTeam.Value
                        if ShifterPlr and Team ~= LocalPlayer.Team then
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
			end
            if Connections.ShifterNape then
                Connections.ShifterNape:Disconnect()
                Connections.ShifterNape = nil
            end
        end
    end,
})

ShifterHitBox:AddSlider("ShifterNapeX", {
    Text = "X",
    Default = 1.762,
    Min = 1.762,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterNapeY", {
    Text = "Y",
    Default = 1.481,
    Min = 1.481,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterNapeZ", {
    Text = "Z",
    Default = 0.648,
    Min = 0.648,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterNapeTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddDivider()

ShifterHitBox:AddToggle("ShifterLeg", {
    Text = "Leg Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local ShifterLeg = function()
                for _, TitanS in pairs(workspace:GetChildren()) do
                    if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
                        local ShifterPlr = Services.Players:GetPlayerFromCharacter(TitanS)
                        if TitanS:WaitForChild("ShifterHolder").TrueTeam then
                            local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
                            if TitanS:FindFirstChild("RLegTendons") and TitanS:FindFirstChild("LLegTendons") then
                                if not (TitanS.Name == "ColossalTitan") then
                                    if LocalPlayer.Team.Name ~= Team or LocalPlayer.Team.Name == "Rogue" or Team == "Rogue" then
                                        if ShifterPlr then
                                            if TitanS:FindFirstChild("RLegTendons") and TitanS.RLegTendons:FindFirstChild("Armored") and not TitanS.RLegTendons.Armored.Value then
                                                TitanS.RLegTendons.Size = Vector3.new(Options.ShifterLegX.Value, Options.ShifterLegY.Value, Options.ShifterLegZ.Value)
                                                TitanS.RLegTendons.Transparency = Options.ShifterLegTransparency.Value
                                                TitanS.RLegTendons.BrickColor = BrickColor.new("Institutional white")
                                                TitanS.LLegTendons.Size = Vector3.new(Options.ShifterLegX.Value, Options.ShifterLegY.Value, Options.ShifterLegZ.Value)
                                                TitanS.LLegTendons.Transparency = Options.ShifterLegTransparency.Value
                                                TitanS.LLegTendons.BrickColor = BrickColor.new("Institutional white")
                                            else
                                                TitanS.RLegTendons.Size = Vector3.new(3.469383478164673, 3.469383478164673, 2.4444448947906494)
                                                TitanS.RLegTendons.Transparency = 1
                                                TitanS.RLegTendons.BrickColor = BrickColor.new("Institutional white")
                                                TitanS.LLegTendons.Size = Vector3.new(3.469383478164673, 3.469383478164673, 2.4444448947906494)
                                                TitanS.LLegTendons.Transparency = 1
                                                TitanS.LLegTendons.BrickColor = BrickColor.new("Institutional white")
                                            end
                                        elseif ShifterPlr == nil then
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
                end
            end
            Connections.ShifterLeg = Services.RunService.RenderStepped:Connect(ShifterLeg)
        else
			for _, TitanS in pairs(workspace:GetChildren()) do
				local ShifterPlr = Services.Players:GetPlayerFromCharacter(TitanS)
				local ShifterHolder = TitanS:FindFirstChild("ShifterHolder")
				if ShifterHolder and ShifterHolder:FindFirstChild("TrueTeam") then
					local Team = ShifterHolder.TrueTeam.Value
					if ShifterPlr and Team ~= LocalPlayer.Team then
						if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
							if TitanS:FindFirstChild("RLegTendons") and TitanS:FindFirstChild("LLegTendons") then
								local LLegTendons = TitanS:FindFirstChild("LLegTendons")
								if not TitanS:FindFirstChild("RLegTendons") and TitanS.RLegTendons:FindFirstChild("Armored") and TitanS.RLegTendons.Armored.Value then
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
            if Connections.ShifterLeg then
                Connections.ShifterLeg:Disconnect()
                Connections.ShifterLeg = nil
            end
        end
    end,
})

ShifterHitBox:AddSlider("ShifterLegX", {
    Text = "X",
    Default = 3.469,
    Min = 3.469,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterLegY", {
    Text = "Y",
    Default = 3.469,
    Min = 3.469,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterLegZ", {
    Text = "Z",
    Default = 2.444,
    Min = 2.444,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterLegTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddDivider()

ShifterHitBox:AddToggle("ShifterEye", {
    Text = "Eye Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local ShifterEye = function()
                for _, TitanS in pairs(workspace:GetChildren()) do
                    if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
                        local ShifterPlr = Services.Players:GetPlayerFromCharacter(TitanS)
                        if TitanS:FindFirstChild("ShifterHolder") then
                            if TitanS:FindFirstChild("ShifterHolder"):FindFirstChild("TrueTeam") then
                                local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
                                if TitanS:FindFirstChild("SEyes") then
                                    if LocalPlayer.Team.Name ~= Team or LocalPlayer.Team.Name == "Rogue" or Team == "Rogue" then
                                        if ShifterPlr then
                                            if TitanS:FindFirstChild("SEyes") and TitanS.SEyes:FindFirstChild("Armored") and not TitanS.SEyes.Armored.Value then
                                                TitanS.SEyes.Size = Vector3.new(Options.ShifterEyeX.Value, Options.ShifterEyeY.Value, Options.ShifterEyeZ.Value)
                                                TitanS.SEyes.Transparency = Options.ShifterEyeTransparency.Value
                                                TitanS.SEyes.BrickColor = BrickColor.new("Institutional white")
                                            else
                                                TitanS.SEyes.Size = Vector3.new(3.207543134689331, 2.0697107315063477, 2.1226646900177)
                                                TitanS.SEyes.Transparency = 1
                                                TitanS.SEyes.BrickColor = BrickColor.new("Institutional white")
                                            end
                                        elseif ShifterPlr == nil then
                                            TitanS.SEyes.Size = Vector3.new(3.207543134689331, 2.0697107315063477, 2.1226646900177)
                                            TitanS.SEyes.Transparency = 1
                                            TitanS.SEyes.BrickColor = BrickColor.new("Institutional white")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Connections.ShifterEye = Services.RunService.RenderStepped:Connect(ShifterEye)
        else
            for _, TitanS in pairs(workspace:GetChildren()) do
                if TitanS:FindFirstChild("Shifter") and TitanS ~= Character then
                    if TitanS:FindFirstChild("ShifterHolder") then
                        if TitanS:FindFirstChild("ShifterHolder"):FindFirstChild("TrueTeam") then
                            local Team = TitanS:WaitForChild("ShifterHolder").TrueTeam.Value
                            if TitanS:FindFirstChild("SEyes") then
                                if LocalPlayer.Team.Name ~= Team or LocalPlayer.Team.Name == "Rogue" or Team == "Rogue" then
                                    TitanS.SEyes.Size = Vector3.new(3.207543134689331, 2.0697107315063477, 2.1226646900177)
                                    TitanS.SEyes.Transparency = 1
                                    TitanS.SEyes.BrickColor = BrickColor.new("Institutional white")
                                end
                            end
                        end
                    end
                end
			end
            if Connections.ShifterEye then
                Connections.ShifterEye:Disconnect()
                Connections.ShifterEye = nil
            end
        end
    end,
})

ShifterHitBox:AddSlider("ShifterEyeX", {
    Text = "X",
    Default = 3.208,
    Min = 3.208,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterEyeY", {
    Text = "Y",
    Default = 2.07,
    Min = 2.07,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterEyeZ", {
    Text = "Z",
    Default = 2.123,
    Min = 2.123,
    Max = 100,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

ShifterHitBox:AddSlider("ShifterEyeTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

--// HUMAN HITBOXES

HumanBox:AddToggle("Human", {
    Text = "Hitbox",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
        if Value then
            local Human = function()
                local isLocalPlayerWarrior = false
                if workspace:WaitForChild("PlayersDataFolder"):FindFirstChild(LocalPlayer.Name) and workspace.PlayersDataFolder[LocalPlayer.Name]:FindFirstChild("Warrior") then
                    isLocalPlayerWarrior = workspace.PlayersDataFolder[LocalPlayer.Name].Warrior.Value
                end
                
                for _, Victim in pairs(Services.Players:GetPlayers()) do
                    if Victim ~= LocalPlayer and Victim.Character and not Victim.Character:FindFirstChild("Shifter") then
                        local HumanoidRootPart = Victim.Character:FindFirstChild("HumanoidRootPart")
                        local Hitbox = HumanoidRootPart and HumanoidRootPart:FindFirstChild("BulletsHitbox")
                        if Hitbox then
                            local isVictimWarrior = false
                            if workspace.PlayersDataFolder:FindFirstChild(Victim.Name) and workspace.PlayersDataFolder[Victim.Name]:FindFirstChild("Warrior") then
                                isVictimWarrior = workspace.PlayersDataFolder[Victim.Name].Warrior.Value
                            end
                            
                            local Humanoid = Victim.Character:FindFirstChild("Humanoid")
                            local Grabbed = Humanoid and Humanoid:FindFirstChild("Grabbed")
                            
                            if Humanoid and Grabbed and Grabbed:IsA("BoolValue") and Grabbed.Value then
                                Hitbox.Size = Vector3.new(3, 3, 2)
                                Hitbox.Transparency = 1
                                Hitbox.BrickColor = BrickColor.new("Institutional white")
                                Hitbox.Shape = Enum.PartType.Block
                            elseif (Victim.Team.Name ~= LocalPlayer.Team.Name or LocalPlayer.Team.Name == "Rogue" or Victim.Team.Name == "Rogue") and (not isLocalPlayerWarrior or not isVictimWarrior) then
                                Hitbox.Size = Vector3.new(Options.HumanSize.Value, Options.HumanSize.Value, Options.HumanSize.Value)
                                Hitbox.Transparency = Options.HumanTransparency.Value
                                Hitbox.BrickColor = BrickColor.new("Institutional white")
                                Hitbox.Shape = Enum.PartType.Ball
                            else
                                Hitbox.Size = Vector3.new(3, 3, 2)
                                Hitbox.Transparency = 1
                                Hitbox.BrickColor = BrickColor.new("Institutional white")
                                Hitbox.Shape = Enum.PartType.Block
                            end
                        end
                    end
                end
            end
            Connections.Human = Services.RunService.RenderStepped:Connect(Human)
        else
            for _, Victim in pairs(Services.Players:GetPlayers()) do
				if Victim.Character and not Victim.Character:FindFirstChild("Shifter") then
                    if Victim.Character:FindFirstChild("HumanoidRootPart") then
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
            if Connections.Human then
                Connections.Human:Disconnect()
                Connections.Human = nil
            end
        end
    end,
})

HumanBox:AddSlider("HumanSize", {
    Text = "Size",
    Default = 3,
    Min = 3,
    Max = 30,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

HumanBox:AddSlider("HumanTransparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

--// VISUAL TAB

--// PLAYERS

VisualLibrary.Settings.TeamColor = false
VisualLibrary.Settings.Boxes = false
VisualLibrary.Settings.Tracers = false
VisualLibrary.Settings.Distance = false
VisualLibrary.Settings.HealthText = false
VisualLibrary.Settings.HealthBar = false
VisualLibrary.Settings.Names = false

PlayerVisual:AddToggle("PlayerVisualEnable", {
	Text = "Player ESP",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary:Toggle(Value)
	end,
}):AddKeyPicker("PlayerVisualEnableKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Player ESP",
	NoUI = false,

	Callback = function(Value)
		Toggles.PlayerVisualEnable:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

PlayerVisual:AddSlider("PlayerVisualMaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 1000,
    Max = 10000,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        VisualLibrary.Settings.MaxDistance = Value
    end,

    Disabled = false,
    Visible = true,
})

PlayerVisual:AddDivider()

PlayerVisual:AddCheckbox("PlayerVisualNames", {
	Text = "Names",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.Names = Value
	end,
}):AddColorPicker("PlayerVisualBoxesColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Color",
	Transparency = 0,

	Callback = function(Value)
		VisualLibrary.Settings.NameColor = Value
	end,
})

PlayerVisual:AddCheckbox("PlayerVisualTeamColor", {
	Text = "Team Color",
	Tooltip = "Instead of just friendly & enemy colors it shows team colors",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.TeamColor = Value
	end,
})

PlayerVisual:AddCheckbox("PlayerVisualBoxes", {
	Text = "Boxes",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.Boxes = Value
	end,
}):AddColorPicker("PlayerVisualBoxesColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Color",
	Transparency = 0,

	Callback = function(Value)
		VisualLibrary.Settings.BoxColor = Value
	end,
})

PlayerVisual:AddCheckbox("PlayerVisualTracers", {
	Text = "Tracers",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.Tracers = Value
	end,
}):AddColorPicker("PlayerVisualTracersColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Color",
	Transparency = 0,

	Callback = function(Value)
		VisualLibrary.Settings.TracerColor = Value
	end,
})

PlayerVisual:AddCheckbox("PlayerVisualDistance", {
	Text = "Distance",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.Distance = Value
	end,
})

PlayerVisual:AddDivider()

PlayerVisual:AddCheckbox("PlayerVisualHealthText", {
	Text = "Health Text",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.HealthText = Value
	end,
})

PlayerVisual:AddCheckbox("PlayerVisualHealthBar", {
	Text = "Health Bar",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.HealthBar = Value
	end,
})

PlayerVisual:AddDivider()

PlayerVisual:AddCheckbox("PlayerVisualChams", {
	Text = "Chams",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        VisualLibrary.Settings.Chams = Value
	end,
}):AddColorPicker("PlayerVisualChamsColor", {
	Default = Color3.fromRGB(255, 0, 0),
	Title = "Color",
	Transparency = 0,

	Callback = function(Value)
		VisualLibrary.Settings.ChamsColor = Value
	end,
})

PlayerVisual:AddSlider("PlayerVisualChamsTransparency", {
    Text = "Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        VisualLibrary.Settings.ChamsTransparency = Value
    end,

    Disabled = false,
    Visible = true,
})

-- TITANS

local TitanInstances = {}

TitanVisual:AddToggle("TitanVisualEnable", {
	Text = "Titan ESP",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            if Workspace:FindFirstChild("OnGameTitans") then
                for _, Titan in pairs(workspace:WaitForChild("OnGameTitans", 5):GetChildren()) do
                    if Titan:IsA("Model") then
                        local TitanObject = VisualLibrary:AddObjectListener(Titan, {
                            Name = Titan.Name,
                            NameColor = Color3.fromRGB(255, 255, 255),
                            Distance = true
                        })
                        TitanInstances[Titan] = TitanObject
                    end
                end

                Connections.TitanESP = workspace:WaitForChild("OnGameTitans", 5).ChildAdded:Connect(function(Titan)
                    if Titan:IsA("Model") then
                        local TitanObject = VisualLibrary:AddObjectListener(Titan, {
                            Name = Titan.Name,
                            NameColor = Color3.fromRGB(255, 255, 255),
                            Distance = true
                        })
                        TitanInstances[Titan] = TitanObject
                    end
                end)
            end
        else
            if Connections.TitanESP then
                Connections.TitanESP:Disconnect()
                Connections.TitanESP = nil
            end
            for _, Object in pairs(TitanInstances) do
				Object:Destroy()
			end
        end
	end,
}):AddKeyPicker("TitanVisualEnableKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Player ESP",
	NoUI = false,

	Callback = function(Value)
		Toggles.TitanVisualEnable:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

TitanVisual:AddDivider()

-- CARTS

local CartInstances = {}

CartVisual:AddToggle("CartVisualEnable", {
	Text = "Cart ESP",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            if Workspace:FindFirstChild("OnGameHorses") then
                for _, Cart in pairs(workspace:WaitForChild("OnGameHorses", 5):GetChildren()) do
                    if Cart:IsA("Model") then
                        if string.find(Cart.Name, "Carriage") then
                            local CartObject = VisualLibrary:AddObjectListener(Cart, {
                                Name = Cart:WaitForChild("Carriage"):WaitForChild("Humanoid"):WaitForChild("Type").Value,
                                NameColor = Color3.fromRGB(255, 255, 255),
                                Distance = true,
                                Boxes = false,
                            })
                            CartInstances[Cart] = CartObject
                        end
                    end
                end

                Connections.CartESP = workspace:WaitForChild("OnGameHorses", 5).ChildAdded:Connect(function(Cart)
                    if Cart:IsA("Model") then
                        if string.find(Cart.Name, "Carriage") then
                            local CartObject = VisualLibrary:AddObjectListener(Cart, {
                                Name = Cart:WaitForChild("Carriage"):WaitForChild("Humanoid"):WaitForChild("Type").Value,
                                NameColor = Color3.fromRGB(255, 255, 255),
                                Distance = true,
                                Boxes = false,
                            })
                            CartInstances[Cart] = CartObject
                        end
                    end
                end)
            end
        else
            if Connections.CartESP then
                Connections.CartESP:Disconnect()
                Connections.CartESP = nil
            end
            for _, Object in pairs(CartInstances) do
				Object:Destroy()
			end
        end
	end,
}):AddKeyPicker("CartVisualNames", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Player ESP",
	NoUI = false,

	Callback = function(Value)
		Toggles.CartVisualEnable:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

--// FLARE TAB

FlareBox:AddToggle("FlareSpam", {
	Text = "Flare Spam",
    Tooltip = "You must have equipped the flare at least once to use this. The flare's position resets when you re-equip it.",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local FlareSpam = function()
                if Character then
                    if Humanoid then
                        local FlareEvent: RemoteEvent = Services.ReplicatedStorage:FindFirstChild("FlareGunEvents") and Services.ReplicatedStorage.FlareGunEvents:FindFirstChild("FlareEvent")
                        local Flare: Tool = LocalPlayer and LocalPlayer.Backpack:FindFirstChild("Flare") or Character:FindFirstChild("Flare")
                
                        for Index, Value in next, Options.FlareSpamColors.Value do
                            if Value == true then
                                if Index == "Red " then
                                    FlareEvent:FireServer("Red", "Fire", Flare)
                                else
                                    FlareEvent:FireServer(Index, "Fire", Flare)
                                end
                            end
                        end
                    end
                end
            end
			Connections.FlareSpam = Services.RunService.RenderStepped:Connect(FlareSpam)
		else
			if Humanoid then
				if Connections.FlareSpam then
					Connections.FlareSpam:Disconnect()
                    Connections.FlareSpam = nil
				end
			end
        end
	end,
}):AddKeyPicker("FlareSpamKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Flare Spam",
	NoUI = false,

	Callback = function(Value)
		Toggles.FlareSpam:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

FlareBox:AddDropdown("FlareSpamColors", {
    Values = { "Green", "Black", "Yellow", "Blue", "Purple", "Red " },
    Default = nil,
    Multi = true,

    Text = "Colors",

    Searchable = false,

    Callback = function(Value)

    end,

    Disabled = false,
    Visible = true,
})

FlareBox:AddButton("Reset Flare Position", function()
    local Flare: Tool = LocalPlayer and LocalPlayer.Backpack:FindFirstChild("Flare")

    if Flare and Humanoid then
        Humanoid:EquipTool(Flare)
        task.wait(0.25)
        Humanoid:UnequipTools()
    end
end)

FlareBox:AddToggle("FlareSpamResetConstant", {
	Text = "Constant Pos Reset",
    Tooltip = "Spam reset's the flare position",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        if Value then
            local FlareSpamResetConstant = function()
                if Character then
                    if Humanoid then
                        local Flare: Tool = LocalPlayer and LocalPlayer.Backpack:FindFirstChild("Flare")
            
                        if Flare and Humanoid then
                            Humanoid:EquipTool(Flare)
            
                            if Options.HideFlareGUIToggle and Options.HideFlareGUIToggle.Value then
                                local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                if PlayerGui then
                                    local Menu = PlayerGui:FindFirstChild("FlareGunGui")
                                    if Menu and Menu.Enabled then
                                        Menu.Enabled = false
                                    end
                                end
                            end
    
                            task.wait(0.1)
                            Humanoid:UnequipTools()
                        end
                    end
                end
            end
			Connections.FlareSpamResetConstant = Services.RunService.RenderStepped:Connect(FlareSpamResetConstant)
		else
			if Humanoid then
				if Connections.FlareSpamResetConstant then
					Connections.FlareSpamResetConstant:Disconnect()
                    Connections.FlareSpamResetConstant = nil
				end
			end
        end
	end,
}):AddKeyPicker("FlareSpamResetConstantKey", {
	Default = nil,
	SyncToggleState = false,

	Mode = "Toggle",

	Text = "Constant Flare Reset",
	NoUI = false,

	Callback = function(Value)
		Toggles.FlareSpamResetConstant:SetValue(Value)
	end,

	ChangedCallback = function(New)

	end,
})

FlareBox:AddToggle("HideFlareGUIToggle", {
	Text = "Hide Flare GUI",
    Tooltip = "Hide's the flare color menu, helpful if you are using spam reset.",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
	end,
})

--// ANIMATION TAB

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
    ["Air Guitar"] = 3695300085,
	["Robot"] = 3338025566,
	["Twirl"] = 3334968680,
	["Idol"] = 4101966434,
	["Haha"] = 3337966527,
	["Salute"] = 3333474484,
	["Hello"] = 3344650532,
	["Shrug"] = 3334392772,
    ["Cha Cha"] = 3695322025,
    ["Ud'zal's Summoning"] = 3303161675,
	["Point2"] = 3344585679,
	["Tilt"] = 3334538554,
	["Pushups"] = 17124634317,
    ["Celebrate"] = 3338097973,
	["Crawler"] = 6807728809,
	["Hype"] = 3695333486,
	["Spinner"] = 7921684457,
	["Jaw Run"] = 7018026891,
    ["Chicken Dance"] = 4841399916,
	["Yoga"] = 7466046574,
}

local CurrentAnimations = {}

AnimationBox:AddButton("Stop Animation", function()
    for _, track in ipairs(CurrentAnimations) do
        track:Stop()
    end
end)

AnimationBox:AddSlider("AnimationSpeed", {
    Text = "Speed",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        for _, track in ipairs(CurrentAnimations) do
			track:AdjustSpeed(Value)
		end
    end,

    Disabled = false,
    Visible = true,
})

AnimationBox:AddDivider()

local AnimationNames = {}

for AnimationName, _ in pairs(Animations) do
    table.insert(AnimationNames, AnimationName)
end

AnimationBox:AddDropdown("Animations", {
    Values = AnimationNames,
    Default = nil,
    Multi = false,

    Text = nil,

    Searchable = true,

    Callback = function(Value)
        local AnimationID = Animations[Value]
        if AnimationID and Humanoid ~= nil then
            for _, track in ipairs(CurrentAnimations) do
                track:Stop()
            end
            CurrentAnimations = {}

            local animator = Humanoid:FindFirstChildOfClass("Animator")

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. AnimationID

            local animationTrack = animator:LoadAnimation(animation)
            table.insert(CurrentAnimations, animationTrack)
            animationTrack:Play()

            animationTrack:AdjustSpeed(Options.AnimationSpeed.Value)
        end
    end,

    Disabled = false,
    Visible = true,
})

--// OTHER

local RemoteHook 
RemoteHook = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    local Arguments = {...}
    local Type = getnamecallmethod()

    if (Type == "FireServer" or Type == "InvokeServer") and (self.Name == "OnDeadEvent" or self.Name == "DeadEvent") and Toggles.AntiWipe.Value then
        if game.PlaceId == 11564374799 then
            if Character then
                if Humanoid then
                    if Character:FindFirstChild("ShifterHolder") then
                        return RemoteHook(self, unpack(Arguments))
                    else
                        return
                    end
                end
            else
                return RemoteHook(self, unpack(Arguments))
            end
        else
            return
        end
        return
    end

    if (Type == "FireServer") and (self.Name == "HitEvent") and Toggles.TitanDamageModifier.Value then
        Arguments[2] = Options.TitanDamageModifierSlider.Value
        return RemoteHook(self, unpack(Arguments))
    end

    if Type:lower() == "kick" and self == LocalPlayer then
        return
    end

    return RemoteHook(self, ...)
end))

Services.Players.PlayerRemoving:Connect(function(OtherPlayer)
	if OtherPlayer == Player then
		if Toggles.LoadMenuTeleport.Value then
            if queue_on_teleport then

            end
		end
	end
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("LoadMenuTeleport", {
	Default = false,
	Text = "Load Menu On Teleport",
	Callback = function(value)
		
	end,
})
MenuGroup:AddToggle("MenuNotifications", {
	Default = true,
	Text = "Menu Notifications",
	Callback = function(value)
		
	end,
})

local Staff = {
    5052488353, -- Owner / DankAlert8866
    3891230967, -- Developer / roub3D
    923860344, -- Developer / Orange {SUNSET_TGER}
    989251425, -- Head Staff / ZombieWombies
    563460081, -- Head Administrator / ValeriusLin
    39716623, -- Administrator / trentonbuijdujc
    3349285656, -- Administrator / Senuvaltrec
    320954812, -- Administrator / Chaku {bayrakenes}
    2664727049, -- Administrator / Wateredowntea
    179625166, -- Administrator / Noymless
    1218375944, -- Senior Moderator / AwesomeBrannon4567
    291309580, -- Senior Moderator / chuiiaq
}

MenuGroup:AddToggle("StaffNotifications", {
	Default = true,
	Text = "Staff Notifications",
    Tooltip = "Notifies you if a staff member joins your server",
	Callback = function(value)
		if Value then
            Connections.StaffNotifications = Services.Players.PlayerAdded:Connect(function(Player)
                if table.find(Staff, Player.UserId) then
                    Library:Notify("Staff Member " .. Player.Name .. " has joined")
                end
            end)
        else
            if Connections.StaffNotifications then
                Connections.StaffNotifications:Disconnect()
                Connections.StaffNotifications = nil
            end
		end
	end,
})

task.spawn(function()
    for _, Player in pairs(Services.Players:GetPlayers()) do
        if table.find(Staff, Player.UserId) then
            Library:Notify("Staff Member " .. Player.Name .. " is in this server")
        end
    end
end)

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { Default = "KeypadEight", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    for _, Connection in pairs(Connections) do
        Connection:Disconnect()
    end
    if odmHookFunction and odmHookOne and odmHookTwo then
        debug.setconstant(odmHookFunction, odmHookOne, 400)
        debug.setconstant(odmHookFunction, odmHookTwo, 200)
    end
    for _, track in ipairs(CurrentAnimations) do
        track:Stop()
    end
    VisualLibrary:Unload()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind
Library.ShowCustomCursor = false

for _, Option in pairs(Toggles) do
    Option:OnChanged(function()
        if Toggles.MenuNotifications.Value then
            local Status = Option.Value
            if Status == true then
                Status = "Enabled"
            elseif Status == false then
                Status = "Disabled"
            end
            Library:Notify(Option.Text .. " has been " .. Status)
        end
    end)
end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Tear")
SaveManager:SetFolder("Tear/FreedomWar")
SaveManager:SetSubFolder("FreedomWar")

SaveManager:BuildConfigSection(Tabs["UI Settings"])

ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()
