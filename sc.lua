local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Boba Hub",
   LoadingTitle = "Boba Hub",
   LoadingSubtitle = "by Boba",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Boba Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinv", -- The discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD.
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Boba Key System",
      Subtitle = "Key System",
      Note = "Join the discord (https://discord.gg/2juPPG6v9U) for the key!",
      FileName = "BobaKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- Set this to false to not save the key to a file
      GrabKeyFromSite = true, -- If true, it will grab the key from the specified website (see Key below)
      Key = "https://pastebin.com/raw/XZfU1EpU" -- If GrabKeyFromSite is true, set this to the URL where the key can be found
   }
})

local Tab = Window:CreateTab("Main", 4483362458)

Rayfield:Notify({
   Title = "Notification",
   Content = "Scripts loaded",
   Duration = 5,
   Image = nil,
})

local WEBHOOK_URL = ""

local Input = Tab:CreateInput({
   Name = "Input URL",
   CurrentValue = "",
   PlaceholderText = "discord webhook URL",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",

   Callback = function(Text)
      WEBHOOK_URL = Text
      Rayfield:Notify({
        Title = "Notification",
        Content = "Webhook URL updated",
        Duration = 5,
        Image = nil,
        })
   end,
})

local HttpService = game:GetService("HttpService")
local webhookEnabled = false
local connection = nil

local Button = Tab:CreateButton({
   Name = "Test Webhook",
   Callback = function()

      if WEBHOOK_URL == "" then
         Rayfield:Notify({
            Title = "Error",
            Content = "Isi dulu Webhook URL!",
            Duration = 4,
         })
         return
      end

      local request = syn and syn.request or request or http_request
      if not request then
         Rayfield:Notify({
            Title = "Error",
            Content = "Executor tidak support HTTP Request!",
            Duration = 4,
         })
         return
      end

      local data = {
         content = "✅ Webhook Connected\nFish Logger is now active.\nServer ID: "..game.JobId
      }

      local response = request({
         Url = WEBHOOK_URL,
         Method = "POST",
         Headers = {
            ["Content-Type"] = "application/json"
         },
         Body = HttpService:JSONEncode(data)
      })

      if response and response.StatusCode == 204 then
         Rayfield:Notify({
            Title = "Success",
            Content = "Webhook berhasil dikirim!",
            Duration = 4,
         })
      else
         Rayfield:Notify({
            Title = "Failed",
            Content = "Gagal kirim webhook!",
            Duration = 4,
         })
      end

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
            Rayfield:Notify({
               Title = "Error",
               Content = "Isi dulu Webhook URL!",
               Duration = 4,
            })
            return
         end

         Rayfield:Notify({
            Title = "Webhook Enabled",
            Content = "Monitoring General chat...",
            Duration = 4,
         })

         -- Connect chat listener dengan error handling
         local success, err = pcall(function()
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local chatEvents = replicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 5)
            
            if chatEvents then
               local onMessageDoneFiltering = chatEvents:WaitForChild("OnMessageDoneFiltering", 5)
               if onMessageDoneFiltering then
                  connection = onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
                     if messageData and messageData.Message and messageData.FromSpeaker then
                        local content = messageData.Message
                        local author = messageData.FromSpeaker
                        local channel = messageData.ChannelName or "Unknown"

                        -- Ambil semua chat dari semua channel
                        local request = syn and syn.request or request or http_request
                        if request and WEBHOOK_URL ~= "" then
                           local data = {
                              content = "[**"..channel.."**] **"..author.."**: "..content
                           }

                           request({
                              Url = WEBHOOK_URL,
                              Method = "POST",
                              Headers = {
                                 ["Content-Type"] = "application/json"
                              },
                              Body = HttpService:JSONEncode(data)
                           })
                        end
                     end
                  end)
               end
            end
         end)
         
         if not success then
            Rayfield:Notify({
               Title = "Error",
               Content = "Chat system tidak ditemukan: "..err,
               Duration = 4,
            })
            webhookEnabled = false
         end

      else
         Rayfield:Notify({
            Title = "Webhook Disabled",
            Content = "Stopped monitoring chat.",
            Duration = 4,
         })

         if connection then
            connection:Disconnect()
            connection = nil
         end
      end
   end,
})
