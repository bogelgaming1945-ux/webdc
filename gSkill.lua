local Players = game:GetService("Players")

-- Tunggu sebentar agar loading pemain selesai
task.wait(1)

for _, player in pairs(Players:GetPlayers()) do
    local playerGui = player:WaitForChild("PlayerGui")
    local tGui = playerGui:FindFirstChild("ScreenGachaSkill")
    
    if tGui then
        tGui.Enabled = true
    end
end
