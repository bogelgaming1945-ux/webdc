--[[
    AdvancedSpy - Luraph Decryptor Edition
    Versi utuh tanpa perlu module eksternal.
]]

local G2L = {}
_G.Code = ""

-- =======================================================
-- 1. UI SETUP (Bagian ScreenGui kamu)
-- =======================================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RemoteSpy_Luraph"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 425, 0, 253)
MainFrame.Position = UDim2.new(0.02, 0, 0.17, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
MainFrame.BorderSizePixel = 0

-- List Remote (ScrollingFrame)
local LogList = Instance.new("ScrollingFrame", MainFrame)
LogList.Size = UDim2.new(0, 152, 0, 220)
LogList.Position = UDim2.new(0, 0, 0.1, 0)
LogList.CanvasSize = UDim2.new(0, 0, 10, 0)
LogList.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
LogList.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", LogList)
Layout.Padding = UDim.new(0, 2)

-- Preview Code (TextBox)
local CodeDisplay = Instance.new("TextBox", MainFrame)
CodeDisplay.Size = UDim2.new(0, 260, 0, 220)
CodeDisplay.Position = UDim2.new(0.38, 0, 0.1, 0)
CodeDisplay.MultiLine = true
CodeDisplay.TextXAlignment = Enum.TextXAlignment.Left
CodeDisplay.TextYAlignment = Enum.TextYAlignment.Top
CodeDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
CodeDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeDisplay.Text = "-- Klik remote di kiri untuk melihat isi --"
CodeDisplay.ClearTextOnFocus = false
CodeDisplay.TextSize = 12

-- Tombol Contoh (Template)
local ButtonTemplate = Instance.new("TextButton")
ButtonTemplate.Size = UDim2.new(1, 0, 0, 25)
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.TextSize = 10

-- =======================================================
-- 2. HELPER FUNCTIONS (Formatting & Path)
-- =======================================================
local function getPath(obj)
    local path = {}
    local curr = obj
    while curr and curr ~= game do
        local name = curr.Name
        if name:find("^%d") or name:find("[^%w]") then
            name = '["' .. name .. '"]'
        elseif curr ~= game then
            name = (curr == game and "" or ".") .. name
        end
        table.insert(path, 1, name)
        curr = curr.Parent
    end
    local res = table.concat(path):gsub("^%.", "game.")
    return res
end

local function formatTable(t, indent)
    indent = indent or 1
    local s = "{\n"
    for k, v in pairs(t) do
        local formatting = string.rep("    ", indent) .. "[" .. (type(k) == "string" and '"' .. k .. '"' or tostring(k)) .. "] = "
        if type(v) == "table" then
            s = s .. formatting .. formatTable(v, indent + 1) .. ",\n"
        elseif type(v) == "string" then
            s = s .. formatting .. '"' .. v .. '"' .. ",\n"
        else
            s = s .. formatting .. tostring(v) .. ",\n"
        end
    end
    return s .. string.rep("    ", indent - 1) .. "}"
end

-- =======================================================
-- 3. THE CORE: LURAPH DECRYPTOR (NAMECALL HOOK)
-- =======================================================
-- Bagian ini mencegat remote TEPAT saat game memanggilnya.
-- Ini bypass enkripsi nama karena kita mengambil 'self' (objek asli).

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if (method == "FireServer" or method == "InvokeServer") and self:IsA("Instance") then
        task.spawn(function()
            -- Buat Tombol Baru di List
            local newBtn = ButtonTemplate:Clone()
            newBtn.Text = "[" .. method:sub(1,1) .. "] " .. self.Name
            newBtn.Parent = LogList
            
            -- Jika nama remote aneh/encrypt, beri warna berbeda
            if self.Name:find("[^%w%s]") then
                newBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 0)
            end

            -- Logika saat tombol diklik
            local formattedArgs = formatTable(args)
            local path = getPath(self)
            local finalCode = string.format("-- Remote Spy Decrypted\nlocal args = %s\n\n%s:%s(unpack(args))", formattedArgs, path, method)

            newBtn.MouseButton1Click:Connect(function()
                CodeDisplay.Text = finalCode
                setclipboard(finalCode) -- Otomatis copy ke clipboard
            end)
        end)
    end
    return oldNamecall(self, ...)
end)

print("AdvancedSpy Luraph Decryptor Loaded!")
