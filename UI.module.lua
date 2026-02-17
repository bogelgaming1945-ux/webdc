local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Assume 'nodes' is provided by the Nexus UI framework, mapping IDs to instances
local nodes = _G.NexusUINodes or {}

-- State
local currentWebhookUrl = ""
local statusTimeout = nil

-- Animation functions
local function animateButton(button)
	local originalSize = button.Size
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(button, tweenInfo, { Size = originalSize * 0.95 })
	tween:Play()
	tween.Completed:Connect(function()
		local revert = TweenService:Create(button, tweenInfo, { Size = originalSize })
		revert:Play()
	end)
end

local function showStatus(message, colorToken)
	local container = nodes["StatusMessageContainer"]
	local label = nodes["StatusMessage"]
	local stroke = nodes["StatusMessageStroke"]
	
	if container and label and stroke then
		-- Cancel previous timeout
		if statusTimeout then
			statusTimeout:Cancel()
		end
		
		-- Update text and color
		label.Text = message
		label.TextColor3 = nodes._tokens.colors[colorToken] or nodes._tokens.colors.Text
		stroke.Color = nodes._tokens.colors[colorToken] or nodes._tokens.colors.Primary
		
		-- Show with animation
		container.Visible = true
		container.BackgroundTransparency = 1
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(container, tweenInfo, { BackgroundTransparency = 0.1 })
		tween:Play()
		
		-- Auto-hide after 3 seconds
		statusTimeout = task.delay(3, function()
			local hideTween = TweenService:Create(container, tweenInfo, { BackgroundTransparency = 1 })
			hideTween:Play()
			hideTween.Completed:Connect(function()
				container.Visible = false
			end)
		end)
	end
end

-- Validation function
local function isValidWebhookUrl(url)
	-- Basic pattern check for Discord webhook URL
	return string.match(url, "^https://discord%.com/api/webhooks/%d+/[%w%-_]+$") ~= nil
end

-- Simulated API functions (replace with actual HTTP requests)
local function saveWebhook(url)
	-- In a real scenario, save to DataStore or player data
	currentWebhookUrl = url
	return true
end

local function testWebhook(url)
	-- Simulate a test message send
	-- In reality, use HttpService:PostAsync with a JSON payload
	return true
end

-- Button click handlers
local saveButton = nodes["SaveButton"]
if saveButton then
	saveButton.MouseButton1Click:Connect(function()
		animateButton(saveButton)
		
		local input = nodes["UrlInput"]
		if not input then return end
		
		local url = input.Text
		if url == "" then
			showStatus("Please enter a webhook URL.", "Error")
			return
		end
		
		if not isValidWebhookUrl(url) then
			showStatus("Invalid webhook URL format.", "Error")
			return
		end
		
		local success = saveWebhook(url)
		if success then
			showStatus("Webhook saved successfully!", "Success")
		else
			showStatus("Failed to save webhook.", "Error")
		end
	end)
end

local testButton = nodes["TestButton"]
if testButton then
	testButton.MouseButton1Click:Connect(function()
		animateButton(testButton)
		
		local input = nodes["UrlInput"]
		if not input then return end
		
		local url = input.Text
		if url == "" then
			showStatus("Please enter a webhook URL.", "Error")
			return
		end
		
		if not isValidWebhookUrl(url) then
			showStatus("Invalid webhook URL format.", "Error")
			return
		end
		
		local success = testWebhook(url)
		if success then
			showStatus("Webhook test successful!", "Success")
		else
			showStatus("Failed to test webhook.", "Error")
		end
	end)
end