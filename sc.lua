--[[ 
    AdvancedSpy - Single Script Edition
    Modified to Decrypt Luraph/Encrypted Remotes
]]

local AdvancedSpy = {
    Version = "1.0.0",
    Enabled = true,
    RemoteLog = {},
}

-- 1. UI SIMPLE REPLACEMENT (Karena modul UIComponents kamu tidak ada)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AdvancedSpy_Luraph"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true -- Agar bisa digeser di mobile/PC

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = " ADVANCED SPY v1.0.0 - LURAPH DECRYPTOR"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local LogScroll = Instance.new("ScrollingFrame", Main)
LogScroll.Size = UDim2.new(0, 160, 1, -40)
LogScroll.Position = UDim2.new(0, 5, 0, 35)
LogScroll.CanvasSize = UDim2.new(0, 0, 20, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local ListLayout = Instance.new("UIListLayout", LogScroll)
ListLayout.Padding = UDim.new(0, 5)

local CodeBox = Instance.new("TextBox", Main)
CodeBox.Size = UDim2.new(1, -180, 1, -40)
CodeBox.Position = UDim2.new(0, 170, 0, 35)
CodeBox.MultiLine = true
CodeBox.TextSize = 12
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CodeBox.TextColor3 = Color3.fromRGB(0, 255, 0)
CodeBox.Text = "-- Klik remote di list untuk melihat code --"
CodeBox.ClearTextOnFocus = false

-- 2. HELPER: FORMAT DATA (Pengganti ScriptGenerator)
local function formatTable(t, indent)
    indent = indent or 1
    local res = "{\n"
    for k, v in pairs(t) do
        local key = type(k) == "string" and '["'..k..'"]' or "["..tostring(k).."]"
        local val = type(v) == "string" and '"'..v..'"' or tostring(v)
        if type(v) == "table" then val = formatTable(v, indent + 1) end
        res = res .. string.rep("  ", indent) .. key .. " = " .. val .. ",\n"
    end
    return res .. string.rep("  ", indent-1) .. "}"
end

-- 3. CORE: THE INTERCEPTOR (Nama remote aneh akan tetap tertangkap di sini)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if AdvancedSpy.Enabled and (method == "FireServer" or method == "InvokeServer") then
        task.spawn(function()
            local remoteName = self.Name
            local remotePath = self:GetFullName()
            
            -- Buat Tombol Log
            local btn = Instance.new("TextButton", LogScroll)
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Text = remoteName
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(1, 1, 1)

            -- Warnai kuning jika nama terindikasi enkripsi (banyak simbol)
            if string.find(remoteName, "[^%w%s]") then
                btn.BackgroundColor3 = Color3.fromRGB(100, 80, 0)
            end

            btn.MouseButton1Click:Connect(function()
                local code = string.format("-- Remote: %s\nlocal args = %s\ngame.%s:%s(unpack(args))", 
                    remoteName, formatTable(args), remotePath, method)
                CodeBox.Text = code
                if setclipboard then setclipboard(code) end -- Auto copy
            end)
        end)
    end
    return oldNamecall(self, ...)
end)

print("[AdvancedSpy] Loaded and Intercepting...")
