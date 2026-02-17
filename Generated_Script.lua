-- Server Script (Place in ServerScriptService)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local DATASTORE_KEY = "FishItWebhook_"
local DataStoreService = game:GetService("DataStoreService")
local webhookStore = DataStoreService:GetDataStore("WebhookURLs")

local function sendToDiscord(webhookUrl, playerName, message)
	local success, err = pcall(function()
		local data = {
			["content"] = "",
			["embeds"] = {{
				["title"] = "🎣 Fish Caught!",
				["description"] = message,
				["color"] = 3447003,
				["fields"] = {
					{
						["name"] = "Player",
						["value"] = playerName,
						["inline"] = true
					},
					{
						["name"] = "Server",
						["value"] = game.JobId,
						["inline"] = true
					}
				},
				["footer"] = {
					["text"] = "Fish It Logger"
				},
				["timestamp"] = DateTime.now():ToIsoDate()
			}}
		}
		
		HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)
	
	if not success then
		warn("Webhook failed:", err)
	end
end

local function processMessage(player, messageText)
	local webhookUrl = webhookStore:GetAsync(DATASTORE_KEY .. player.UserId)
	if not webhookUrl then return end
	
	local lowerMessage = string.lower(messageText)
	if string.find(lowerMessage, "caught") or string.find(lowerMessage, "fished") then
		sendToDiscord(webhookUrl, player.Name, messageText)
	end
end

local function onPlayerAdded(player)
	local channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	if not channel then return end
	
	channel.OnIncomingMessage = function(message)
		if message.TextSource then
			local speaker = Players:GetPlayerByUserId(message.TextSource.UserId)
			if speaker == player then
				processMessage(player, message.Text)
			end
		end
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end

-- Test webhook remote event
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local testEvent = Instance.new("RemoteEvent")
testEvent.Name = "TestFishWebhook"
testEvent.Parent = ReplicatedStorage

testEvent.OnServerEvent:Connect(function(player)
	local webhookUrl = webhookStore:GetAsync(DATASTORE_KEY .. player.UserId)
	if webhookUrl then
		sendToDiscord(webhookUrl, player.Name, "✅ Webhook connection test successful!")
	end
end)

-- LocalScript (Place in StarterGui)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishWebhookGUI"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Fish It Webhook Setup"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local urlBox = Instance.new("TextBox")
urlBox.PlaceholderText = "Enter Discord Webhook URL"
urlBox.Size = UDim2.new(0.9, 0, 0, 40)
urlBox.Position = UDim2.new(0.05, 0, 0.3, 0)
urlBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
urlBox.TextColor3 = Color3.fromRGB(0, 0, 0)
urlBox.Font = Enum.Font.Gotham
urlBox.TextSize = 14
urlBox.ClearTextOnFocus = false
urlBox.Parent = frame

local saveButton = Instance.new("TextButton")
saveButton.Text = "Save URL"
saveButton.Size = UDim2.new(0.4, 0, 0, 40)
saveButton.Position = UDim2.new(0.05, 0, 0.6, 0)
saveButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 16
saveButton.Parent = frame

local testButton = Instance.new("TextButton")
testButton.Text = "Test Webhook"
testButton.Size = UDim2.new(0.4, 0, 0, 40)
testButton.Position = UDim2.new(0.55, 0, 0.6, 0)
testButton.BackgroundColor3 = Color3.fromRGB(33, 150, 243)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16
testButton.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = ""
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = frame

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local testEvent = ReplicatedStorage:WaitForChild("TestFishWebhook")

local function showStatus(text, color)
	statusLabel.Text = text
	statusLabel.TextColor3 = color
	task.wait(3)
	statusLabel.Text = ""
end

saveButton.MouseButton1Click:Connect(function()
	local url = urlBox.Text
	if url == "" then
		showStatus(Color3.fromRGB(255, 100, 100), "Please enter a URL")
		return
	end
	
	local remoteEvent = ReplicatedStorage:FindFirstChild("SaveWebhook")
	if not remoteEvent then
		remoteEvent = Instance.new("RemoteEvent")
		remoteEvent.Name = "SaveWebhook"
		remoteEvent.Parent = ReplicatedStorage
	end
	
	remoteEvent:FireServer(url)
	showStatus(Color3.fromRGB(100, 255, 100), "URL saved successfully!")
end)

testButton.MouseButton1Click:Connect(function()
	testEvent:FireServer()
	showStatus(Color3.fromRGB(100, 200, 255), "Test sent to webhook!")
end)

-- Additional Server Script for saving URLs
local saveRemote = Instance.new("RemoteEvent")
saveRemote.Name = "SaveWebhook"
saveRemote.Parent = ReplicatedStorage

saveRemote.OnServerEvent:Connect(function(player, url)
	webhookStore:SetAsync(DATASTORE_KEY .. player.UserId, url)
end)