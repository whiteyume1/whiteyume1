repeat wait() until game:IsLoaded()
wait(3)
game:GetService("Players").LocalPlayer.PlayerScripts.ClientScript.CoinsPopup:Destroy()
game:GetService("Players").LocalPlayer.PlayerScripts.ClientScript.CashPopup:Destroy()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.CoinSpawners:FindFirstChild("50000000000000").CFrame

game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
while wait(0.05) do -- lower the number if u have a gud pc but its still gonna lag overtime for some reason and i dont want to fix it
local args = {
[1] = workspace.CoinSpawners:FindFirstChild("50000000000000")
}
game:GetService("ReplicatedStorage").Remotes.AskCoin:FireServer(unpack(args))


end
