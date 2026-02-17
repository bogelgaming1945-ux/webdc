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
   Name = "Toggle Enable",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})
