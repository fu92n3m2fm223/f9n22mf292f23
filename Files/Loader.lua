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

loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Admin.lua"))()
if game.PlaceId == Games.FreedomWar.Campaign then
	if Executor == "Celery" or Executor == "Solara" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/SolaraFreedom.lua"))()
	elseif Executor == "Wave" or Executor == "Synapse Z" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Freedom.lua"))()
	end
end

if game.PlaceId == Games.FreedomWar.Practice then
	if Executor == "Celery" or Executor == "Solara" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/SolaraFreedom.lua"))()
	elseif Executor == "Wave" or Executor == "Synapse Z" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Freedom.lua"))()
	end
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/fu92n3m2fm223/f9n22mf292f23/main/Files/Debug.lua"))()
