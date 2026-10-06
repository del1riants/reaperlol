local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

local FONT = Font.new("rbxassetid://12187376739")
local BOTTOM_FONT = Font.new("rbxassetid://12187366846")

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function Corner(object, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 4)
    }, object)
end

local function Stroke(object, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(85, 85, 85),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        LineJoinMode = Enum.LineJoinMode.Miter
    }, object)
end

local function Gradient(object, colors, rotation)
    local points = {}

    for i, color in ipairs(colors) do
        local position

        if #colors == 1 then
            position = 0
        else
            position = (i - 1) / (#colors - 1)
        end

        table.insert(points, ColorSequenceKeypoint.new(position, color))
    end

    return Create("UIGradient", {
        Color = ColorSequence.new(points),
        Rotation = rotation or 0
    }, object)
end

function Library:CreateWindow(config)
    config = config or {}

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Destroyed = false
    }

    local ScreenGui = Create("ScreenGui", {
        Name = config.Name or "BlankUI",
        ResetOnSpawn = false,
        DisplayOrder = 999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local UIParent = gethui and gethui() or PlayerGui
    ScreenGui.Parent = UIParent

    Window.ScreenGui = ScreenGui

    local Main = Create("Frame", {
        Name = "Main",
        Size = config.Size or UDim2.fromOffset(550, 577),
        Position = config.Position or UDim2.new(0.5, -312, 0.5, -328),
        BackgroundColor3 = Color3.fromRGB(34, 0, 47),
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, ScreenGui)

    Window.Main = Main

    Gradient(Main, {
        Color3.fromRGB(153, 0, 255),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(177, 177, 177)
    }, 135)

    Corner(Main, 6)
    Stroke(Main, Color3.fromRGB(85, 85, 85), 1)

    local SideBar = Create("Frame", {
        Name = "SideBar",
        Size = UDim2.new(0, 94, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2
    }, Main)

    local SidebarTexture = Create("ImageLabel", {
        Name = "SidebarTexture",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://128380710379080",
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 2
    }, SideBar)

    local SideSeparator = Create("Frame", {
        Name = "SideSeparator",
        Size = UDim2.new(0, 1, 1, -63),
        Position = UDim2.new(1, -1, 0, 63),
        BackgroundColor3 = Color3.fromRGB(58, 58, 58),
        BorderSizePixel = 0,
        ZIndex = 6
    }, SideBar)

    local SidebarBottomImage = Create("ImageLabel", {
        Name = "SidebarBottomImage",
        Size = UDim2.fromOffset(111, 66),
        Position = UDim2.new(0.5, -55, 1, -35),
        BackgroundTransparency = 1,
        Image = "rbxassetid://79667850088134",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 20
    }, Main)

    local GrayPanel = Create("Frame", {
        Name = "GrayPanel",
        Size = UDim2.new(0, 78, 1, -101),
        Position = UDim2.fromOffset(8, 90),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 5
    }, Main)

    Corner(GrayPanel, 4)

    Gradient(GrayPanel, {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(206, 206, 206)
    }, 100)

    Stroke(GrayPanel, Color3.fromRGB(85, 85, 85), 1)

    local SidebarTitle = Create("TextLabel", {
        Name = "SidebarTitle",
        Size = UDim2.fromOffset(91, 94),
        Position = UDim2.fromOffset(0, 30),
        BackgroundTransparency = 1,
        Text = config.Title or "REAPER.LOL",
        TextColor3 = Color3.fromRGB(117, 0, 212),
        TextSize = 16,
        FontFace = FONT,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextStrokeColor3 = Color3.fromRGB(61, 0, 110),
        TextStrokeTransparency = 0,
        ZIndex = 20
    }, Main)

    Stroke(SidebarTitle, Color3.fromRGB(61, 0, 110), 1)

    local SidebarTitleGlow = Create("TextLabel", {
        Name = "SidebarTitleGlow",
        Size = UDim2.fromOffset(91, 94),
        Position = UDim2.fromOffset(0, 30),
        BackgroundTransparency = 1,
        Text = config.Title or "REAPER.LOL",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        TextTransparency = 0.8,
        TextSize = 16,
        FontFace = FONT,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 19
    }, Main)

    Stroke(
        SidebarTitleGlow,
        Color3.fromRGB(198, 0, 96),
        4,
        0.8
    )

    local MainGrayPanel = Create("Frame", {
        Name = "MainGrayPanel",
        Size = UDim2.new(1, -105, 1, -97),
        Position = UDim2.fromOffset(100, 68),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 2
    }, Main)

    Corner(MainGrayPanel, 4)

    Gradient(MainGrayPanel, {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(0, 0, 0)
    }, 100)

    Stroke(MainGrayPanel, Color3.fromRGB(85, 85, 85), 1)

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 63),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(67, 14, 85),
        BorderSizePixel = 0,
        ZIndex = 3
    }, Main)

    local HeaderTexture = Create("ImageLabel", {
        Name = "HeaderTexture",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://84115731336234",
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 4
    }, TopBar)

    local HeaderSeparator = Create("Frame", {
        Name = "HeaderSeparator",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.fromRGB(58, 58, 58),
        BorderSizePixel = 0,
        ZIndex = 6
    }, TopBar)

    local OverlapBar = Create("Frame", {
        Name = "OverlapBar",
        Size = UDim2.fromOffset(94, 63),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 7
    }, Main)

    local SettingsIcon = Create("ImageButton", {
        Name = "SettingsIcon",
        Size = UDim2.fromOffset(45, 45),
        Position = UDim2.new(1, -8, 1, -6),
        BackgroundTransparency = 1,
        Image = "rbxassetid://75241234938554",
        AutoButtonColor = false,
        ZIndex = 20
    }, OverlapBar)

    if config.SettingsCallback then
        SettingsIcon.MouseButton1Click:Connect(function()
            config.SettingsCallback(Window)
        end)
    end

    local DecalSidePanelTop = Create("Frame", {
        Name = "DecalSidePanelTop",
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(100, 5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 7
    }, TopBar)

    Corner(DecalSidePanelTop, 4)

    Gradient(DecalSidePanelTop, {
        Color3.fromRGB(113, 0, 154),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(104, 0, 127)
    }, 100)

    Stroke(DecalSidePanelTop, Color3.fromRGB(85, 85, 85), 1)

    local DecalSidePanelBottom = Create("Frame", {
        Name = "DecalSidePanelBottom",
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(100, 35),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 7
    }, TopBar)

    Corner(DecalSidePanelBottom, 4)

    Gradient(DecalSidePanelBottom, {
        Color3.fromRGB(113, 0, 154),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(104, 0, 127)
    }, 100)

    Stroke(DecalSidePanelBottom, Color3.fromRGB(85, 85, 85), 1)

    local OverlapShadow = Create("ImageLabel", {
        Name = "OverlapShadow",
        Size = UDim2.new(1.2, 0, 1.35, 0),
        Position = UDim2.new(-0.1, 0, 0.035, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://112221635299950",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 8
    }, OverlapBar)

    local OverlapImage = Create("ImageLabel", {
        Name = "OverlapImage",
        Size = UDim2.new(1.15, 0, 1.35, 0),
        Position = UDim2.new(-0.2, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://73486110117444",
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 9,
        Active = true
    }, OverlapBar)

    local UnloadPanel = Create("Frame", {
        Name = "UnloadPanel",
        Size = UDim2.fromOffset(33, 30),
        Position = UDim2.new(1, -33, 0, 0),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 8
    }, TopBar)

    Corner(UnloadPanel, 4)

    Gradient(UnloadPanel, {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(136, 0, 227)
    }, 125)

    Stroke(UnloadPanel, Color3.fromRGB(85, 85, 85), 1)

    local MinimizePanel = Create("Frame", {
        Name = "MinimizePanel",
        Size = UDim2.fromOffset(33, 30),
        Position = UDim2.new(1, -33, 0, 31),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 8
    }, TopBar)

    Corner(MinimizePanel, 4)

    Gradient(MinimizePanel, {
        Color3.fromRGB(102, 0, 180),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(0, 0, 0)
    }, 55)

    Stroke(MinimizePanel, Color3.fromRGB(85, 85, 85), 1)

    local Unload = Create("TextButton", {
        Name = "Unload",
        Size = UDim2.fromOffset(44, 30),
        Position = UDim2.new(1, -38, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(128, 38, 58),
        TextSize = 20,
        FontFace = FONT,
        AutoButtonColor = false,
        ZIndex = 10
    }, TopBar)

    local MinimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.fromOffset(44, 33),
        Position = UDim2.new(1, -39, 0, 19),
        BackgroundTransparency = 1,
        Text = "_",
        TextColor3 = Color3.fromRGB(158, 158, 158),
        TextSize = 30,
        FontFace = FONT,
        AutoButtonColor = false,
        ZIndex = 10
    }, TopBar)

    local SearchOuterFrame = Create("Frame", {
        Name = "SearchOuterFrame",
        Size = UDim2.fromOffset(304, 38),
        Position = UDim2.new(1, -362, 0, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 6
    }, TopBar)

    Corner(SearchOuterFrame, 5)
    Stroke(SearchOuterFrame, Color3.fromRGB(35, 0, 88), 1)

    local SearchBar = Create("Frame", {
        Name = "SearchBar",
        Size = UDim2.fromOffset(300, 34),
        Position = UDim2.new(1, -360, 0, 14),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 7
    }, TopBar)

    Gradient(SearchBar, {
        Color3.fromRGB(102, 0, 255),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0)
    }, 90)

    Stroke(SearchBar, Color3.fromRGB(85, 85, 85), 1)

    local SearchBox = Create("TextBox", {
        Name = "SearchBox",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(105, 105, 105),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 16,
        FontFace = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 8
    }, SearchBar)

    local TabBar = Create("ScrollingFrame", {
        Name = "TabBar",
        Size = UDim2.new(1, -10, 1, -75),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    }, GrayPanel)

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabBar)

    local PageContainer = Create("Frame", {
        Name = "PageContainer",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5
    }, MainGrayPanel)

    local BottomBar = Create("Frame", {
        Name = "BottomBar",
        Size = UDim2.new(1, 0, 0, 23),
        Position = UDim2.new(0, 0, 1, -23),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ZIndex = 1
    }, Main)

    local BottomSeparator = Create("Frame", {
        Name = "BottomSeparator",
        Size = UDim2.new(1, -94, 0, 1),
        Position = UDim2.fromOffset(94, 0),
        BackgroundColor3 = Color3.fromRGB(58, 58, 58),
        BorderSizePixel = 0,
        ZIndex = 2
    }, BottomBar)

    local PremiumText = Create("TextLabel", {
        Name = "PremiumText",
        Size = UDim2.fromOffset(25, 23),
        Position = UDim2.new(1.03, -280, 0, 0),
        BackgroundTransparency = 1,
        Text = "for",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, BottomBar)

    local PremiumWord = Create("TextLabel", {
        Name = "PremiumWord",
        Size = UDim2.fromOffset(55, 23),
        Position = UDim2.new(1.03, -260, 0, 0),
        BackgroundTransparency = 1,
        Text = "PREMIUM",
        TextColor3 = Color3.fromRGB(255, 196, 55),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, BottomBar)

    local PremiumKeys = Create("TextLabel", {
        Name = "PremiumKeys",
        Size = UDim2.fromOffset(45, 23),
        Position = UDim2.new(1.04, -212, 0, 0),
        BackgroundTransparency = 1,
        Text = " keys",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, BottomBar)

    local JoinText = Create("TextLabel", {
        Name = "JoinText",
        Size = UDim2.fromOffset(35, 23),
        Position = UDim2.new(1.04, -184, 0, 0),
        BackgroundTransparency = 1,
        Text = "join the",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, BottomBar)

    local DiscordText = Create("TextLabel", {
        Name = "DiscordText",
        Size = UDim2.fromOffset(50, 23),
        Position = UDim2.new(1, -115, 0, 0),
        BackgroundTransparency = 1,
        Text = "discord:",
        TextColor3 = Color3.fromRGB(88, 140, 255),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, BottomBar)

    local DiscordImage = Create("ImageButton", {
        Name = "DiscordImage",
        Size = UDim2.fromOffset(33, 33),
        Position = UDim2.new(1, -67, 0, 3),
        BackgroundTransparency = 1,
        Image = "rbxassetid://117233346775475",
        AutoButtonColor = false,
        ZIndex = 4
    }, BottomBar)

    DiscordImage.MouseButton1Click:Connect(function()
        local link = "https://discord.gg/reaperlol"

        if setclipboard then
            setclipboard(link)
        end

        local mouse = LocalPlayer:GetMouse()

        local LinkCopied = Create("TextLabel", {
            Size = UDim2.fromOffset(120, 25),
            Position = UDim2.fromOffset(mouse.X, mouse.Y),
            BackgroundTransparency = 1,
            Text = "Link copied!",
            TextColor3 = Color3.fromRGB(190, 190, 190),
            TextTransparency = 1,
            TextSize = 13,
            FontFace = FONT,
            ZIndex = 999999
        }, ScreenGui)

        TweenService:Create(
            LinkCopied,
            TweenInfo.new(0.2),
            {TextTransparency = 0}
        ):Play()

        task.wait(0.8)

        TweenService:Create(
            LinkCopied,
            TweenInfo.new(0.3),
            {TextTransparency = 1}
        ):Play()

        task.delay(0.35, function()
            if LinkCopied then
                LinkCopied:Destroy()
            end
        end)
    end)

    local VersionLabel = Create("TextLabel", {
        Name = "VersionLabel",
        Size = UDim2.fromOffset(100, 23),
        Position = UDim2.new(0.5, -170, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Version or "VERSION X.X",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 11,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3
    }, BottomBar)

    Create("UITextSizeConstraint", {
        MinTextSize = 11,
        MaxTextSize = 13
    }, VersionLabel)

    local GameLabel = Create("TextLabel", {
        Name = "GameLabel",
        Size = UDim2.fromOffset(100, 11),
        Position = UDim2.new(0.53, -110, 0, 0),
        BackgroundTransparency = 1,
        Text = "ˇˇGAMEˇˇ",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 2,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3
    }, BottomBar)

    Create("UITextSizeConstraint", {
        MinTextSize = 8,
        MaxTextSize = 13
    }, GameLabel)

    local CurrentGameLabel = Create("TextLabel", {
        Name = "CurrentGameLabel",
        Size = UDim2.fromOffset(100, 29),
        Position = UDim2.new(0.53, -110, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Game or "|RIVALS|",
        TextColor3 = Color3.fromRGB(105, 105, 105),
        TextSize = 12,
        FontFace = BOTTOM_FONT,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3
    }, BottomBar)

    Create("UITextSizeConstraint", {
        MinTextSize = 8,
        MaxTextSize = 13
    }, CurrentGameLabel)

    local ResizeButton = Create("TextButton", {
        Name = "ResizeButton",
        Size = UDim2.fromOffset(28, 23),
        Position = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text = "↔",
        TextColor3 = Color3.fromRGB(182, 182, 182),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Rotation = 45,
        AutoButtonColor = false,
        ZIndex = 5
    }, BottomBar)

    local NormalSize = Main.Size
    local MinWidth = 505
    local MaxWidth = 850
    local AspectRatio = 625 / 656

    local resizing = false
    local resizeStartMouse
    local resizeStartWidth

    ResizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartMouse = input.Position
            resizeStartWidth = Main.AbsoluteSize.X
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not resizing then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local delta = input.Position.X - resizeStartMouse.X
        local newWidth = math.clamp(
            resizeStartWidth + delta,
            MinWidth,
            MaxWidth
        )

        local newHeight = newWidth / AspectRatio

        Main.Size = UDim2.fromOffset(
            math.floor(newWidth + 0.5),
            math.floor(newHeight + 0.5)
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    local dragging = false
    local dragStart
    local startPosition

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local minimized = false
    local visibilityState = {
        Main = {},
        Overlap = {}
    }

    local function SaveVisibility()
        visibilityState.Main = {}
        visibilityState.Overlap = {}

        for _, object in ipairs(Main:GetChildren()) do
            if object:IsA("GuiObject") then
                visibilityState.Main[object] = object.Visible
            end
        end

        for _, object in ipairs(OverlapBar:GetChildren()) do
            if object:IsA("GuiObject") then
                visibilityState.Overlap[object] = object.Visible
            end
        end
    end

    local function RestoreVisibility()
        for object, visible in pairs(visibilityState.Main) do
            if object and object.Parent then
                object.Visible = visible
            end
        end

        for object, visible in pairs(visibilityState.Overlap) do
            if object and object.Parent then
                object.Visible = visible
            end
        end

        OverlapBar.Visible = true
    end

    function Window:Minimize()
        if minimized then
            return
        end

        minimized = true

        SaveVisibility()

        for _, object in ipairs(Main:GetChildren()) do
            if object:IsA("GuiObject") and object ~= OverlapBar then
                object.Visible = false
            end
        end

        for _, object in ipairs(OverlapBar:GetChildren()) do
            if object:IsA("GuiObject") then
                object.Visible = object == OverlapImage
            end
        end

        OverlapBar.Visible = true
        OverlapImage.Visible = true
        OverlapShadow.Visible = false

        Main.Size = UDim2.fromOffset(94, 63)
    end

    function Window:Restore()
        if not minimized then
            return
        end

        minimized = false

        Main.Size = NormalSize

        RestoreVisibility()
    end

    function Window:Destroy()
        if Window.Destroyed then
            return
        end

        Window.Destroyed = true
        ScreenGui:Destroy()
    end

    Unload.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)

    local overlapDragging = false
    local overlapDragStart
    local overlapStartPosition
    local overlapMoved = false

    OverlapImage.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        overlapDragging = true
        overlapMoved = false
        overlapDragStart = input.Position
        overlapStartPosition = Main.Position
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not overlapDragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local delta = input.Position - overlapDragStart

        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            overlapMoved = true
        end

        Main.Position = UDim2.new(
            overlapStartPosition.X.Scale,
            overlapStartPosition.X.Offset + delta.X,
            overlapStartPosition.Y.Scale,
            overlapStartPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if not overlapDragging then
            return
        end

        overlapDragging = false

        if not overlapMoved and minimized then
            Window:Restore()
        end
    end)

    local function ApplySearch()
        local query = string.lower(SearchBox.Text or "")
        local firstMatch = nil

        for _, tab in ipairs(Window.Tabs) do
            local hasMatch = false

            for _, item in ipairs(tab.SearchItems) do
                local matches = query == "" or string.find(
                    string.lower(item.Text),
                    query,
                    1,
                    true
                ) ~= nil

                item.Object.Visible = matches

                if matches then
                    hasMatch = true

                    if not firstMatch then
                        firstMatch = tab
                    end
                end
            end

            tab.HasSearchMatch = hasMatch
        end

        if query ~= "" and firstMatch and Window.CurrentTab ~= firstMatch then
            Window:SelectTab(firstMatch)
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        ApplySearch()
    end)

    function Window:SelectTab(tab)
        if type(tab) == "string" then
            for _, existingTab in ipairs(Window.Tabs) do
                if existingTab.Name == tab then
                    tab = existingTab
                    break
                end
            end
        end

        if not tab then
            return
        end

        Window.CurrentTab = tab

        for _, existingTab in ipairs(Window.Tabs) do
            existingTab.Page.Visible = existingTab == tab

            if existingTab == tab then
                existingTab.Button.BackgroundColor3 = Color3.fromRGB(55, 0, 80)
                existingTab.Button.TextColor3 = Color3.fromRGB(190, 130, 255)
            else
                existingTab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                existingTab.Button.TextColor3 = Color3.fromRGB(125, 125, 125)
            end
        end

        ApplySearch()
    end

    function Window:CreateTab(tabName)
        assert(type(tabName) == "string", "Tab name must be a string")

        local Tab = {
            Name = tabName,
            SearchItems = {},
            Controls = {}
        }

        local TabButton = Create("TextButton", {
            Name = tabName .. "Button",
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
            Text = string.upper(tabName),
            TextColor3 = Color3.fromRGB(125, 125, 125),
            TextSize = 12,
            FontFace = FONT,
            AutoButtonColor = false,
            ZIndex = 7
        }, TabBar)

        Corner(TabButton, 4)
        Stroke(TabButton, Color3.fromRGB(65, 65, 65), 1)

        local Page = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(100, 0, 180),
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 6
        }, PageContainer)

        local PagePadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        }, Page)

        local PageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        Tab.Button = TabButton
        Tab.Page = Page
        Tab.Layout = PageLayout

        table.insert(Window.Tabs, Tab)

        TabButton.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        function Tab:_RegisterSearch(object, text)
            table.insert(Tab.SearchItems, {
                Object = object,
                Text = text or ""
            })
        end

        function Tab:CreateLabel(text)
            local Label = Create("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextColor3 = Color3.fromRGB(175, 175, 175),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, Page)

            Tab:_RegisterSearch(Label, tostring(text))

            return Label
        end

        function Tab:CreateSection(text)
            local Section = Create("TextLabel", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Color3.fromRGB(35, 0, 50),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Text = string.upper(tostring(text)),
                TextColor3 = Color3.fromRGB(180, 110, 255),
                TextSize = 13,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, Page)

            Corner(Section, 4)
            Stroke(Section, Color3.fromRGB(75, 30, 95), 1)

            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 9)
            }, Section)

            Tab:_RegisterSearch(Section, tostring(text))

            return Section
        end

        function Tab:CreateButton(options)
            options = options or {}

            local buttonName = options.Name or "Button"

            local Button = Create("TextButton", {
                Name = buttonName,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(38, 38, 38),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Text = buttonName,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                FontFace = FONT,
                AutoButtonColor = false,
                ZIndex = 7
            }, Page)

            Corner(Button, 4)
            Stroke(Button, Color3.fromRGB(70, 70, 70), 1)

            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(50, 20, 65)
            end)

            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            end)

            Button.MouseButton1Click:Connect(function()
                if options.Callback then
                    options.Callback()
                end
            end)

            Tab:_RegisterSearch(Button, buttonName)

            local result = {
                Instance = Button
            }

            function result:SetText(text)
                Button.Text = tostring(text)
            end

            return result
        end

        function Tab:CreateToggle(options)
            options = options or {}

            local toggleName = options.Name or "Toggle"
            local currentValue = options.Default == true

            local Holder = Create("TextButton", {
                Name = toggleName,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(38, 38, 38),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 7
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder, Color3.fromRGB(70, 70, 70), 1)

            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = toggleName,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            }, Holder)

            local ToggleBox = Create("Frame", {
                Size = UDim2.fromOffset(30, 16),
                Position = UDim2.new(1, -40, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                ZIndex = 8
            }, Holder)

            Corner(ToggleBox, 8)
            Stroke(ToggleBox, Color3.fromRGB(75, 75, 75), 1)

            local Circle = Create("Frame", {
                Size = UDim2.fromOffset(12, 12),
                Position = UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.fromRGB(110, 110, 110),
                BorderSizePixel = 0,
                ZIndex = 9
            }, ToggleBox)

            Corner(Circle, 20)

            local function Update(value, fireCallback)
                currentValue = value == true

                if currentValue then
                    Circle.Position = UDim2.new(1, -14, 0, 2)
                    Circle.BackgroundColor3 = Color3.fromRGB(170, 70, 255)
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(55, 20, 70)
                else
                    Circle.Position = UDim2.fromOffset(2, 2)
                    Circle.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                end

                if fireCallback and options.Callback then
                    options.Callback(currentValue)
                end
            end

            Holder.MouseButton1Click:Connect(function()
                Update(not currentValue, true)
            end)

            Update(currentValue, true)

            Tab:_RegisterSearch(Holder, toggleName)

            local result = {
                Instance = Holder
            }

            function result:SetValue(value)
                Update(value, true)
            end

            function result:GetValue()
                return currentValue
            end

            return result
        end

        function Tab:CreateTextbox(options)
            options = options or {}

            local textboxName = options.Name or "Textbox"

            local Holder = Create("Frame", {
                Name = textboxName,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(38, 38, 38),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                ZIndex = 7
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder, Color3.fromRGB(70, 70, 70), 1)

            local Label = Create("TextLabel", {
                Size = UDim2.new(0.42, 0, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = textboxName,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            }, Holder)

            local Input = Create("TextBox", {
                Size = UDim2.new(0.5, -10, 0, 28),
                Position = UDim2.new(0.5, 0, 0.5, -14),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                PlaceholderText = options.Placeholder or "",
                PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
                Text = options.Default or "",
                TextColor3 = Color3.fromRGB(190, 190, 190),
                TextSize = 13,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            }, Holder)

            Corner(Input, 4)
            Stroke(Input, Color3.fromRGB(65, 65, 65), 1)

            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7)
            }, Input)

            Input.FocusLost:Connect(function(enterPressed)
                if options.Callback then
                    options.Callback(Input.Text, enterPressed)
                end
            end)

            Tab:_RegisterSearch(Holder, textboxName)

            local result = {
                Instance = Holder,
                Input = Input
            }

            function result:SetValue(value)
                Input.Text = tostring(value)
            end

            function result:GetValue()
                return Input.Text
            end

            return result
        end

        function Tab:CreateDropdown(options)
            options = options or {}

            local dropdownName = options.Name or "Dropdown"
            local values = options.Values or {}
            local selected = options.Default or values[1] or "None"
            local open = false

            local Holder = Create("Frame", {
                Name = dropdownName,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(38, 38, 38),
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 20
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder, Color3.fromRGB(70, 70, 70), 1)

            local Button = Create("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = dropdownName .. ": " .. tostring(selected),
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 13,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 21
            }, Holder)

            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }, Button)

            local List = Create("Frame", {
                Name = "List",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 40),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 30
            }, Holder)

            Corner(List, 4)
            Stroke(List, Color3.fromRGB(70, 70, 70), 1)

            local ListLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder
            }, List)

            local function SetSelected(value, fireCallback)
                selected = value
                Button.Text = dropdownName .. ": " .. tostring(selected)

                if fireCallback and options.Callback then
                    options.Callback(selected)
                end
            end

            local function Rebuild()
                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for index, value in ipairs(values) do
                    local Option = Create("TextButton", {
                        Name = "Option" .. index,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        BackgroundTransparency = 0,
                        BorderSizePixel = 0,
                        Text = tostring(value),
                        TextColor3 = Color3.fromRGB(165, 165, 165),
                        TextSize = 12,
                        FontFace = FONT,
                        AutoButtonColor = false,
                        ZIndex = 31
                    }, List)

                    Option.MouseEnter:Connect(function()
                        Option.BackgroundColor3 = Color3.fromRGB(55, 20, 70)
                    end)

                    Option.MouseLeave:Connect(function()
                        Option.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    end)

                    Option.MouseButton1Click:Connect(function()
                        SetSelected(value, true)

                        open = false
                        List.Visible = false
                        Holder.Size = UDim2.new(1, 0, 0, 40)
                    end)
                end

                List.Size = UDim2.new(
                    1,
                    0,
                    0,
                    math.min(#values * 30, 180)
                )
            end

            Button.MouseButton1Click:Connect(function()
                open = not open
                List.Visible = open

                if open then
                    local listHeight = math.min(#values * 30, 180)
                    Holder.Size = UDim2.new(
                        1,
                        0,
                        0,
                        40 + listHeight
                    )
                else
                    Holder.Size = UDim2.new(1, 0, 0, 40)
                end
            end)

            Rebuild()

            Tab:_RegisterSearch(Holder, dropdownName)

            local result = {
                Instance = Holder
            }

            function result:SetValue(value)
                SetSelected(value, true)
            end

            function result:GetValue()
                return selected
            end

            function result:Refresh(newValues)
                values = newValues or {}
                Rebuild()
            end

            return result
        end

        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end

        return Tab
    end

    function Window:SetTitle(title)
        SidebarTitle.Text = tostring(title)
        SidebarTitleGlow.Text = tostring(title)
    end

    function Window:SetVersion(version)
        VersionLabel.Text = tostring(version)
    end

    function Window:SetGame(gameName)
        CurrentGameLabel.Text = tostring(gameName)
    end

    function Window:Show()
        Main.Visible = true
    end

    function Window:Hide()
        Main.Visible = false
    end

    return Window
end

return Library
