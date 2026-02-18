local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Boba Hub",
   LoadingTitle = "Boba Hub",
   LoadingSubtitle = "by Boba",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "Boba Key System",
      Subtitle = "Key System",
      Note = "Join the discord (https://discord.gg/2juPPG6v9U) for the key!",
      FileName = "BobaKey",
      SaveKey = false,
      GrabKeyFromSite = true,
      Key = "https://pastebin.com/raw/XZfU1EpU",
   },
})

local Tab = Window:CreateTab("Main", 4483362458)

Rayfield:Notify({ Title = "Notification", Content = "Scripts loaded", Duration = 5 })

local WEBHOOK_URL = ""
local HttpService = game:GetService("HttpService")
local webhookEnabled = false

-- Hook state for CaughtFishVisual
local caughtHookOld = nil
local caughtHookEnabled = false

local function get_request()
   return syn and syn.request or request or http_request
end

local function send_webhook(content)
   local req = get_request()
   if not req or WEBHOOK_URL == "" then return false end
   local ok, res = pcall(function()
      return req({
         Url = WEBHOOK_URL,
         Method = "POST",
         Headers = { ["Content-Type"] = "application/json" },
         Body = HttpService:JSONEncode({ content = content }),
      })
   end)
   if not ok or not res then return false end
   return (res.StatusCode == 204 or res.StatusCode == 200)
end

local Input = Tab:CreateInput({
   Name = "Input URL",
   CurrentValue = "",
   PlaceholderText = "discord webhook URL",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
      WEBHOOK_URL = Text
      Rayfield:Notify({ Title = "Notification", Content = "Webhook URL updated", Duration = 4 })
   end,
})

local Button = Tab:CreateButton({
   Name = "Test Webhook",
   Callback = function()
      if WEBHOOK_URL == "" then
         Rayfield:Notify({ Title = "Error", Content = "Isi dulu Webhook URL!", Duration = 4 })
         return
      end
      local success = send_webhook("✅ Webhook Connected\nFish Logger is now active.\nServer ID: "..tostring(game.JobId))
      if success then
         Rayfield:Notify({ Title = "Success", Content = "Webhook berhasil dikirim!", Duration = 4 })
      else
         Rayfield:Notify({ Title = "Failed", Content = "Gagal kirim webhook!", Duration = 4 })
      end
   end,
})

local function chunk_lines(lines, maxlen)
   maxlen = maxlen or 1800
   local chunks = {}
   local current = ""
   for _, line in ipairs(lines) do
      if #current + #line + 1 > maxlen then
         table.insert(chunks, current)
         current = line .. "\n"
      else
         current = current .. line .. "\n"
      end
   end
   if current ~= "" then table.insert(chunks, current) end
   return chunks
end

local SendNamesButton = Tab:CreateButton({
   Name = "Send All Player Usernames",
   Callback = function()
      if WEBHOOK_URL == "" then
         Rayfield:Notify({ Title = "Error", Content = "Isi dulu Webhook URL!", Duration = 4 })
         return
      end
      local players = game:GetService("Players"):GetPlayers()
      local lines = {}
      for _, p in ipairs(players) do table.insert(lines, tostring(p.Name)) end
      if #lines == 0 then
         Rayfield:Notify({ Title = "Info", Content = "Tidak ada pemain di server.", Duration = 4 })
         return
      end
      local chunks = chunk_lines(lines)
      local okAll = true
      for _, chunk in ipairs(chunks) do
         local content = "**Player Usernames ("..#lines..")**\n```\n"..chunk.."```"
         if not send_webhook(content) then okAll = false end
      end
      Rayfield:Notify({ Title = okAll and "Success" or "Failed", Content = okAll and "Usernames sent to webhook!" or "Beberapa request gagal dikirim ke webhook.", Duration = 4 })
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Enable Webhook",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      webhookEnabled = Value
      if webhookEnabled then
         if WEBHOOK_URL == "" then
            Rayfield:Notify({ Title = "Error", Content = "Isi dulu Webhook URL!", Duration = 4 })
            webhookEnabled = false
            return
         end
         Rayfield:Notify({ Title = "Webhook Enabled", Content = "Fish logger enabled (monitoring fish caught)", Duration = 4 })

         -- send one-time enabled notification to webhook
         pcall(function()
            send_webhook("✅ Fish logger enabled on server: "..tostring(game.JobId))
         end)

         if hookmetamethod and getnamecallmethod and not caughtHookEnabled then
            caughtHookOld = hookmetamethod(game, "__namecall", function(self, ...)
               local method = getnamecallmethod()
               local args = { ... }
               if method == "FireServer" then
                  local okName, instName = pcall(function() return self.Name end)
                  local okFull, fullName = pcall(function() return self:GetFullName() end)
                  local asString = tostring(self)
                  if (okName and instName and tostring(instName):find("CaughtFishVisual")) or (okFull and fullName and tostring(fullName):find("CaughtFishVisual")) or (asString and asString:find("CaughtFishVisual")) then
                     local playerArg = args[1]
                     local playerName = tostring(playerArg)
                     pcall(function()
                        if typeof(playerArg) == "Instance" and playerArg:IsA("Player") then playerName = playerArg.Name end
                     end)
                     local fish = tostring(args[3] or "")
                     local content = "🎣 **CaughtFish**\nPlayer: "..playerName.."\nFish: "..fish
                     local sendOk = false
                     local ok, res = pcall(function() return send_webhook(content) end)
                     if ok and res then
                        sendOk = true
                     end
                     if not sendOk then
                        Rayfield:Notify({ Title = "Webhook Error", Content = "CaughtFish detected but failed to send webhook.", Duration = 4 })
                        warn("[FishLogger] Detected CaughtFish for:", playerName, fish, "but send_webhook failed or returned false")
                     end
                  end
               end
               local ok, ret = pcall(function() return caughtHookOld(self, unpack(args)) end)
               if ok then return ret end
               return nil
            end)
            caughtHookEnabled = true
            Rayfield:Notify({ Title = "Info", Content = "CaughtFish hook installed.", Duration = 4 })
         else
            Rayfield:Notify({ Title = "Info", Content = "Hookmetamethod tidak tersedia; tidak dapat monitor remote CaughtFishVisual.", Duration = 4 })
         end
      else
         Rayfield:Notify({ Title = "Webhook Disabled", Content = "Webhook Disabled.", Duration = 4 })
         if caughtHookEnabled and hookmetamethod and caughtHookOld then
            pcall(function() hookmetamethod(game, "__namecall", caughtHookOld) end)
            caughtHookOld = nil
            caughtHookEnabled = false
         end
      end
   end,
})
