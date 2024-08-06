local Games = {
	FreedomWar = {
		Lobby = 11534222714,
		Campaign = 11564374799,
		Practice = 11567929685,
	},
	Shinden = {
		Lobby = 6808589067,
		Main = 10369535604,
	},
}

local Executor = identifyexecutor()

local function GetScript(Script)
	if Script == "Freedom" then
		if Executor == "Celery" or Executor == "Solara" then
			if game.PlaceId == Games.FreedomWar.Campaign or game.PlaceId == Games.FreedomWar.Practice then
				return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/SolaraFreedom.lua"
			end
		elseif Executor == "Wave" or Executor == "Synapse Z" then
			if game.PlaceId == Games.FreedomWar.Campaign or game.PlaceId == Games.FreedomWar.Practice then
				return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Freedom.lua"
			end
		end
	elseif Script == "Shinden" then
		if Executor == "Celery" or Executor == "Solara" then
			if game.PlaceId == Games.Shinden.Main then
				return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Shinden.lua"
			end
		elseif Executor == "Wave" or Executor == "Synapse Z" then
			if game.PlaceId == Games.Shinden.Main then
				return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Shinden.lua"
			end
		end
	elseif Script == "Debug" then
		return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Debug.lua"
	elseif Script == "Admin" then
		return "https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Admin.lua"
	end
end

loadstring(game:HttpGet(GetScript("Freedom")))
loadstring(game:HttpGet(GetScript("Shinden")))
loadstring(game:HttpGet(GetScript("Debug")))
loadstring(game:HttpGet(GetScript("Admin")))
