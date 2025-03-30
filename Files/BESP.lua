local ESP = {
    Enabled = false,
    Players = {},
    Objects = {},
    CustomObjects = {},
    CustomSettings = {
        Boxes = true,
        BoxColor = Color3.fromRGB(255, 255, 0),
        BoxTransparency = 0.5,
        Name = "Object",
        NameColor = Color3.fromRGB(255, 255, 255),
        NameTransparency = 1,
        NameSize = 13,
        ShowDistance = true,
        HealthBar = false,
        Tracers = false,
        TracerColor = Color3.fromRGB(255, 255, 255)
    }
}

local settingsMetatable = {
    __newindex = function(self, key, value)
        rawset(self, key, value)
        if ESP.Enabled then
            for _, obj in pairs(ESP.Objects) do
                if obj and obj.Update then
                    coroutine.wrap(obj.Update)()
                end
            end
            for _, obj in pairs(ESP.CustomObjects) do
                if obj and obj.Update then
                    coroutine.wrap(obj.Update)()
                end
            end
        end
    end
}

ESP.Settings = setmetatable({
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
}, settingsMetatable)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

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

local ESPObject = {}
ESPObject.__index = ESPObject

function ESPObject.new(player)
    local self = setmetatable({}, ESPObject)
    self.Player = player
    self.Drawings = {}
    self.Connections = {}
    
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
    
    self.Drawings.Name = Drawing.new("Text")
    self.Drawings.Name.Center = true
    self.Drawings.Name.Outline = ESP.Settings.TextOutline
    self.Drawings.Name.OutlineColor = ESP.Settings.TextOutlineColor
    self.Drawings.Name.Size = ESP.Settings.NameSize
    self.Drawings.Name.Font = ESP.Settings.TextFont
    self.Drawings.Name.Visible = false
    self.Drawings.Name.ZIndex = 4
    
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
    
    self.Drawings.HealthText = Drawing.new("Text")
    self.Drawings.HealthText.Center = true
    self.Drawings.HealthText.Outline = ESP.Settings.TextOutline
    self.Drawings.HealthText.OutlineColor = ESP.Settings.TextOutlineColor
    self.Drawings.HealthText.Size = ESP.Settings.NameSize - 2
    self.Drawings.HealthText.Font = ESP.Settings.TextFont
    self.Drawings.HealthText.Visible = false
    self.Drawings.HealthText.ZIndex = 4
    
    self.Drawings.Tracer = Drawing.new("Line")
    self.Drawings.Tracer.Thickness = 1
    self.Drawings.Tracer.Visible = false
    self.Drawings.Tracer.ZIndex = 1
    
    local function Update()
        if not ESP.Enabled or not self.Player or not self.Player.Character then
            self:Hide()
            return
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
        
        local boxSize = bottomRight - topLeft
        local boxPosition = topLeft
        
        local showBox = ESP.Settings.Boxes
        self.Drawings.BoxOutline.Visible = showBox
        self.Drawings.Box.Visible = showBox
        if showBox then
            local color = ESP.Settings.TeamColor and GetTeamColor(self.Player) or ESP.Settings.BoxColor
            self.Drawings.BoxOutline.Position = boxPosition
            self.Drawings.BoxOutline.Size = boxSize
            self.Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
            
            self.Drawings.Box.Position = boxPosition
            self.Drawings.Box.Size = boxSize
            self.Drawings.Box.Color = color
            self.Drawings.Box.Transparency = ESP.Settings.BoxTransparency
        end
        
        local showName = ESP.Settings.Names
        self.Drawings.Name.Visible = showName
        if showName then
            self.Drawings.Name.Text = self.Player.Name
            self.Drawings.Name.Position = boxPosition + Vector2.new(boxSize.X/2, -self.Drawings.Name.TextBounds.Y - 2)
            self.Drawings.Name.Color = ESP.Settings.NameColor
            self.Drawings.Name.Transparency = ESP.Settings.NameTransparency
        end
        
        local showHealthBar = ESP.Settings.HealthBar
        self.Drawings.HealthBarOutline.Visible = showHealthBar
        self.Drawings.HealthBar.Visible = showHealthBar
        if showHealthBar and currentHumanoid then
            local healthPercent = currentHumanoid.Health / currentHumanoid.MaxHealth
            local healthBarHeight = boxSize.Y * healthPercent
            local healthBarPosition = boxPosition + Vector2.new(-6, boxSize.Y - healthBarHeight)
            local healthBarSize = Vector2.new(2, healthBarHeight)
            
            self.Drawings.HealthBarOutline.Position = healthBarPosition - Vector2.new(1, 0)
            self.Drawings.HealthBarOutline.Size = healthBarSize + Vector2.new(2, 0)
            self.Drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)
            
            self.Drawings.HealthBar.Position = healthBarPosition
            self.Drawings.HealthBar.Size = healthBarSize
            self.Drawings.HealthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
        end
        
        local showHealthText = ESP.Settings.HealthText
        self.Drawings.HealthText.Visible = showHealthText
        if showHealthText and currentHumanoid then
            self.Drawings.HealthText.Text = math.floor(currentHumanoid.Health) .. "/" .. math.floor(currentHumanoid.MaxHealth)
            self.Drawings.HealthText.Position = boxPosition + Vector2.new(boxSize.X + 10, boxSize.Y/2)
            self.Drawings.HealthText.Color = ESP.Settings.NameColor
        end
        
        local showTracer = ESP.Settings.Tracers
        self.Drawings.Tracer.Visible = showTracer
        if showTracer then
            self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            self.Drawings.Tracer.To = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y)
            self.Drawings.Tracer.Color = ESP.Settings.TracerColor
        end
    end
    
    self.Update = Update
    
    local function OnCharacterAdded(character)
        if not character then return end
        
        local humanoid = GetHumanoid(character)
        if not humanoid then return end
        
        table.insert(self.Connections, humanoid.Died:Connect(function()
            self:Hide()
        end))
        
        table.insert(self.Connections, humanoid:GetPropertyChangedSignal("Health"):Connect(Update))
        table.insert(self.Connections, RunService.Heartbeat:Connect(Update))
        
        Update()
    end
    
    table.insert(self.Connections, player.CharacterAdded:Connect(OnCharacterAdded))
    
    if player.Character then
        OnCharacterAdded(player.Character)
    end
    
    return self
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

local CustomESPObject = {}
CustomESPObject.__index = CustomESPObject

function CustomESPObject.new(object, settings)
    local self = setmetatable({}, CustomESPObject)
    self.Object = object
    self.Settings = settings or {}
    self.Drawings = {}
    self.Connections = {}
    
    if self.Settings.Boxes then
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
    
    if self.Settings.Name then
        self.Drawings.Name = Drawing.new("Text")
        self.Drawings.Name.Center = true
        self.Drawings.Name.Outline = ESP.Settings.TextOutline
        self.Drawings.Name.OutlineColor = ESP.Settings.TextOutlineColor
        self.Drawings.Name.Size = self.Settings.NameSize or ESP.Settings.NameSize
        self.Drawings.Name.Font = ESP.Settings.TextFont
        self.Drawings.Name.Visible = false
        self.Drawings.Name.ZIndex = 4
    end
    
    local humanoid = object:IsA("Model") and object:FindFirstChildOfClass("Humanoid")
    if (humanoid and self.Settings.HealthBar ~= false) or self.Settings.HealthBar then
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
    
    if self.Settings.ShowDistance then
        self.Drawings.Distance = Drawing.new("Text")
        self.Drawings.Distance.Center = true
        self.Drawings.Distance.Outline = ESP.Settings.TextOutline
        self.Drawings.Distance.OutlineColor = ESP.Settings.TextOutlineColor
        self.Drawings.Distance.Size = (self.Settings.NameSize or ESP.Settings.NameSize) - 2
        self.Drawings.Distance.Font = ESP.Settings.TextFont
        self.Drawings.Distance.Visible = false
        self.Drawings.Distance.ZIndex = 4
    end
    
    if self.Settings.Tracers then
        self.Drawings.Tracer = Drawing.new("Line")
        self.Drawings.Tracer.Thickness = 1
        self.Drawings.Tracer.Visible = false
        self.Drawings.Tracer.ZIndex = 1
    end
    
    local function Update()
        if not ESP.Enabled or not self.Object or not self.Object.Parent then
            self:Hide()
            return
        end
        
        local position
        local size = Vector3.new(2, 2, 2)
        local humanoid = object:IsA("Model") and object:FindFirstChildOfClass("Humanoid")
        
        if self.Object:IsA("BasePart") then
            position = self.Object.Position
            size = self.Object.Size
        elseif self.Object:IsA("Model") then
            local primaryPart = self.Object.PrimaryPart or self.Object:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                position = primaryPart.Position
                size = primaryPart.Size
            else
                self:Hide()
                return
            end
        else
            self:Hide()
            return
        end
        
        local topLeft, onScreen, distance = WorldToViewport(position + Vector3.new(-size.X/2, size.Y/2, 0))
        local bottomRight = WorldToViewport(position + Vector3.new(size.X/2, -size.Y/2, 0))
        
        if not onScreen or distance > ESP.Settings.MaxDistance then
            self:Hide()
            return
        end
        
        local boxSize = bottomRight - topLeft
        local boxPosition = topLeft
        
        if self.Drawings.Box and self.Settings.Boxes then
            self.Drawings.BoxOutline.Visible = true
            self.Drawings.BoxOutline.Position = boxPosition
            self.Drawings.BoxOutline.Size = boxSize
            self.Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
            
            self.Drawings.Box.Visible = true
            self.Drawings.Box.Position = boxPosition
            self.Drawings.Box.Size = boxSize
            self.Drawings.Box.Color = self.Settings.BoxColor or ESP.CustomSettings.BoxColor
            self.Drawings.Box.Transparency = self.Settings.BoxTransparency or ESP.CustomSettings.BoxTransparency
        else
            if self.Drawings.BoxOutline then self.Drawings.BoxOutline.Visible = false end
            if self.Drawings.Box then self.Drawings.Box.Visible = false end
        end
        
        if self.Drawings.Name and self.Settings.Name then
            self.Drawings.Name.Visible = true
            self.Drawings.Name.Text = tostring(self.Settings.Name)
            self.Drawings.Name.Position = boxPosition + Vector2.new(boxSize.X/2, -self.Drawings.Name.TextBounds.Y - 2)
            self.Drawings.Name.Color = self.Settings.NameColor or ESP.CustomSettings.NameColor
            self.Drawings.Name.Transparency = self.Settings.NameTransparency or ESP.CustomSettings.NameTransparency
        elseif self.Drawings.Name then
            self.Drawings.Name.Visible = false
        end
        
        if self.Drawings.HealthBar and ((humanoid and self.Settings.HealthBar ~= false) or self.Settings.HealthBar) then
            local health, maxHealth = 100, 100
            if humanoid then
                health = humanoid.Health
                maxHealth = humanoid.MaxHealth
            end
            
            local healthPercent = health / maxHealth
            local healthBarHeight = boxSize.Y * healthPercent
            local healthBarPosition = boxPosition + Vector2.new(-6, boxSize.Y - healthBarHeight)
            local healthBarSize = Vector2.new(2, healthBarHeight)
            
            self.Drawings.HealthBarOutline.Visible = true
            self.Drawings.HealthBarOutline.Position = healthBarPosition - Vector2.new(1, 0)
            self.Drawings.HealthBarOutline.Size = healthBarSize + Vector2.new(2, 0)
            self.Drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)
            
            self.Drawings.HealthBar.Visible = true
            self.Drawings.HealthBar.Position = healthBarPosition
            self.Drawings.HealthBar.Size = healthBarSize
            self.Drawings.HealthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
        else
            if self.Drawings.HealthBarOutline then self.Drawings.HealthBarOutline.Visible = false end
            if self.Drawings.HealthBar then self.Drawings.HealthBar.Visible = false end
        end
        
        if self.Drawings.Distance and self.Settings.ShowDistance then
            self.Drawings.Distance.Visible = true
            self.Drawings.Distance.Text = string.format("%.1f", distance) .. "m"
            self.Drawings.Distance.Position = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y + 5)
            self.Drawings.Distance.Color = self.Settings.NameColor or ESP.CustomSettings.NameColor
        elseif self.Drawings.Distance then
            self.Drawings.Distance.Visible = false
        end
        
        if self.Drawings.Tracer and self.Settings.Tracers then
            self.Drawings.Tracer.Visible = true
            self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            self.Drawings.Tracer.To = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y)
            self.Drawings.Tracer.Color = self.Settings.TracerColor or ESP.CustomSettings.TracerColor
        elseif self.Drawings.Tracer then
            self.Drawings.Tracer.Visible = false
        end
    end
    
    self.Update = Update
    
    table.insert(self.Connections, RunService.Heartbeat:Connect(Update))
    
    if object:IsA("BasePart") or object:IsA("Model") then
        table.insert(self.Connections, object.AncestryChanged:Connect(function(_, parent)
            if not parent then
                self:Destroy()
            end
        end))
    end
    
    return self
end

function CustomESPObject:Hide()
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing.Visible = false
        end
    end
end

function CustomESPObject:Destroy()
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
    
    for i, obj in pairs(ESP.CustomObjects) do
        if obj == self then
            table.remove(ESP.CustomObjects, i)
            break
        end
    end
end

function ESP:AddObjectListener(object, settings)
    if not object or (not object:IsA("BasePart") and not object:IsA("Model")) then
        return nil
    end
    
    local mergedSettings = {}
    for k, v in pairs(ESP.CustomSettings) do
        mergedSettings[k] = settings and settings[k] ~= nil and settings[k] or v
    end
    
    if object:IsA("Model") and object:FindFirstChildOfClass("Humanoid") and mergedSettings.HealthBar ~= false then
        mergedSettings.HealthBar = true
    end
    
    local obj = CustomESPObject.new(object, mergedSettings)
    table.insert(self.CustomObjects, obj)
    return obj
end

function ESP:Toggle(state)
    self.Enabled = state == nil and not self.Enabled or state
    for _, obj in pairs(self.Objects) do
        if obj then
            if self.Enabled then
                if obj.Update then
                    coroutine.wrap(obj.Update)()
                end
            else
                obj:Hide()
            end
        end
    end
    for _, obj in pairs(self.CustomObjects) do
        if obj then
            if self.Enabled then
                if obj.Update then
                    coroutine.wrap(obj.Update)()
                end
            else
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
    
    for _, obj in pairs(self.CustomObjects) do
        if obj then
            obj:Destroy()
        end
    end
    
    self.Objects = {}
    self.CustomObjects = {}
end

ESP:Initialize()

return ESP
