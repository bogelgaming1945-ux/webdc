local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

local TARGET_CHANNEL_NAME = "General"
local WEBHOOK_URL = nil

--------------------------------------------------
-- DISCORD POST FUNCTION
--------------------------------------------------

local function postToDiscord(data)
	if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
	
	local jsonData = HttpService:JSONEncode(data)

	local success, err = pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("Webhook Error:", err)
	end
end

--------------------------------------------------
-- SEND CONNECTION ALERT
--------------------------------------------------

local function sendConnectionAlert()
	postToDiscord({
		["embeds"] = {{
			["title"] = "✅ Webhook Connected",
			["description"] = "Fish Logger is now active.",
			["color"] = 5763719,
			["fields"] = {
				{
					["name"] = "Server ID",
					["value"] = game.JobId
				}
			},
			["timestamp"] = DateTime.now():ToIsoDate()
		}}
	})
end

--------------------------------------------------
-- SEND FISH LOG
--------------------------------------------------

local function sendFishLog(playerName, message)
	postToDiscord({
		["embeds"] = {{
			["title"] = "🎣 Fish Obtained (Server Only)",
			["color"] = 65280,
			["fields"] = {
				{
					["name"] = "Player",
					["value"] = playerName
				},
				{
					["name"] = "Message",
					["value"] = message
				},
				{
					["name"] = "Server ID",
					["value"] = game.JobId
				}
			},
			["timestamp"] = DateTime.now():ToIsoDate()
		}}
	})
end

--------------------------------------------------
-- CREATE UI FOR CREATOR ONLY
--------------------------------------------------

Players.PlayerAdded:Connect(function(player)
	
	-- Hanya Creator yang bisa set webhook
	if player.UserId ~= game.CreatorId then return end
	
	player.CharacterAdded:Wait()
	
	local gui = Instance.new("ScreenGui")
	gui.Name = "WebhookSetupUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 420, 0, 220)
	frame.Position = UDim2.new(0.5, -210, 0.5, -110)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Parent = gui
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,40)
	title.Text = "Discord Webhook Setup"
	title.TextScaled = true
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.new(1,1,1)
	title.Parent = frame
	
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.9,0,0,60)
	box.Position = UDim2.new(0.05,0,0.3,0)
	box.PlaceholderText = "Paste Discord Webhook URL here..."
	box.Text = ""
	box.TextWrapped = true
	box.TextScaled = true
	box.BackgroundColor3 = Color3.fromRGB(50,50,50)
	box.TextColor3 = Color3.new(1,1,1)
	box.Parent = frame
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.5,0,0,50)
	button.Position = UDim2.new(0.25,0,0.7,0)
	button.Text = "SAVE"
	button.TextScaled = true
	button.BackgroundColor3 = Color3.fromRGB(0,170,0)
	button.TextColor3 = Color3.new(1,1,1)
	button.Parent = frame
	
	button.MouseButton1Click:Connect(function()
		if box.Text ~= "" then
			WEBHOOK_URL = box.Text
			button.Text = "Saved ✅"
			sendConnectionAlert()
		end
	end)
	
end)

--------------------------------------------------
-- CHAT LOGGER (GENERAL ONLY)
--------------------------------------------------

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	
	TextChatService.MessageReceived:Connect(function(message)
		
		if message.TextChannel 
		and message.TextChannel.Name == TARGET_CHANNEL_NAME
		and message.TextSource then
			
			local player = Players:GetPlayerByUserId(message.TextSource.UserId)
			
			if player then
				local text = message.Text
				
				if string.find(string.lower(text), "obtained") then
					sendFishLog(player.Name, text)
				end
			end
		end
		
	end)
	
end
