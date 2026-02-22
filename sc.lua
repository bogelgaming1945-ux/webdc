---@diagnostic disable: deprecated
---@diagnostic disable: undefined-global

--- ===========================
--- FISH TABLES
--- ===========================
local SecretFish = {
    "Heart Walrus", "Heart Octopus", "Heart Dolphin", "Strawberry Pufferfish",  "Strawberry Seahorse",
    "Cutsie Fish", "Cupid Octopus", "Lovtopus", "Red Rose", "Rose Bouquet", "Rose Swordfish", 
    "Heartbreak Nessie", "Love Nessie"
}

local MissionItems1 = {"Ruby"}
local MissionItems2 = {
    "Biolumiscent Octous", "Blossom Jelly", "Star Snail", 
    "Blue Sea Dragon", "Cute Dumbo"
}

--- ===========================
--- USED VARIABLES
--- ===========================
_G.Code = ""
local webhook_url = ""

local req = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request

local HttpService = game:GetService("HttpService")

local whfishEnabled = false
local whmissionEnabled = false
local filterActive = true

local folders = {
    game.ReplicatedStorage,
    game.StarterGui,
    game.StarterPack,
    game.StarterPlayer
}

--- ===========================
--- HELPER FUNCTIONS
--- ===========================
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
        return tostring(value)
    elseif typeof(value) == "Instance" then
        return getPathToInstance(value)
    elseif typeof(value) == "table" then
        local s = "{"
        local isFirst = true
        for k, v in pairs(value) do
            if not isFirst then 
                s = s .. ", " 
            end
            local kType = typeof(k)
            local key = (kType == "string" and string.format("[%q]", k)) or string.format("[%d]", k)
            s = s .. key .. " = " .. formatValue(v)
            isFirst = false
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

--- ===========================
--- MAIN FUNCTIONS
--- ===========================
local function autoSendWebhook(codeContent)
   if not whfishEnabled then return end
    -- parsing data
    local user = codeContent:match("Players%.([^%(%s%],]+)") or "Unknown"
    local fishRaw = codeContent:match('%[3%]%s*=%s*"([^"]+)"') or "Not Found"
    local weight = codeContent:match('%["Weight"%]%s*=%s*([%d%.]+)') or "0"
    local mutate = codeContent:match('%["VariantId"%]%s*=%s*"([^"]+)"') or "None"

    local fishClean = fishRaw:gsub("%b()", ""):gsub("^%s*(.-)%s*$", "%1")

    local isSecret = false

    for _, name in pairs(SecretFish) do
        if string.find(string.lower(fishClean), string.lower(name)) then
            isSecret = true
            break
        end
    end

    if isSecret then
        task.spawn(function()
            local function requestData(url)
                return req({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode({
						["embeds"] = {{
							["title"] = "🍑 Boba Webhook | Notification",
                            ["description"] = string.format("💐 Congratulation 💐\n**%s** obtained a **Secret** Fish \n", user),
							["color"] = 0x27F5BB,
							["fields"] = {
								{
									["name"] = "🐟 **Fish Name :**",
									["value"] = "┃ " .. fishClean,
									["inline"] = false
								},
								{
									["name"] = "⚖️ **Weight :**",
									["value"] = "┃ " .. weight .. " Kg",
									["inline"] = false
								},
								{
									["name"] = "✨ **Mutation :**",
									["value"] = "┃ " .. mutate,
									["inline"] = false
								}
							},
							["footer"] = {
								["text"] = "🍑 Boba Hub | Fish It Webhook",
							},
							["timestamp"] = DateTime.now():ToIsoDate()
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

local function autoSendMission(codeContent)
   if not whmissionEnabled then return end
   -- parsing data
   local user = codeContent:match("Players%.([^%(%s%],]+)") or "Unknown"
   local fishRaw = codeContent:match('%[3%]%s*=%s*"([^"]+)"') or "Not Found"
   local weight = codeContent:match('%["Weight"%]%s*=%s*([%d%.]+)') or "0"
   local mutate = codeContent:match('%["VariantId"%]%s*=%s*"([^"]+)"') or "None"

   local fishClean = fishRaw:gsub("%b()", ""):gsub("^%s*(.-)%s*$", "%1")

   local isMissionGs = false
   local isMissionCs = false

   for _, name in pairs(MissionItems1) do
      if string.find(string.lower(fishClean), string.lower(name)) then
         if mutate == "Gemstone" then
            isMissionGs = true
         end
         break
      end
   end
   for _, name in pairs(MissionItems2) do
      if string.find(string.lower(fishClean), string.lower(name)) then
         if mutate == "Crystalized" then
            isMissionCs = true
         end
         break
      end
   end

   if isMissionGs then
      task.spawn(function()
         local function requestData(url)
               return req({
                  Url = url,
                  Method = "POST",
                  Headers = {["Content-Type"] = "application/json"},
                  Body = game:GetService("HttpService"):JSONEncode({
                     ["embeds"] = {{
                           ["title"] = "🍑 Boba Webhook | Notification",
                           ["description"] = string.format("Congratulation, **%s** obtained a **Diamond Rod Mission** Items \n\n🐟 **Item Name:**\n%s\n✨ **Mutation:**\n%s", user, fishClean, mutate),
                           ["type"] = "rich",
                           ["color"] = 0xF5DD27
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

   if isMissionCs then
      task.spawn(function()
         local function requestData(url)
               return req({
                  Url = url,
                  Method = "POST",
                  Headers = {["Content-Type"] = "application/json"},
                  Body = game:GetService("HttpService"):JSONEncode({
                     ["embeds"] = {{
                           ["title"] = "🍑 Boba Webhook | Notification",
                           ["description"] = string.format("Congratulation, **%s** obtained a **Aetherion Bait Mission** Items \n\n🐟 **Item Name:**\n%s\n✨ **Mutation:**\n%s", user, fishClean, mutate),
                           ["type"] = "rich",
                           ["color"] = 0xF5DD27
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
        -- Menghapus filter filterText agar semua tertangkap
        local path = getPathToInstance(remote)
        local argsString = table.concat(Format({...}), ",\n    ")
        local method = remote:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
        
        local generatedCode = string.format("local args = {\n    %s\n}\n%s:%s(unpack(args))", argsString, path, method)
        
        _G.Code = generatedCode

        -- Panggil fungsi tanpa argumen tambahan (Hanya generatedCode)
        autoSendWebhook(generatedCode)
        autoSendMission(generatedCode)
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

local function send_note(content)
   if webhook_url == "" then 
      warn("[FishLogger] No WEBHOOK_URL set") 
      return false 
   end

   local requestFunc = req
   if not requestFunc then 
      warn("[FishLogger] No HTTP request function available") 
      return false 
   end

   local payload = {
      Url = webhook_url,
      Method = "POST",
      Headers = { ["Content-Type"] = "application/json" },
      Body = HttpService:JSONEncode({ 
         ["embeds"] = {{
               ["title"] = "🍑 Boba Webhook | Notification",
               ["description"] = content,
               ["type"] = "rich",
               ["color"] = 0x2DE04D
         }}
      }),
   }

   local ok, res = pcall(function() 
      return requestFunc(payload) 
   end)

   if not ok then
      warn("[FishLogger] Request failed: " .. tostring(res))
      return false
   end

   if typeof(res) == "table" then
      local code = res.StatusCode or res.status or res.Status
      if code == 200 or code == 204 then 
         return true 
      end
   elseif res == true then
      return true
   end

   return false
end

for _, folder in ipairs(folders) do
   wrapRemotes(folder)
   folder.DescendantAdded:Connect(function(descendant)
      if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
         handleRemote(descendant)
      end
   end)
end

--- ===========================
--- MAIN UI
--- ===========================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Boba Hub",
   LoadingTitle = "Boba Hub",
   LoadingSubtitle = "by Boba",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BobaHubConfig",
      FileName = "MainConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "2juPPG6v9U",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Boba Key",
      Subtitle = "Key System",
      Note = "Join discord: discord.gg/2juPPG6v9U",
      FileName = "BobaKey",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/XZfU1EpU"}
   }
})

local Tab = Window:CreateTab("Main", 4483362458)

Rayfield:Notify({ Title = "Notification", Content = "Scripts loaded", Duration = 5 })

local WhStatus = Tab:CreateParagraph({
    Title = "Status Webhook:", 
    Content = "Belum Terpasang ❌"
})

local Input = Tab:CreateInput({
   Name = "URL Webhook",
   PlaceholderText = "Paste Your URL Here",
   RemoveTextAfterFocusLost = true, 
   Flag = "Input1",
   Callback = function(Text)
      if Text ~= "" and (Text:find("discord.com") or Text:find("hooks.hyra.io")) then
         webhook_url = Text
         
         WhStatus:Set({
            Title = "Status Webhook:", 
            Content = "URL Berhasil Disimpan! ✅"
         })
         
         Rayfield:Notify({ 
            Title = "Success", 
            Content = "Webhook URL Saved!", 
            Duration = 4 
         })
      else
         Rayfield:Notify({ 
            Title = "Invalid", 
            Content = "Link bukan Webhook Discord!", 
            Duration = 4 
         })
      end
   end,
})

local Button1 = Tab:CreateButton({
   Name = "Test Webhook",
   Callback = function()
      if webhook_url == "" then
         Rayfield:Notify({ Title = "Error", Content = "No Webhook URL!", Duration = 4 })
         return
      end
      local success = send_note("✅ **Webhook Test**\nSuccessfully connected.\nServer ID: "..tostring(game.JobId))
      if success then
         Rayfield:Notify({ Title = "Success", Content = "Webhook berhasil dikirim!", Duration = 4 })
      else
         Rayfield:Notify({ Title = "Failed", Content = "Gagal kirim webhook!", Duration = 4 })
      end
   end,
})

--- ===========================
--- TOGGLE SECRET FISH
--- ===========================
local Toggle1 = Tab:CreateToggle({
   Name = "Enable Webhook (Secret)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      if Value then
         if webhook_url == "" then
               Rayfield:Notify({ Title = "Error", Content = "No Webhook URL!", Duration = 4 })
               whfishEnabled = false
               
               task.spawn(function()
                  Toggle1:Set(false) 
               end)
               return
         end

         whfishEnabled = true
         Rayfield:Notify({ Title = "Enabled", Content = "Secret Fish logger aktif.", Duration = 4 })
         
         pcall(function()
               send_note("✅ **Secret Fish Logger** telah diaktifkan\n Server ID: " .. tostring(game.JobId))
         end)
      else
         whfishEnabled = false
         Rayfield:Notify({ Title = "Disabled", Content = "Secret Fish logger nonaktif.", Duration = 4 })
         
         pcall(function()
               send_note("⚠️ **Secret Fish Logger** telah dinonaktifkan.")
         end)
      end
   end,
})

--- ===========================
--- TOGGLE MISSION ITEMS
--- ===========================
local Toggle2 = Tab:CreateToggle({
   Name = "Enable Webhook (Mission)",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
      if Value then
         if webhook_url == "" then
               Rayfield:Notify({ Title = "Error", Content = "No Webhook URL!", Duration = 4 })
               whmissionEnabled = false
               
               task.spawn(function()
                  Toggle2:Set(false)
               end)
               return
         end

         whmissionEnabled = true
         Rayfield:Notify({ Title = "Enabled", Content = "Mission logger aktif.", Duration = 4 })
         
         pcall(function()
               send_note("✅ **Mission Logger** telah diaktifkan\n Server ID: " .. tostring(game.JobId))
         end)
      else
         whmissionEnabled = false
         Rayfield:Notify({ Title = "Disabled", Content = "Mission logger nonaktif.", Duration = 4 })
         
         pcall(function()
               send_note("⚠️ **Mission Logger** telah dinonaktifkan.")
         end)
      end
   end,
})
