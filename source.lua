local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CorrectKey = "Kf8@Qw2!Zp5_Rt1#Xm9Vc4"

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "BananaKeySystem"
KeyGui.Parent = PlayerGui
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 320, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyFrame.ClipsDescendants = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamSemibold
KeyTitle.Text = "Enter Key"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextScaled = true

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = KeyFrame
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KeyBox.PlaceholderText = "Key Here"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextScaled = true
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

local KeySubmit = Instance.new("TextButton")
KeySubmit.Parent = KeyFrame
KeySubmit.Size = UDim2.new(0.8, 0, 0, 40)
KeySubmit.Position = UDim2.new(0.1, 0, 0.75, 0)
KeySubmit.BackgroundColor3 = Color3.fromRGB(255, 225, 0)
KeySubmit.Text = "Unlock"
KeySubmit.Font = Enum.Font.GothamSemibold
KeySubmit.TextScaled = true
KeySubmit.TextColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 10)

local Theme = {
    Background = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(255, 225, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Corner = 12,
    Font = Enum.Font.GothamSemibold
}

local BananaUI = {}
BananaUI.__index = BananaUI

function BananaUI:Init(titleText)
    local self = setmetatable({}, BananaUI)

    local gui = Instance.new("ScreenGui")
    gui.Name = "BananaUIV4"
    gui.Parent = PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.Gui = gui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = gui
    main.Size = UDim2.new(0, 520, 0, 340)
    main.Position = UDim2.new(0.5, -260, 0.5, -170)
    main.BackgroundColor3 = Theme.Background
    main.BackgroundTransparency = 1
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, Theme.Corner)

    local top = Instance.new("Frame")
    top.Name = "TopBar"
    top.Parent = main
    top.Size = UDim2.new(1, 0, 0, 40)
    top.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, Theme.Corner)

    local title = Instance.new("TextLabel")
    title.Parent = top
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Theme.Font
    title.Text = titleText or "BananaUI V4"
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextScaled = true

    local close = Instance.new("TextButton")
    close.Parent = top
    close.Size = UDim2.new(0, 40, 1, 0)
    close.Position = UDim2.new(1, -40, 0, 0)
    close.BackgroundTransparency = 1
    close.Font = Theme.Font
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(0, 0, 0)
    close.TextScaled = true

    close.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.25)
        gui:Destroy()
    end)

    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Parent = main
    tabs.Size = UDim2.new(0, 140, 1, -40)
    tabs.Position = UDim2.new(0, 0, 0, 40)
    tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, Theme.Corner)

    local tabList = Instance.new("UIListLayout", tabs)
    tabList.Padding = UDim.new(0, 6)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder

    local pages = Instance.new("Frame")
    pages.Name = "Pages"
    pages.Parent = main
    pages.Size = UDim2.new(1, -140, 1, -40)
    pages.Position = UDim2.new(0, 140, 0, 40)
    pages.BackgroundTransparency = 1

    local pageLayout = Instance.new("UIPageLayout", pages)
    pageLayout.TweenTime = 0.35
    pageLayout.EasingStyle = Enum.EasingStyle.Quad

    self.Main = main
    self.Tabs = tabs
    self.Pages = pages
    self.PageLayout = pageLayout

    -- opening tween
    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 340),
        BackgroundTransparency = 0
    }):Play()

    return self
end

function BananaUI:CreateTab(tabName)
    local tab = Instance.new("TextButton")
    tab.Parent = self.Tabs
    tab.Size = UDim2.new(1, -10, 0, 40)
    tab.Position = UDim2.new(0, 5, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tab.Font = Theme.Font
    tab.Text = tabName
    tab.TextColor3 = Theme.Text
    tab.TextScaled = true
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, Theme.Corner)

    local page = Instance.new("Frame")
    page.Parent = self.Pages
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    tab.MouseButton1Click:Connect(function()
        self.PageLayout:JumpTo(page)
    end)

    local tabObj = {}
    tabObj.Page = page

    function tabObj:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = page
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Font = Theme.Font
        btn.Text = text
        btn.TextColor3 = Theme.Text
        btn.TextScaled = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, Theme.Corner)

        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    return tabObj
end

local function unlock()
    TweenService:Create(KeyFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 320, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.35)
    KeyGui:Destroy()

    local win = BananaUI:Init("BananaUI V4")

    local mainTab = win:CreateTab("Main")
    mainTab:AddButton("Unlocked!", function()
        print("Key accepted, BananaUI V4 loaded.")
    end)

    local miscTab = win:CreateTab("Misc")
    miscTab:AddButton("Print Player Name", function()
        print("Player:", Player.Name)
    end)
end

KeySubmit.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        unlock()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Invalid Key"
        TweenService:Create(KeyBox, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        }):Play()
        task.wait(0.15)
        TweenService:Create(KeyBox, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        }):Play()
    end
end)
