local ESP = {
    Enabled = false,
    Players = {},
    Objects = {},
    CustomObjects = {},
    Connections = {},

    CustomSettings = {
        Boxes = true,
        BoxColor = Color3.fromRGB(255, 255, 0),
        BoxTransparency = 0.5,
        Name = "Object",
        NameColor = Color3.fromRGB(255, 255, 255),
        NameTransparency = 1,
        NameSize = 13,
        Distance = true,
        HealthBar = false,
        Tracers = false,
        TracerColor = Color3.fromRGB(255, 255, 255),
        Chams = false,
        ChamsColor = Color3.fromRGB(255, 0, 0),
        ChamsTransparency = 0.5
    }
}

local settingsMetatable = {
    __newindex = function(self, key, value)
        rawset(self, key, value)
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
    end,
    __index = function(self, key)
        return rawget(self, key)
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
    TextOutlineColor = Color3.fromRGB(0, 0, 0),
    Distance = true,
    Chams = false,
    ChamsColor = Color3.fromRGB(255, 0, 0),
    ChamsTransparency = 0.5
}, settingsMetatable)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
ESP.LocalPlayer = Players.LocalPlayer

local function WorldToViewport(position)
    if not Camera then return Vector2.new(), false, 0 end
    local vector, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(vector.X, vector.Y), onScreen, vector.Z
end

ESP.GetTeamColor = function(player)
    return player and player.Team and player.Team.TeamColor and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
end

ESP.IsTeamMate = function(player)
    if not ESP.Settings.TeamCheck then return false end
    return player and ESP.LocalPlayer and player.Team == ESP.LocalPlayer.Team
end

local function GetHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local lerpColor = Color3.new().Lerp;

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
                cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/8)
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
    self.Highlight = nil
    
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
    
    self.Drawings.Distance = Drawing.new("Text")
    self.Drawings.Distance.Center = true
    self.Drawings.Distance.Outline = ESP.Settings.TextOutline
    self.Drawings.Distance.OutlineColor = ESP.Settings.TextOutlineColor
    self.Drawings.Distance.Size = ESP.Settings.NameSize - 2
    self.Drawings.Distance.Font = ESP.Settings.TextFont
    self.Drawings.Distance.Visible = false
    self.Drawings.Distance.ZIndex = 4
    
    local function UpdateChams()
        if not ESP.Settings.Chams or not self.Player or not self.Player.Character then
            if self.Highlight then
                self.Highlight:Destroy()
                self.Highlight = nil
            end
            return
        end
        
        if ESP.IsTeamMate(self.Player) then
            if self.Highlight then
                self.Highlight:Destroy()
                self.Highlight = nil
            end
            return
        end
        
        if not self.Highlight then
            self.Highlight = Instance.new("Highlight")
            self.Highlight.Parent = self.Player.Character
            self.Highlight.Adornee = self.Player.Character
            self.Highlight.FillColor = ESP.Settings.ChamsColor
            self.Highlight.OutlineColor = ESP.Settings.ChamsColor
            self.Highlight.FillTransparency = ESP.Settings.ChamsTransparency
            self.Highlight.OutlineTransparency = 0
        else
            self.Highlight.FillColor = ESP.Settings.ChamsColor
            self.Highlight.OutlineColor = ESP.Settings.ChamsColor
            self.Highlight.FillTransparency = ESP.Settings.ChamsTransparency
        end
    end
    
    local function Update()
        if not ESP.Enabled or not self.Player or not self.Player.Character then
            self:Hide()
            return
        end
        
        local currentCharacter = self.Player.Character
        local currentHumanoid = GetHumanoid(currentCharacter)
        local rootPart = GetRootPart(currentCharacter)
        
        if not currentHumanoid or currentHumanoid.Health <= 0 or not rootPart then
            self:Hide()
            return
        end
        
        if ESP.IsTeamMate(self.Player) then
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
            local color = ESP.Settings.TeamColor and ESP.GetTeamColor(self.Player) or ESP.Settings.BoxColor
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
            self.Drawings.HealthBar.Color = lerpColor(Color3.fromRGB(161, 47, 47), Color3.fromRGB(58, 161, 47), currentHumanoid.Health / currentHumanoid.MaxHealth)
        end
        
        local showHealthText = ESP.Settings.HealthText
        self.Drawings.HealthText.Visible = showHealthText
        if showHealthText and currentHumanoid then
            self.Drawings.HealthText.Text = math.floor(currentHumanoid.Health) .. "HP"
            self.Drawings.HealthText.Position = boxPosition + Vector2.new(boxSize.X + 5, boxSize.Y/2 - 15)
            self.Drawings.HealthText.Color = lerpColor(Color3.fromRGB(161, 47, 47), Color3.fromRGB(58, 161, 47), currentHumanoid.Health / currentHumanoid.MaxHealth)
        end
        
        local showTracer = ESP.Settings.Tracers
        self.Drawings.Tracer.Visible = showTracer
        if showTracer then
            self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            self.Drawings.Tracer.To = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y)
            self.Drawings.Tracer.Color = ESP.Settings.TracerColor
        end
        
        local Distance = ESP.Settings.Distance
        self.Drawings.Distance.Visible = Distance
        if Distance then
            local localRoot = ESP.LocalPlayer.Character and ESP.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localRoot then
                local dist = (rootPart.Position - localRoot.Position).Magnitude
                self.Drawings.Distance.Text = string.format("%.0f", dist) .. "M"
                self.Drawings.Distance.Position = boxPosition + Vector2.new(boxSize.X + 5, boxSize.Y/2)
                self.Drawings.Distance.Color = ESP.Settings.NameColor
            end
        end
        
        UpdateChams()
    end
    
    self.Update = Update
    
    table.insert(self.Connections, RunService.Heartbeat:Connect(function()
        if ESP.Enabled then
            Update()
        else
            self:Hide()
        end
    end))
    
    Update()
    
    return self
end

function ESPObject:Hide()
    for _, drawing in pairs(self.Drawings) do
        if drawing then
            drawing.Visible = false
        end
    end
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
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
    
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
    end
    
    self.Connections = {}
    self.Drawings = {}
end

local CustomESPObject = {}
CustomESPObject.__index = CustomESPObject

function CustomESPObject.new(object, settings)
    local self = setmetatable({}, CustomESPObject)
    self.Object = object
    
    self.Settings = setmetatable({}, {
        __newindex = function(t, key, value)
            rawset(t, key, value)
            if self.Update then
                coroutine.wrap(self.Update)()
            end
        end,
        __index = function(t, key)
            return rawget(t, key) or ESP.CustomSettings[key]
        end
    })
    
    if settings then
        for k, v in pairs(settings) do
            self.Settings[k] = v
        end
    end
    
    self.Drawings = {}
    self.Connections = {}
    self.Highlight = nil
    
    self:InitializeDrawings()
    
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
        
        if self.Settings.Boxes then
            if not self.Drawings.Box then
                self:InitializeDrawings()
            end
            self.Drawings.BoxOutline.Visible = true
            self.Drawings.Box.Visible = true
            
            self.Drawings.BoxOutline.Position = boxPosition
            self.Drawings.BoxOutline.Size = boxSize
            self.Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
            
            self.Drawings.Box.Position = boxPosition
            self.Drawings.Box.Size = boxSize
            self.Drawings.Box.Color = self.Settings.BoxColor
            self.Drawings.Box.Transparency = self.Settings.BoxTransparency
        elseif self.Drawings.Box then
            self.Drawings.BoxOutline.Visible = false
            self.Drawings.Box.Visible = false
        end
        
        if self.Settings.Name then
            if not self.Drawings.Name then
                self:InitializeDrawings()
            end
            self.Drawings.Name.Visible = true
            self.Drawings.Name.Text = tostring(self.Settings.Name)
            self.Drawings.Name.Position = boxPosition + Vector2.new(boxSize.X/2, -self.Drawings.Name.TextBounds.Y - 2)
            self.Drawings.Name.Color = self.Settings.NameColor
            self.Drawings.Name.Transparency = self.Settings.NameTransparency
            self.Drawings.Name.Size = self.Settings.NameSize
        elseif self.Drawings.Name then
            self.Drawings.Name.Visible = false
        end
        
        local showHealthBar = (humanoid and self.Settings.HealthBar ~= false) or self.Settings.HealthBar
        if showHealthBar then
            if not self.Drawings.HealthBar then
                self:InitializeDrawings()
            end
            
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
            self.Drawings.HealthBar.Color = lerpColor(Color3.fromRGB(161, 47, 47), Color3.fromRGB(58, 161, 47), health / maxHealth)
            
            if self.Drawings.HealthText then
                self.Drawings.HealthText.Visible = true
                self.Drawings.HealthText.Text = math.floor(health) .. "HP"
                self.Drawings.HealthText.Position = boxPosition + Vector2.new(boxSize.X + 5, boxSize.Y/2 - 15)
                self.Drawings.HealthText.Color = lerpColor(Color3.fromRGB(161, 47, 47), Color3.fromRGB(58, 161, 47), health / maxHealth)
            end
        elseif self.Drawings.HealthBar then
            self.Drawings.HealthBarOutline.Visible = false
            self.Drawings.HealthBar.Visible = false
            if self.Drawings.HealthText then
                self.Drawings.HealthText.Visible = false
            end
        end
        
        if self.Settings.Distance then
            if not self.Drawings.Distance then
                self:InitializeDrawings()
            end
            self.Drawings.Distance.Visible = true
            self.Drawings.Distance.Text = string.format("%.0f", distance) .. "M"
            self.Drawings.Distance.Position = boxPosition + Vector2.new(boxSize.X + 5, boxSize.Y/2)
            self.Drawings.Distance.Color = self.Settings.NameColor
        elseif self.Drawings.Distance then
            self.Drawings.Distance.Visible = false
        end
        
        if self.Settings.Tracers then
            if not self.Drawings.Tracer then
                self:InitializeDrawings()
            end
            self.Drawings.Tracer.Visible = true
            self.Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            self.Drawings.Tracer.To = boxPosition + Vector2.new(boxSize.X/2, boxSize.Y)
            self.Drawings.Tracer.Color = self.Settings.TracerColor
        elseif self.Drawings.Tracer then
            self.Drawings.Tracer.Visible = false
        end
        
        if self.Settings.Chams then
            if not self.Highlight then
                self.Highlight = Instance.new("Highlight")
                self.Highlight.Parent = self.Object
                self.Highlight.Adornee = self.Object
            end
            self.Highlight.FillColor = self.Settings.ChamsColor
            self.Highlight.OutlineColor = self.Settings.ChamsColor
            self.Highlight.FillTransparency = self.Settings.ChamsTransparency
            self.Highlight.OutlineTransparency = 0
            self.Highlight.Enabled = true
        elseif self.Highlight then
            self.Highlight.Enabled = false
        end
    end
    
    function self:InitializeDrawings()
        for _, drawing in pairs(self.Drawings) do
            if drawing then
                drawing:Remove()
            end
        end
        self.Drawings = {}
        
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
            self.Drawings.Name.Size = self.Settings.NameSize
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
            
            self.Drawings.HealthText = Drawing.new("Text")
            self.Drawings.HealthText.Center = true
            self.Drawings.HealthText.Outline = ESP.Settings.TextOutline
            self.Drawings.HealthText.OutlineColor = ESP.Settings.TextOutlineColor
            self.Drawings.HealthText.Size = self.Settings.NameSize - 2
            self.Drawings.HealthText.Font = ESP.Settings.TextFont
            self.Drawings.HealthText.Visible = false
            self.Drawings.HealthText.ZIndex = 4
        end
        
        if self.Settings.Distance then
            self.Drawings.Distance = Drawing.new("Text")
            self.Drawings.Distance.Center = true
            self.Drawings.Distance.Outline = ESP.Settings.TextOutline
            self.Drawings.Distance.OutlineColor = ESP.Settings.TextOutlineColor
            self.Drawings.Distance.Size = self.Settings.NameSize - 2
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
    end
    
    self.Update = Update
    
    table.insert(self.Connections, RunService.Heartbeat:Connect(function()
        self:Update()
    end))
    
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
    if self.Highlight then
        self.Highlight.Enabled = false
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
    
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
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
    
    for _, existingObj in pairs(self.CustomObjects) do
        if existingObj.Object == object then
            if settings then
                for k, v in pairs(settings) do
                    existingObj.Settings[k] = v
                end
            end
            return existingObj
        end
    end
    
    local obj = CustomESPObject.new(object, settings)
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

function ESP:Initialize()
    table.insert(self.Connections, RunService.Heartbeat:Connect(function()
        if not ESP.Enabled then return end
        
        local currentPlayers = Players:GetPlayers()
        local currentPlayerMap = {}
        
        for _, player in ipairs(currentPlayers) do
            if player ~= ESP.LocalPlayer then
                currentPlayerMap[player] = true
            end
        end
        
        for _, player in ipairs(currentPlayers) do
            if player ~= ESP.LocalPlayer and not self.Objects[player] then
                local obj = ESPObject.new(player)
                self.Objects[player] = obj
                if obj.Update then
                    coroutine.wrap(obj.Update)()
                end
            end
        end
        
        for player, obj in pairs(self.Objects) do
            if not currentPlayerMap[player] then
                obj:Destroy()
                self.Objects[player] = nil
            end
        end
    end))
end

function ESP:Unload()
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
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
    self.Connections = {}
end

ESP:Initialize()

return ESP
