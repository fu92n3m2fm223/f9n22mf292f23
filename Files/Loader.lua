local Games = {
    FreedomWar = {
        Lobby = 11534222714,
        Campaign = 11564374799,
        Practice = 11567929685,
        Scripts = {
            Standard = "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Freedom.lua",
            Solara = "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/SolaraFreedom.lua"
        }
    },
    Shinden = {
        Lobby = 6808589067,
        Main = 10369535604,
        Scripts = {
            Standard = "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Shinden.lua"
        }
    }
}

local ExecutorGroups = {
    Solara = {"Celery", "Solara"}
}

local function LoadScript(url)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        return
    end
end

local function IsExecutorInGroup(executor, groupName)
    if not ExecutorGroups[groupName] then return false end
    for _, name in ipairs(ExecutorGroups[groupName]) do
        if executor == name then
            return true
        end
    end
    return false
end

local Executor = identifyexecutor()

LoadScript("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Admin.lua")

local currentGame
for gameName, gameData in pairs(Games) do
    for _, placeId in pairs(gameData) do
        if type(placeId) == "number" and game.PlaceId == placeId then
            currentGame = gameData
            break
        end
    end
    if currentGame then break end
end

if currentGame then
    if currentGame.Scripts then
        if IsExecutorInGroup(Executor, "Solara") and currentGame.Scripts.Solara then
            LoadScript(currentGame.Scripts.Solara)
        elseif currentGame.Scripts.Standard then
            LoadScript(currentGame.Scripts.Standard)
        end
    end
end

LoadScript("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Debug.lua")
