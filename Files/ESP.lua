local ESP = {}
ESP.Enabled = false
ESP.Boxes = false
ESP.Names = false
ESP.Players = {}
ESP.Connections = {}

local function createBox()
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Visible = false
    return box
end

local function createText()
    local text = Drawing.new("Text")
    text.Size = 18
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0)
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Visible = false
    return text
end

local function getPlayerColor(player)
    local character = player.Character
    if character then
        if character:FindFirstChild("COLocal") or character:FindFirstChild("FELocal") or character:FindFirstChild("ARLocal") then
            return Color3.fromRGB(255, 0, 0) -- Red
        end
        if player.Team and player.Team.Name == "Soldiers" then
            return Color3.fromRGB(0, 0, 255) -- Blue
        end
        if player.Team and player.Team.Name == "Interior Police" then
            return Color3.fromRGB(0, 255, 0) -- Green
        end
        if player.Team and player.Team.Name == "Rogue" then
            return Color3.fromRGB(255, 165, 0) -- Orange
        end
    end
    return Color3.fromRGB(255, 255, 255) -- Default color
end

local function updateESP()
    if not getgenv().ESP then
        ESP:Disable()
        return
    end

    for player, drawings in pairs(ESP.Players) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and not character:FindFirstChild("Shifter") then
            -- Skip players on the "Choosing" team
            if player.Team and player.Team.Name == "Choosing" then
                drawings.box.Visible = false
                drawings.text.Visible = false
                continue
            end

            local rootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")

            local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            local headPosition = head and workspace.CurrentCamera:WorldToViewportPoint(head.Position) or screenPosition

            if onScreen then
                local size = Vector2.new(1000 / screenPosition.Z, headPosition.Y - screenPosition.Y)

                if ESP.Boxes then
                    drawings.box.Size = size
                    drawings.box.Position = Vector2.new(screenPosition.X - size.X / 2, screenPosition.Y - size.Y / 2)
                    drawings.box.Visible = true
                else
                    drawings.box.Visible = false
                end

                if ESP.Names then
                    drawings.text.Position = Vector2.new(screenPosition.X, screenPosition.Y - size.Y / 2 - 20)
                    drawings.text.Text = player.Name
                    drawings.text.Color = getPlayerColor(player)
                    drawings.text.Visible = true
                else
                    drawings.text.Visible = false
                end
            else
                drawings.box.Visible = false
                drawings.text.Visible = false
            end
        else
            drawings.box.Visible = false
            drawings.text.Visible = false
        end
    end
end

function ESP:Enable()
    if not self.Enabled and getgenv().ESP then
        self.Enabled = true

        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local character = player.Character
                if character and not character:FindFirstChild("Shifter") then
                    -- Skip players on the "Choosing" team
                    if player.Team and player.Team.Name == "Choosing" then
                        continue
                    end
                    local box = createBox()
                    local text = createText()
                    self.Players[player] = { box = box, text = text }
                end
            end
        end

        self.Connections.PlayerAdded = game:GetService("Players").PlayerAdded:Connect(function(player)
            if player ~= game.Players.LocalPlayer then
                local character = player.Character
                if character and not character:FindFirstChild("Shifter") then
                    -- Skip players on the "Choosing" team
                    if player.Team and player.Team.Name == "Choosing" then
                        return
                    end
                    local box = createBox()
                    local text = createText()
                    self.Players[player] = { box = box, text = text }
                end
            end
        end)

        self.Connections.PlayerRemoving = game:GetService("Players").PlayerRemoving:Connect(function(player)
            if self.Players[player] then
                self.Players[player].box:Destroy()
                self.Players[player].text:Destroy()
                self.Players[player] = nil
            end
        end)

        self.Connections.RenderStepped = game:GetService("RunService").RenderStepped:Connect(updateESP)
    end
end

function ESP:Disable()
    if self.Enabled then
        self.Enabled = false

        for player, drawings in pairs(self.Players) do
            drawings.box:Destroy()
            drawings.text:Destroy()
        end
        self.Players = {}

        for _, connection in pairs(self.Connections) do
            connection:Disconnect()
        end
        self.Connections = {}
    end
end

function ESP:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

return ESP
