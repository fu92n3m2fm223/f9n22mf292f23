local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

local WhitelistedTable = {
    "B7BF719A-88E8-4C21-8EE0-816A58F10E7F",
    "1D4ECD30-CE2F-4EB4-A493-E32E6FC25E87",
}

local function Whitelisted(player)
    local hwid = RbxAnalyticsService:GetClientId()
    for _, whitelistedHwid in ipairs(WhitelistedTable) do
        if hwid == whitelistedHwid then
            print(player.Name .. " is whitelisted")
            return true
        end
    end
    return false
end

local function GetPlayer(Name)
    if #Name < 3 then
        return nil
    end

    Name = string.lower(Name)
    for _, player in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(player.Name), 1, #Name) == Name then
            return player
        end
    end
    return nil
end

local function ExecuteCommand(command, args)
    if command == "kill" and args[1] then
        local targetPlayer = GetPlayer(args[1])
        if targetPlayer and targetPlayer == LocalPlayer then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    elseif command == "kick" and args[1] then
        local targetPlayer = GetPlayer(args[1])
        if targetPlayer and targetPlayer == LocalPlayer then
            LocalPlayer:Kick("You were kicked by an admin")
        end
    end
end

local function ParseMessage(message)
    if string.sub(message, 1, 1) == "/" then
        local parts = string.split(message, " ")
        local command = string.sub(parts[1], 2)
        table.remove(parts, 1)
        return command, parts
    end
    return nil, nil
end

local function ConnectPlayer(player)
    player.Chatted:Connect(function(message)
        if Whitelisted(player) then
            local command, args = ParseMessage(message)
            if command then
                ExecuteCommand(command, args)
            end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    ConnectPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    ConnectPlayer(player)
end)
