local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Webhook Hub",
   LoadingTitle = "Webhook Hub",
   LoadingSubtitle = "by Boba",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Webhook Hub"
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
