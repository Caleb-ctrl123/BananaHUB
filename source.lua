--// BananaUI 3.0 — Clean Top Tab Layout
local BananaUI = {}
BananaUI.__index = BananaUI

--// Create Window
function BananaUI:CreateWindow(title)
    local self = setmetatable({}, BananaUI)

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "BananaUI"
    gui.ResetOnSpawn = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = game.CoreGui

    -- Main Window
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 450, 0, 350)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.BorderSizePixel = 0
    main.Parent = gui

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Parent = main

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "BananaUI 3.0"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -32, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar

    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(188, 188, 0)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 0)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)

    --------------------------------------------------------------------
    -- DRAGGING
    --------------------------------------------------------------------
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

    --------------------------------------------------------------------
    -- TAB BAR
    --------------------------------------------------------------------
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 32)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main

    local activeTab = nil
    local nextTabX = 10

    --------------------------------------------------------------------
    -- CREATE TAB
    --------------------------------------------------------------------
    function self:CreateTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 90, 0, 24)
        tabButton.Position = UDim2.new(0, nextTabX, 0, 3)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 0)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabBar

        nextTabX = nextTabX + 100

        -- Content Frame
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, -20, 1, -70)
        tabFrame.Position = UDim2.new(0, 10, 0, 70)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = main

        local tabY = 0

        ----------------------------------------------------------------
        -- TAB BUTTON CREATOR
        ----------------------------------------------------------------
        function tabFrame:CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 400, 0, 32)
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

        ----------------------------------------------------------------
        -- TAB SLIDER IMPORTER
        ----------------------------------------------------------------
        function tabFrame:AddSlider(slider)
            slider.Parent = tabFrame
            slider.Position = UDim2.new(0, 0, 0, tabY)
            tabY = tabY + 60
        end

        ----------------------------------------------------------------
        -- TAB SWITCHING
        ----------------------------------------------------------------
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

    --------------------------------------------------------------------
    -- SLIDER CREATION (GLOBAL)
    --------------------------------------------------------------------
    function self:CreateSlider(text, min, max, default, callback)
        min = min or 0
        max = max or 100
        default = default or min

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0, 400, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BorderSizePixel = 0

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. " (" .. tostring(default) .. ")"
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = sliderFrame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -20, 0, 10)
        bar.Position = UDim2.new(0, 10, 0, 30)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        bar.BorderSizePixel = 0
        bar.Parent = sliderFrame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(188, 188, 0)
        fill.BorderSizePixel = 0
        fill.Parent = bar

        local dragging = false

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)

                local value = math.floor(min + (max - min) * rel)
                label.Text = text .. " (" .. tostring(value) .. ")"

                if callback then task.spawn(function() callback(value) end) end
            end
        end)

        return sliderFrame
    end

    self.Gui = gui
    self.Main = main

    return self
end

--------------------------------------------------------------------
-- CLOSE FUNCTION (SLIDE DOWN)
--------------------------------------------------------------------
function BananaUI:Close()
    if not self.Main or not self.Gui then return end

    local main = self.Main
    local gui = self.Gui
    local startY = main.Position.Y.Offset

    for i = 1, 20 do
        local alpha = i / 20

        main.Position = UDim2.new(
            main.Position.X.Scale,
            main.Position.X.Offset,
            main.Position.Y.Scale,
            startY + (alpha * 60)
        )

        main.BackgroundTransparency = alpha
        for _, v in ipairs(main:GetDescendants()) do
            if v:IsA("GuiObject") then
                v.BackgroundTransparency = alpha
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    v.TextTransparency = alpha
                end
            end
        end

        task.wait(0.015)
    end

    gui:Destroy()
end

return BananaUI
