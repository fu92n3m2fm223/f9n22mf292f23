local ESP = {
    Enabled = false,
    Players = {},
    Objects = {},
    Settings = {
        TeamCheck = false,
        TeamColor = true,
        Boxes = true,
        BoxColor = Color3.fromRGB(255, 0, 0),
        BoxTransparency = 0.5,
        Names = true,
        NameColor = Color3.fromRGB(255, 255, 255),
        NameTransparency = 1,
        NameSize = 13,
        HealthBar = true,
        HealthText = true,
        Tracers = false,
        TracerColor = Color3.fromRGB(255, 255, 255),
        MaxDistance = 1000,
        TextFont = 2,
        TextOutline = true,
        TextOutlineColor = Color3.fromRGB(0, 0, 0)
    },
    _settingsVersion = 0
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Helper functions
local function GetTeamColor(player)
    return player and player.Team and player.Team.TeamColor and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
end

local function IsTeamMate(player)
    if not ESP.Settings.TeamCheck then return false end
    return player and LocalPlayer and player.Team == LocalPlayer.Team
end

local function WorldToViewport(position)
    if not Camera then return Vector2.new(), false, 0 end
    local vector, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(vector.X, vector.Y), onScreen, vector.Z
end

local function GetCharacter(player)
    return player and (player.Character or player.CharacterAdded:Wait())
end

local function GetHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetBodyParts(character)
    local parts = {}
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

local function GetBoundingBox(parts)
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    
    for _, part in pairs(parts) do
        if part and part:IsA("BasePart") then
            local cf = part.CFrame
            local size = part.Size
            
            local corners = {
                cf * Vector3.new(size.X/2, size.Y/2, size.Z/2),
                cf * Vector3.new(-size.X/2, size.Y/2, size.Z/2),
                cf * Vector3.new(size.X/2, -size.Y/2, size.Z/2),
                cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                cf * Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2)
            }
            
            for _, corner in pairs(corners) do
                if corner.X < minX then minX = corner.X end
                if corner.Y < minY then minY = corner.Y end
                if corner.Z < minZ then minZ = corner.Z end
                if corner.X > maxX then maxX = corner.X end
                if corner.Y > maxY then maxY = corner.Y end
                if corner.Z > maxZ then maxZ = corner.Z end
            end
        end
    end
    
    local min = Vector3.new(minX, minY, minZ)
    local max = Vector3.new(maxX, maxY, maxZ)
    local center = (min + max) / 2
    local size = max - min
    
    return center, size
end

-- ESP Object class
local ESPObject = {}
ESPObject.__index = ESPObject

function ESPObject.new(player)
    local self = setmetatable({}, ESPObject)
    self.Player = player
    self.Drawings = {}
    self.Connections = {}
    self.Enabled = true
    self.LastSettingsVersion = 0
    
    self:InitializeDrawings()
    
    local function OnCharacterAdded(character)
        if not character then return end
        
        local humanoid = GetHumanoid(character)
        if not humanoid then return end
        
        local function Update()
            if not ESP.Enabled or not self.Enabled or not self.Player or not self.Player.Character then
                self:Hide()
                return
            end
            
            -- Check if settings changed
            if self.LastSettingsVersion ~= ESP._settingsVersion then
                self:UpdateDrawingsStructure()
                self.LastSettingsVersion = ESP._settingsVersion
            end
            
            local currentCharacter = self.Player.Character
            local currentHumanoid = GetHumanoid(currentCharacter)
            
            if not currentHumanoid or currentHumanoid.Health <= 0 then
                self:Hide()
                return
            end
            
            if IsTeamMate(self.Player) then
                self:Hide()
                return
            end
            
            local parts = GetBodyParts(currentCharacter)
            if #parts == 0 then
                self:Hide()
                return
            end
            
            local center, size = GetBoundingBox(parts)
            local topLeft, onScreen, distance = WorldToViewport(center + Vector3.new(-size.X/2, size.Y/2, 0))
            local bottomRight = WorldToViewport(center + Vector3.new(size.X/2, -size.Y/2, 0))
            
            if not onScreen or distance > ESP.Settings.MaxDistance then
                self:Hide()
                return
            end
            
            self:UpdateDrawings(topLeft, bottomRight, currentHumanoid)
        end
        
        table.insert(self.Connections, humanoid.Died:Connect(function()
            self:Hide()
        end))
        
        table.insert(self.Connections, humanoid:GetPropertyChangedSignal("Health"):Connect(Update))
        
        table.insert(self.Connections, RunService.Heartbeat:Connect(Update))
    end
    
    table.insert(self.Connections, player.CharacterAdded:Connect(OnCharacterAdded))
    
    if player.Character then
        OnCharacterAdded(player.Character)
    end
    
    return self
end

function ESPObject:InitializeDrawings()
    if ESP.Settings.Boxes then
        self.Drawings.BoxOutline = Drawing.new("Square")
        self.Drawings.BoxOutline.Thickness = 2
        self.Drawings.BoxOutline.Filled = false
        self.Drawings.BoxOutline.Visible = false
        self.Drawings.BoxOutline.ZIndex = 2
        
        self.Drawings.Box = Drawing.new("Square")
        self.Drawings.Box.Thickness = 1
        self.Drawings.Box.Filled = false
        self.Drawings.Box.Visible = false
        self.Drawings.Box.ZIndex = 3
    end
    
    if ESP.Settings.Names then
        self.Drawings.Name = Drawing.new("Text")
        self.Drawings.Name.Center = true
        self.Drawings.Name.Outline = ESP.Settings.TextOutline
        self.Drawings.Name.OutlineColor = ESP.Settings.TextOutlineColor
        self.Drawings.Name.Size = ESP.Settings.NameSize
        self.Drawings.Name.Font = ESP.Settings.TextFont
        self.Drawings.Name.Visible = false
        self.Drawings.Name.ZIndex = 4
    end
    
    if ESP.Settings.HealthBar then
        self.Drawings.HealthBarOutline = Drawing.new("Square")
        self.Drawings.HealthBarOutline.Thickness = 1
        self.Drawings.HealthBarOutline.Filled = false
        self.Drawings.HealthBarOutline.Visible = false
        self.Drawings.HealthBarOutline.ZIndex = 1
        
        self.Drawings.HealthBar = Drawing.new("Square")
        self.Drawings.HealthBar.Thickness = 1
        self.Drawings.HealthBar.Filled = true
        self.Drawings.HealthBar.Visible = false
        self.Drawings.HealthBar.ZIndex = 2
    end
    
    if ESP.Settings.HealthText then
        self.Drawings.HealthText = Drawing.new("Text")
        self.Drawings.HealthText.Center = true
        self.Drawings.HealthText.Outline = ESP.Settings.TextOutline
        self.Drawings.HealthText.OutlineColor = ESP.Settings.TextOutlineColor
        self.Drawings.HealthText.Size = ESP.Settings.NameSize - 2
        self.Drawings.HealthText.Font = ESP.Settings.TextFont
        self.Drawings.HealthText.Visible = false
        self.Drawings.HealthText.ZIndex = 4
    end
    
    if ESP.Settings.Tracers then
        self.Drawings.Tracer = Drawing.new("Line")
        self.Drawings.Tracer.Thickness = 1
        self.Drawings.Tracer.Visible = false
        self.Drawings.Tracer.ZIndex = 1
    end
end

function ESPObject:UpdateDrawingsStructure()
    -- Clean up old drawings
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing:Remove()
        end
    end
    
    self.Drawings = {}
    self:InitializeDrawings()
end

function ESPObject:UpdateDrawings(topLeft, bottomRight, humanoid)
    local boxSize = bottomRight - topLeft
    local boxPosition = topLeft
    
    if self.Drawings.Box and ESP.Settings.Boxes then
        local color = ESP.Settings.TeamColor and GetTeamColor(self.Player) or ESP.Settings.BoxColor
        
        self.Drawings.BoxOutline.Position = boxPosition
        self.Drawings.BoxOutline.Size = boxSize
        self.Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
        self.Drawings.BoxOutline.Visible = true
        
        self.Drawings.Box.Position = boxPosition
        self.Drawings.Box.Size = boxSize
        self.Drawings.Box.Color = color
        self.Drawings.Box.Transparency = ESP.Settings.BoxTransparency
        self.Drawings.Box.Visible = true
    else
        if self.Drawings.BoxOutline then self.Drawings.BoxOutline.Visible = false end
        if self.Drawings.Box then self.Drawings.Box.Visible = false end
    end
    
    if self.Drawings.Name and ESP.Settings.Names then
        self.Drawings.Name.Text = self.Player.Name
        self.Drawings.Name.Position = boxPosition + Vector2.new(boxSize.X/2, -self.Drawings.Name.TextBounds.Y - 2)
        self.Drawings.Name.Color = ESP.Settings.NameColor
        self.Drawings.Name.Transparency = ESP.Settings.NameTransparency
        self.Drawings.Name.Visible = true
    else
        if self.Drawings.Name then self.Drawings.Name.Visible = false end
    end
    
    if self.Drawings.HealthBar and ESP.Settings.HealthBar and humanoid then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local healthBarHeight = boxSize.Y * healthPercent
        local healthBarPosition = boxPosition + Vector2.new(-6, boxSize.Y - healthBarHeight)
        local healthBarSize = Vector2.new(2, healthBarHeight)
        
        self.Drawings.HealthBarOutline.Position = healthBarPosition - Vector2.new(1, 0)
        self.Drawings.HealthBarOutline.Size = healthBarSize + Vector2.new(2, 0)
        self.Drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)
        self.Drawings.HealthBarOutline.Visible = true
        
        self.Drawings.HealthBar.Position = healthBarPosition
        self.Drawings.HealthBar.Size = healthBarSize
        self.Drawings.HealthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
        self.Drawings.HealthBar.Visible = true
    else
        if self.Drawings.HealthBarOutline then self.Drawings.HealthBarOutline.Visible = false end
        if self.Drawings.HealthBar then self.Drawings.HealthBar.Visible = false end
    end
    
    if self.Drawings.HealthText and ESP.Settings.HealthText and humanoid then
        self.Drawings.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        self.Drawings.HealthText.Position = boxPosition + Vector2.new(boxSize.X + 10, boxSize.Y/2)
        self.Drawings.HealthText.Color = ESP.Settings.NameColor
        self.Drawings.HealthText.Visible = true
    else
        if self.Drawings.HealthText then self.Drawings.HealthText.Visible = false end
    end
    
    if self.Drawings.Tracer and ESP.Settings.Tracers then
        self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        self.Drawings.Tracer.To = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y)
        self.Drawings.Tracer.Color = ESP.Settings.TracerColor
        self.Drawings.Tracer.Visible = true
    else
        if self.Drawings.Tracer then self.Drawings.Tracer.Visible = false end
    end
end

function ESPObject:Hide()
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing.Visible = false
        end
    end
end

function ESPObject:Destroy()
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing:Remove()
        end
    end
    
    self.Connections = {}
    self.Drawings = {}
end

function ESP:Toggle(state)
    self.Enabled = state
    for _, obj in pairs(self.Objects) do
        if obj then
            obj.Enabled = state
            if not state then
                obj:Hide()
            end
        end
    end
end

function ESP:PlayerAdded(player)
    if player == LocalPlayer then return end
    local obj = ESPObject.new(player)
    table.insert(self.Objects, obj)
end

function ESP:PlayerRemoving(player)
    for i, obj in pairs(self.Objects) do
        if obj and obj.Player == player then
            obj:Destroy()
            table.remove(self.Objects, i)
            break
        end
    end
end

function ESP:UpdateSettings()
    self._settingsVersion = self._settingsVersion + 1
end

function ESP:Initialize()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:PlayerAdded(player)
        end
    end
    
    self.PlayerAddedConn = Players.PlayerAdded:Connect(function(player)
        self:PlayerAdded(player)
    end)
    
    self.PlayerRemovingConn = Players.PlayerRemoving:Connect(function(player)
        self:PlayerRemoving(player)
    end)
    
    -- Create metatable for Settings to detect changes
    local settingsMeta = {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            ESP:UpdateSettings()
        end
    }
    
    setmetatable(self.Settings, settingsMeta)
end

function ESP:Unload()
    if self.PlayerAddedConn then
        self.PlayerAddedConn:Disconnect()
    end
    
    if self.PlayerRemovingConn then
        self.PlayerRemovingConn:Disconnect()
    end
    
    for _, obj in pairs(self.Objects) do
        if obj then
            obj:Destroy()
        end
    end
    
    self.Objects = {}
end

ESP:Initialize()

return ESP
