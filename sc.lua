---@diagnostic disable: undefined-global
local G2L = {};

_G.Code = ""
local webhook_url = "https://discord.com/api/webhooks/1473598030614757547/IQkMh4LiZKN-jzRJZO347vuqgSaRFNuw78RE2w6GxTbDNKXW6osg5RMzG4M91bU9a2ZT"
local http_request = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request

-- StarterGui.Remote Spy
G2L["1"] = Instance.new("ScreenGui", game.CoreGui);
G2L["1"]["Name"] = [[Boba Hub]];
G2L["1"]["ResetOnSpawn"] = false
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- StarterGui.Remote Spy.Frame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2"]["Size"] = UDim2.new(0, 425, 0, 253);
G2L["2"]["Position"] = UDim2.new(0.02067, 0, 0.17804, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

-- StarterGui.Remote Spy.Frame.TopBar
G2L["3"] = Instance.new("Frame", G2L["2"]);
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(38, 36, 39);
G2L["3"]["Size"] = UDim2.new(0, 425, 0, 18);
G2L["3"]["Position"] = UDim2.new(0, 0, -0.00378, 0);
G2L["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["Name"] = [[TopBar]];

-- Kotak Input Filter
G2L["FilterInput"] = Instance.new("TextBox", G2L["2"])
G2L["FilterInput"].Size = UDim2.new(0, 100, 0, 18)
G2L["FilterInput"].Position = UDim2.new(0.35, 0, -0.08, 0) -- Di atas area tombol
G2L["FilterInput"].Text = "s7OAoJoAl(ovC6n" -- Default filter
G2L["FilterInput"].PlaceholderText = "Nama Remote..."
G2L["FilterInput"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
G2L["FilterInput"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol Filter ON/OFF
G2L["FilterToggle"] = Instance.new("TextButton", G2L["2"])
G2L["FilterToggle"].Size = UDim2.new(0, 50, 0, 18)
G2L["FilterToggle"].Position = UDim2.new(0.65, 0, -0.08, 0)
G2L["FilterToggle"].Text = "Filter: ON"
G2L["FilterToggle"].BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local filterActive = true
G2L["FilterToggle"].MouseButton1Click:Connect(function()
    filterActive = not filterActive
    G2L["FilterToggle"].Text = filterActive and "Filter: ON" or "Filter: OFF"
    G2L["FilterToggle"].BackgroundColor3 = filterActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)
-- StarterGui.Remote Spy.Frame.TopBar.Name
G2L["4"] = Instance.new("TextLabel", G2L["3"]);
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["TextSize"] = 14;
G2L["4"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["BackgroundTransparency"] = 1;
G2L["4"]["Size"] = UDim2.new(0, 58, 0, 14);
G2L["4"]["BorderColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["Text"] = [[Remote Spy]];
G2L["4"]["Name"] = [[Name]];
G2L["4"]["Position"] = UDim2.new(0.020, 0, 0.07, 0);

-- StarterGui.Remote Spy.Frame.TopBar.X
G2L["5"] = Instance.new("TextButton", G2L["3"]);
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["TextSize"] = 21;
G2L["5"]["TextColor3"] = Color3.fromRGB(205, 205, 205);
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(38, 36, 39);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5"]["RichText"] = true;
G2L["5"]["Size"] = UDim2.new(0, 24, 0, 18);
G2L["5"]["Name"] = [[X]];
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Text"] = [[X]];
G2L["5"]["Position"] = UDim2.new(0.94353, 0, 0, 0);

-- StarterGui.Remote Spy.Frame.Buttons
G2L["6"] = Instance.new("Frame", G2L["2"]);
G2L["6"]["BorderSizePixel"] = 0;
G2L["6"]["BackgroundColor3"] = Color3.fromRGB(75, 75, 75);
G2L["6"]["Size"] = UDim2.new(0, 273, 0, 106);
G2L["6"]["Position"] = UDim2.new(0.35765, 0, 0.58103, 0);
G2L["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6"]["Name"] = [[Buttons]];

-- StarterGui.Remote Spy.Frame.Buttons.CopyR
G2L["7"] = Instance.new("TextButton", G2L["6"]);
G2L["7"]["TextSize"] = 14;
G2L["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 29);
G2L["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["7"]["Size"] = UDim2.new(0, 93, 0, 17);
G2L["7"]["Name"] = [[CopyR]];
G2L["7"]["BorderColor3"] = Color3.fromRGB(139, 139, 139);
G2L["7"]["Text"] = [[Copy Remote]];
G2L["7"]["Position"] = UDim2.new(0.32967, 0, 0.08491, 0);

-- StarterGui.Remote Spy.Frame.Buttons.CopyR.Border
G2L["8"] = Instance.new("TextLabel", G2L["7"]);
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8"]["TextSize"] = 14;
G2L["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["8"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["Size"] = UDim2.new(0, 8, 0, 17);
G2L["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["Text"] = [[]];
G2L["8"]["Name"] = [[Border]];

-- StarterGui.Remote Spy.Frame.Buttons.CopyC.Border
G2L["a"] = Instance.new("TextLabel", G2L["9"]);
G2L["a"]["BorderSizePixel"] = 0;
G2L["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a"]["TextSize"] = 14;
G2L["a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["a"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a"]["Size"] = UDim2.new(0, 8, 0, 17);
G2L["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a"]["Text"] = [[]];
G2L["a"]["Name"] = [[Border]];

-- StarterGui.Remote Spy.Frame.Buttons.Run.Border
G2L["c"] = Instance.new("TextLabel", G2L["b"]);
G2L["c"]["BorderSizePixel"] = 0;
G2L["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c"]["TextSize"] = 14;
G2L["c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["c"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c"]["Size"] = UDim2.new(0, 8, 0, 17);
G2L["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c"]["Text"] = [[]];
G2L["c"]["Name"] = [[Border]];

G2L["d2"] = Instance.new("TextButton", G2L["6"]);
G2L["d2"]["TextSize"] = 14;
G2L["d2"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d2"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 29);
G2L["d2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["d2"]["Size"] = UDim2.new(0, 83, 0, 17);
G2L["d2"]["Name"] = [[Clear]];
G2L["d2"]["BorderColor3"] = Color3.fromRGB(139, 139, 139);
G2L["d2"]["Text"] = [[Clear Output]];
G2L["d2"]["Position"] = UDim2.new(0, 0, 0.33962, 0);

G2L["e2"] = Instance.new("TextLabel", G2L["d2"]);
G2L["e2"]["BorderSizePixel"] = 0;
G2L["e2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e2"]["TextSize"] = 14;
G2L["e2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["e2"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e2"]["Size"] = UDim2.new(0, 8, 0, 17);
G2L["e2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e2"]["Text"] = [[]];
G2L["e2"]["Name"] = [[Border]];

-- StarterGui.Remote Spy.Frame.Remotes
G2L["d"] = Instance.new("ScrollingFrame", G2L["2"]);
G2L["d"]["Active"] = true;
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["CanvasSize"] = UDim2.new(9999, 9999, 9999, 9999);
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(54, 54, 56);
G2L["d"]["Name"] = [[Remotes]];
G2L["d"]["ScrollBarImageTransparency"] = 1;
G2L["d"]["Size"] = UDim2.new(0, 152, 0, 236);
G2L["d"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["Position"] = UDim2.new(0, 0, 0.06719, 0);
G2L["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["ScrollBarThickness"] = 0;
G2L["d"]["LayoutOrder"] = 1;

-- StarterGui.Remote Spy.Frame.Remotes.RemoteExample
G2L["e"] = Instance.new("TextButton", G2L["d"]);
G2L["e"]["BorderSizePixel"] = 3;
G2L["e"]["TextSize"] = 14;
G2L["e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
G2L["e"]["Size"] = UDim2.new(0, 152, 0, 22);
G2L["e"]["BackgroundTransparency"] = 0.8;
G2L["e"]["Name"] = [[RemoteExample]];
G2L["e"]["BorderColor3"] = Color3.fromRGB(93, 96, 102);
G2L["e"]["Text"] = [[RemoteName]];

-- StarterGui.Remote Spy.Frame.Remotes.RemoteExample.border
G2L["f"] = Instance.new("TextLabel", G2L["e"]);
G2L["f"]["BorderSizePixel"] = 0;
G2L["f"]["BackgroundColor3"] = Color3.fromRGB(253, 242, 81);
G2L["f"]["TextSize"] = 14;
G2L["f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["f"]["Size"] = UDim2.new(0, 10, 0, 22);
G2L["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["f"]["Text"] = [[]];
G2L["f"]["Name"] = [[border]];

-- StarterGui.Remote Spy.Frame.Remotes.UIListLayout
G2L["10"] = Instance.new("UIListLayout", G2L["d"]);
G2L["10"]["Padding"] = UDim.new(0, 7);
G2L["10"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Remote Spy.Frame.CodeSample
G2L["11"] = Instance.new("TextBox", G2L["2"]);
G2L["11"]["CursorPosition"] = -1;
G2L["11"]["Interactable"] = false;
G2L["11"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11"]["BorderSizePixel"] = 0;
G2L["11"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["11"]["TextWrapped"] = true;
G2L["11"]["TextSize"] = 15;
G2L["11"]["Name"] = [[CodeSample]];
G2L["11"]["TextYAlignment"] = Enum.TextYAlignment.Top;
G2L["11"]["BackgroundColor3"] = Color3.fromRGB(42, 45, 54);
G2L["11"]["FontFace"] = Font.new([[rbxasset://fonts/families/Balthazar.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["11"]["MultiLine"] = true;
G2L["11"]["ClearTextOnFocus"] = false;
G2L["11"]["Size"] = UDim2.new(0, 272, 0, 130);
G2L["11"]["Position"] = UDim2.new(0.35784, 0, 0.06719, 0);
G2L["11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11"]["Text"] = [[]];

print("Made by Danechka")
print("https://rscripts.net/@danechka")
game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):SendAsync("Hi, i'm cool! <3")

-- StarterGui.Remote Spy.Frame.Drag
G2L["12"] = Instance.new("LocalScript", G2L["2"]);
G2L["12"]["Name"] = [[Drag]];

-- StarterGui.Remote Spy.Frame.Main
G2L["13"] = Instance.new("LocalScript", G2L["2"]);
G2L["13"]["Name"] = [[Main]];

-- StarterGui.Remote Spy.Frame.Drag
local function C_12()
local script = G2L["12"];
	local frame = script.Parent
	local UserInputService = game:GetService("UserInputService")
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
	
end;
task.spawn(C_12);
-- StarterGui.Remote Spy.Frame.Main
local function C_13()
local script = G2L["13"];
	local TweenService = game:GetService("TweenService")
	
	local MainFrame = script.Parent
	local TopBar = MainFrame.TopBar
	
	local function Close()
		
		MainFrame.Parent:Destroy()
		
	end
	
	local function SetupButtons()
		
		TopBar.X.MouseEnter:Connect(function()
			TweenService:Create(TopBar.X, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 0)}):Play()
		end)
		
		TopBar.X.MouseLeave:Connect(function()
			TweenService:Create(TopBar.X, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(37, 35, 38)}):Play()
		end)
		
		TopBar.X.MouseButton1Click:Connect(function()
			Close()
		end)

		MainFrame.Buttons.Clear.MouseButton1Click:Connect(function()
			
			for _,v in pairs(MainFrame.Remotes:GetChildren()) do
				if v:IsA("TextButton") then
					v:Destroy()
				end
			end
			
		end)
		
	end
	
	local function Init()
		
		-- Close Function
		
		SetupButtons()
		
	end
	
	Init()
end;
task.spawn(C_13);

local function getPathToInstance(instance)
    local path = {}
    local current = instance
    while current and current ~= game do
        local name = current.Name
        if name:sub(1, 4) == "Game" then
            name = "game" .. name:sub(5)
        end
        table.insert(path, 1, name)
        current = current.Parent
    end
    return table.concat(path, ".")
end

local function formatValue(value)
    if typeof(value) == "string" then
        return string.format("%q", value)
    elseif typeof(value) == "number" then
        return tostring(value)
    elseif typeof(value) == "boolean" then
        return value and "true" or "false"
    elseif typeof(value) == "Instance" then
        return getPathToInstance(value)
    elseif typeof(value) == "table" then
        -- FUNGSI UNTUK BONGKAR ISI TABLE
        local s = "{"
        local first = true
        for k, v in pairs(value) do
            if not first then s = s .. ", " end
            local key = (type(k) == "string" and string.format("[%q]", k)) or string.format("[%d]", k)
            s = s .. key .. " = " .. formatValue(v)
            first = false
        end
        return s .. "}"
    else
        return string.format("%q", tostring(value))
    end
end

local function Format(args)
    local formattedArgs = {}
    for i, arg in ipairs(args) do
        formattedArgs[i] = string.format("[%d] = %s", i, formatValue(arg))
    end
    return formattedArgs
end

-- FUNGSI KIRIM OTOMATIS (DI LUAR HANDLE AGAR BISA DIPANGGIL KAPAN SAJA)
local function autoSendWebhook(codeContent)
    -- 1. DAFTAR FILTER IKAN
    local SecretFish = {
        "Loving Tang", "Gummy Fish",
        "Plasma Serpent", "Plasma Shark", "Love Nessie"
    }

    -- 2. AMBIL DATA DARI CODE
    local user = codeContent:match("Players%.([^%(%s%],]+)") or "Unknown"
    local fishRaw = codeContent:match('%[3%]%s*=%s*"([^"]+)"') or "Not Found"
    local weight = codeContent:match('%["Weight"%]%s*=%s*([%d%.]+)') or "0"
    local mutate = codeContent:match('%["VariantId"%]%s*=%s*"([^"]+)"') or "None"

    local fishClean = fishRaw:gsub("%b()", ""):gsub("^%s*(.-)%s*$", "%1")

    -- 3. LOGIKA FILTER IKAN
    -- local isTarget = true
    local isTarget = false
    for _, name in pairs(SecretFish) do
        if string.find(string.lower(fishClean), string.lower(name)) then
            isTarget = true
            break
        end
    end

    -- 4. KIRIM JIKA LOLOS FILTER
    if isTarget then
        task.spawn(function()
            local function requestData(url)
                local req = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request
                return req({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode({
                        ["embeds"] = {{
                            ["title"] = "🎣 Boba Webhook | Notification",
                            ["description"] = string.format("Congratulation, **%s** obtained a **Secret** Fish \n\n🐟 **Fish Name: \n** %s\n⚖️ **Weight:** \n%s kg\n✨ **Mutation:** \n%s", user, fishClean, weight, mutate),
                            ["type"] = "rich",
                            ["color"] = 0x27F5BB
                        }}
                    })
                })
            end

            local proxyUrl = webhook_url:gsub("discord.com", "hooks.hyra.io")
            local success, res = pcall(function() return requestData(proxyUrl) end)
            if not success or (res and res.StatusCode ~= 204) then
                pcall(function() return requestData(webhook_url) end)
            end
        end)
    end
end

local function handleRemote(remote)
    local function onTrigger(...)
        -- Validasi Filter Nama Remote (CaughtFishVisual)
        local filterText = G2L["FilterInput"].Text or ""
        local isMatch = true
        
        if filterActive and filterText ~= "" then
            if not string.find(string.lower(remote.Name), string.lower(filterText)) then
                isMatch = false
            end
        end

        -- Generate kode remote
        local path = getPathToInstance(remote)
        local argsString = table.concat(Format({...}), ",\n    ")
        local method = remote:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
        
        local generatedCode = string.format("local args = {\n    %s\n}\n%s:%s(unpack(args))", argsString, path, method)
        
        -- Update UI
        _G.Code = generatedCode

        -- JALANKAN OTOMATIS JIKA MATCH FILTER
        if isMatch then
            autoSendWebhook(generatedCode)
        end

        -- Log ke UI list (Tetap ada buat history)
        local newBtn = G2L["e"]:Clone()
        newBtn.Text = remote.Name
        newBtn.Parent = G2L["d"]
        newBtn.MouseButton1Click:Connect(function()
            _G.Code = generatedCode
            G2L["11"]["Text"] = _G.Code
        end)
    end

    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(onTrigger)
    elseif remote:IsA("RemoteFunction") then
        pcall(function()
            remote.OnClientInvoke = function(...)
                task.spawn(onTrigger, ...) 
                return nil
            end
        end)
    end
end

local function wrapRemotes(folder)
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            handleRemote(obj)
        end
    end
    folder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            handleRemote(descendant)
        end
    end)
end

local folders = {
    game.ReplicatedStorage,
    game.StarterGui,
    game.StarterPack,
    game.StarterPlayer
}

for _, folder in ipairs(folders) do
    wrapRemotes(folder)
    folder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            handleRemote(descendant)
        end
    end)
end

return G2L["1"], require;
