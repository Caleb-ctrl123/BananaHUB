local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local BananaUI = {}
BananaUI.__index = BananaUI

local function BananaBoot(introText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BananaBoot"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        elseif gethui then
            ScreenGui.Parent = gethui()
            return
        end
    end)

    if not ScreenGui.Parent then
        ScreenGui.Parent = game.CoreGui
    end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 150)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Banana UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 28
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.Parent = Frame

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 30)
    Subtitle.Position = UDim2.new(0, 0, 0, 60)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = introText or "Loading..."
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 16
    Subtitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    Subtitle.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 1, -20)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(Bar, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(1, 0, 0, 6)
    }):Play()

    task.wait(1.4)

    TweenService:Create(Frame, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(Title, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(Subtitle, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(Bar, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()

    task.wait(0.45)
    ScreenGui:Destroy()
end

local function MakeDraggable(topbar, frame)
    local dragging = false
    local dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local Window = {}
Window.__index = Window

function BananaUI:CreateWindow(options)
    options = options or {}

    BananaBoot(options.IntroText or "Booting Banana...")

    local name = options.Name or "Banana UI"
    local keybind = options.Keybind or Enum.KeyCode.RightShift

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BananaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        elseif gethui then
            ScreenGui.Parent = gethui()
            return
        end
    end)

    if not ScreenGui.Parent then
        ScreenGui.Parent = game.CoreGui
    end

    local MainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 6) })
    })

    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
    }, {
        create("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
    })

    TopBar.Parent = MainFrame
    
    MakeDraggable(TopBar, MainFrame)

    local TabHolder = create("Frame", {
        Size = UDim2.new(0, 120, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
        })
    })

    local PageHolder = create("Frame", {
        Size = UDim2.new(1, -120, 1, -30),
        Position = UDim2.new(0, 120, 0, 30),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })

    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = PageHolder

    TabHolder.Parent = MainFrame
    PageHolder.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local windowObj = setmetatable({
        _gui = ScreenGui,
        _main = MainFrame,
        _tabHolder = TabHolder,
        _pagesFolder = Pages,
        _currentTab = nil,
        _keybind = keybind,
    }, Window)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == keybind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return windowObj
end

local Tab = {}
Tab.__index = Tab

function Window:CreateTab(options)
    options = options or {}
    local name = options.Name or "Tab"

    local TabButton = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Text = name,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        AutoButtonColor = false,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 4) })
    })

    TabButton.Parent = self._tabHolder

    local Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        BackgroundTransparency = 1,
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
        })
    })

    Page.Parent = self._pagesFolder

    local tabObj = setmetatable({
        _window = self,
        _button = TabButton,
        _page = Page,
    }, Tab)

    TabButton.MouseButton1Click:Connect(function()
        for _, page in ipairs(self._pagesFolder:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.Visible = false
            end
        end
        Page.Visible = true

        for _, btn in ipairs(self._tabHolder:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        self._currentTab = tabObj
    end)

    if not self._currentTab then
        TabButton.MouseButton1Click:Fire()
    end

    return tabObj
end

function Tab:CreateButton(options)
    options = options or {}
    local name = options.Name or "Button"
    local callback = options.Callback or function() end

    local Button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = name,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        AutoButtonColor = false,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 4) })
    })

    Button.Parent = self._page

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.08), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        }):Play()
        task.delay(0.1, function()
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            }):Play()
        end)
        callback()
    end)

    return Button
end

function Tab:CreateToggle(options)
    options = options or {}
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end

    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
    })

    local Background = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 4) })
    })

    local Label = create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local ToggleButton = create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundColor3 = default and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(70, 70, 70),
        Text = "",
        AutoButtonColor = false,
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    Label.Parent = Background
    ToggleButton.Parent = Background
    Background.Parent = Holder
    Holder.Parent = self._page

    local state = default
    callback(state)

    local function setState(newState)
        state = newState
        TweenService:Create(ToggleButton, TweenInfo.new(0.12), {
            BackgroundColor3 = state and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(70, 70, 70)
        }):Play()
        callback(state)
    end

    ToggleButton.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return {
        Set = setState,
        Get = function() return state end,
    }
end

function Tab:CreateSlider(options)
    options = options or {}
    local name = options.Name or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local increment = options.Increment or 1
    local callback = options.Callback or function() end

    local Holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
    })

    local Label = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = name .. " (" .. tostring(default) .. ")",
        TextColor3 = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local BarBackground = create("Frame", {
        Size = UDim2.new(1, -16, 0, 8),
        Position = UDim2.new(0, 8, 0, 22),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local Fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        BorderSizePixel = 0,
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    Fill.Parent = BarBackground
    Label.Parent = Holder
    BarBackground.Parent = Holder
    Holder.Parent = self._page

    local dragging = false
    local value = default

    local function setValueFromX(x)
        local rel = math.clamp((x - BarBackground.AbsolutePosition.X) / BarBackground.AbsoluteSize.X, 0, 1)
        local raw = min + (max - min) * rel
        local snapped = math.floor(raw / increment + 0.5) * increment
        snapped = math.clamp(snapped, min, max)
        value = snapped
        Label.Text = name .. " (" .. tostring(value) .. ")"
        TweenService:Create(Fill, TweenInfo.new(0.05), {
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        }):Play()
        callback(value)
    end

    BarBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setValueFromX(input.Position.X)
        end
    end)

    BarBackground.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        setValueFromX(input.Position.X)
    end
end)

task.defer(function()
    if BarBackground.AbsoluteSize.X > 0 then
        setValueFromX(
            BarBackground.AbsolutePosition.X +
            BarBackground.AbsoluteSize.X * ((default - min) / (max - min))
        )
    end
end)

return {
    Set = function(v)
        v = math.clamp(v, min, max)
        value = v
        Label.Text = name .. " (" .. tostring(value) .. ")"
        Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        callback(value)
    end,
    Get = function()
        return value
    end
}
end

return BananaUI
