--// BananaUI 2.0 — Single File Executor Version
local BananaUI = {}
BananaUI.__index = BananaUI

function BananaUI:CreateWindow(title)
    local self = setmetatable({}, BananaUI)

    local gui = Instance.new("ScreenGui")
    gui.Name = "BananaUI"
    gui.ResetOnSpawn = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = game.CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 300)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.BorderSizePixel = 0
    main.Parent = gui

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Text = title or "BananaUI 2.0"
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 0)
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 18
    titleBar.Parent = main

	-- TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 32)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabs = {}
local activeTab = nil
local nextTabX = 10

function self:CreateTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 0, 24)
    tabButton.Position = UDim2.new(0, nextTabX, 0, 3)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 0)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    tabButton.Parent = tabBar

    nextTabX = nextTabX + 90

    -- content frame
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 1, -70)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = main

    -- Y offset for this tab
    local tabY = 0

    function tabFrame:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 380, 0, 32)
        btn.Position = UDim2.new(0, 0, 0, tabY)
        btn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(20, 20, 20)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Parent = tabFrame

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(188, 188, 0)
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
        end)

        btn.MouseButton1Click:Connect(function()
            if callback then task.spawn(callback) end
        end)

        tabY = tabY + 40
        return btn
    end

    function tabFrame:AddSlider(sliderFrame)
        sliderFrame.Parent = tabFrame
        sliderFrame.Position = UDim2.new(0, 0, 0, tabY)
        tabY = tabY + 60
    end

    tabButton.MouseButton1Click:Connect(function()
        if activeTab then activeTab.Visible = false end
        activeTab = tabFrame
        tabFrame.Visible = true
    end)

    if not activeTab then
        activeTab = tabFrame
        tabFrame.Visible = true
    end

    return tabFrame
end

    -- dragging
    local UIS = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos

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

    -- button system
    local buttonY = 40

    function self:CreateButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 380, 0, 32)
        btn.Position = UDim2.new(0, 20, 0, buttonY)
        btn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
        btn.Text = text or "Button"
        btn.TextColor3 = Color3.fromRGB(20, 20, 20)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Parent = main

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(188, 188, 0)
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
        end)

        btn.MouseButton1Click:Connect(function()
            if callback then task.spawn(callback) end
        end)

        buttonY = buttonY + 40
        return btn
    end

    self.Gui = gui
    self.Main = main

    return self
end

return BananaUI
