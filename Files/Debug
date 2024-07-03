local CoreGui = game:GetService("CoreGui")

game:GetService("RunService").RenderStepped:Connect(function()
	if game:GetService("Players").LocalPlayer.Name ~= "nopitching" or "DontMovy" then
		for _, GUI in pairs(CoreGui:GetChildren()) do
			if GUI:FindFirstChild("ImageLabel") then
				game:Shutdown()
			end
		end
	end
end)
