--// BananaUI Framework v1.0
local BananaUI = {}
BananaUI.__index = BananaUI

--// Safe parent (supports gethui)
local function SafeParent(gui)
    local ok = pcall(function()
        gui.Parent = gethui()
    end)
    if not ok then
        gui.Parent = game.CoreGui
    end
end

--// Create Window
function BananaUI:CreateWindow(title)
    local self = setmetatable({}, BananaUI)

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "BananaUI"
    gui.ResetOnSpawn = false
    SafeParent(gui)

    -- Main Window
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 400, 0, 300)
    main.Position = UDim2.new(0.5, -200, 1.2, 0) -- start off-screen
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.BackgroundTransparency = 1
    main.Parent = gui

    -- Smooth fade + slide animation
    task.spawn(function()
        for i = 1, 20 do
            local alpha = i / 20
            main.BackgroundTransparency = 1 - alpha
            main.Position = main.Position:Lerp(
                UDim2.new(0.5, -200, 0.5, -150),
                alpha
            )
            task.wait(0.02)
        end
    end)

    -- Title Bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 0)
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 18
    titleBar.Parent = main

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = main

    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)

    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 24
    minimizeBtn.Parent = main

    minimizeBtn.MouseEnter:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)

    minimizeBtn.MouseButton1Click:Connect(function()
        if self.Minimized then
            self:Restore()
        else
            self:Minimize()
        end
    end)

    -- Draggable Window
    local UIS = game:GetService("UserInputService")
    local dragging = false
    local dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- UI Toggle Keybind (RightShift)
    local uiVisible = true
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            uiVisible = not uiVisible
            gui.Enabled = uiVisible
        end
    end)

    -- Tab + Page Holders
    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(0, 120, 1, -30)
    tabHolder.Position = UDim2.new(0, 0, 0, 30)
    tabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabHolder.Parent = main

    local pageHolder = Instance.new("Frame")
    pageHolder.Size = UDim2.new(1, -120, 1, -30)
    pageHolder.Position = UDim2.new(0, 120, 0, 30)
    pageHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    pageHolder.Parent = main

    -- Store references
    self.Gui = gui
    self.Main = main
    self.TabHolder = tabHolder
    self.PageHolder = pageHolder
    self.Tabs = {}

    return self
end

--// Close Animation
function BananaUI:Close()
    local main = self.Main
    local gui = self.Gui

    local startPos = main.Position
    local endPos = UDim2.new(0.5, -200, 1.2, 0)

    task.spawn(function()
        for i = 1, 20 do
            local alpha = i / 20
            main.BackgroundTransparency = alpha
            main.Position = startPos:Lerp(endPos, alpha)
            task.wait(0.02)
        end
        gui:Destroy()
    end)
end

--// Minimize Animation
function BananaUI:Minimize()
    local main = self.Main
    local startPos = main.Position
    local endPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, 1.2, 0)

    if self.Minimized then return end
    self.Minimized = true

    task.spawn(function()
        for i = 1, 20 do
            local alpha = i / 20
            main.BackgroundTransparency = alpha
            main.Position = startPos:Lerp(endPos, alpha)
            task.wait(0.02)
        end
        main.Visible = false
    end)
end

--// Restore Animation
function BananaUI:Restore()
    local main = self.Main
    local endPos = UDim2.new(0.5, -200, 0.5, -150)
    local startPos = UDim2.new(0.5, -200, 1.2, 0)

    if not self.Minimized then return end
    self.Minimized = false

    main.Visible = true
    main.Position = startPos
    main.BackgroundTransparency = 1

    task.spawn(function()
        for i = 1, 20 do
            local alpha = i / 20
            main.BackgroundTransparency = 1 - alpha
            main.Position = startPos:Lerp(endPos, alpha)
            task.wait(0.02)
        end
    end)
end

--// CreateTab
function BananaUI:CreateTab(name)
    local tab = {}

    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.Parent = self.TabHolder

    -- Page Frame
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    page.Visible = false
    page.Parent = self.PageHolder

    -- UIListLayout for stacking controls
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page

    -- Tab switching
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
        end
        page.Visible = true
    end)

    tab.Button = tabBtn
    tab.Page = page
    table.insert(self.Tabs, tab)

    return tab
end

--// CreateButton
function BananaUI:CreateButton(tab, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = tab.Page

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    btn.MouseButton1Click:Connect(callback)
end

return BananaUI
