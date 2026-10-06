local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

local FONT = Font.new("rbxassetid://12187376739")

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 4)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(85, 85, 85),
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Gradient(parent, colors, rotation)
    local gradient = Create("UIGradient", {
        Rotation = rotation or 0
    }, parent)

    local points = {}

    for i, color in ipairs(colors) do
        table.insert(points, ColorSequenceKeypoint.new(
            (i - 1) / (#colors - 1),
            color
        ))
    end

    gradient.Color = ColorSequence.new(points)

    return gradient
end

function Library:CreateWindow(config)
    config = config or {}

    local Window = {}
    Window.__index = Window

    Window.Tabs = {}
    Window.CurrentTab = nil

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
        Position = UDim2.new(0.5, -312, 0.5, -328),
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
    Stroke(Main)

    --------------------------------------------------
    -- SIDEBAR
    --------------------------------------------------

    local SideBar = Create("Frame", {
        Name = "SideBar",
        Size = UDim2.new(0, 94, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2
    }, Main)

    Create("ImageLabel", {
        Name = "SidebarTexture",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://128380710379080",
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 3
    }, SideBar)

    Create("Frame", {
        Name = "SideSeparator",
        Size = UDim2.new(0, 1, 1, -63),
        Position = UDim2.fromOffset(93, 63),
        BackgroundColor3 = Color3.fromRGB(58, 58, 58),
        BorderSizePixel = 0,
        ZIndex = 6
    }, Main)

    local GrayPanel = Create("Frame", {
        Name = "GrayPanel",
        Size = UDim2.new(0, 78, 1, -101),
        Position = UDim2.fromOffset(8, 90),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 4
    }, Main)

    Corner(GrayPanel, 4)

    Gradient(GrayPanel, {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(206, 206, 206)
    }, 100)

    Stroke(GrayPanel)

    local SidebarTitle = Create("TextLabel", {
        Name = "SidebarTitle",
        Size = UDim2.fromOffset(91, 94),
        Position = UDim2.fromOffset(0, 30),
        BackgroundTransparency = 1,
        Text = config.Title or "REAPER.LOL",
        TextColor3 = Color3.fromRGB(117, 0, 212),
        TextSize = 16,
        FontFace = FONT,
        TextWrapped = true,
        ZIndex = 20
    }, Main)

    Create("UIStroke", {
        Color = Color3.fromRGB(61, 0, 110),
        Thickness = 1
    }, SidebarTitle)

    --------------------------------------------------
    -- MAIN PANEL
    --------------------------------------------------

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
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0)
    }, 100)

    Stroke(MainGrayPanel)

    --------------------------------------------------
    -- TOP BAR
    --------------------------------------------------

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 63),
        BackgroundColor3 = Color3.fromRGB(67, 14, 85),
        BorderSizePixel = 0,
        ZIndex = 3
    }, Main)

    Create("ImageLabel", {
        Name = "HeaderTexture",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://84115731336234",
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 4
    }, TopBar)

    Create("Frame", {
        Name = "HeaderSeparator",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.fromRGB(58, 58, 58),
        BorderSizePixel = 0,
        ZIndex = 6
    }, Main)

    --------------------------------------------------
    -- TAB CONTAINER
    --------------------------------------------------

    local TabBar = Create("ScrollingFrame", {
        Name = "TabBar",
        Size = UDim2.new(0, 84, 1, -20),
        Position = UDim2.fromOffset(5, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 10
    }, GrayPanel)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
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

    Window.PageContainer = PageContainer

    --------------------------------------------------
    -- OVERLAP BAR
    --------------------------------------------------

    local OverlapBar = Create("Frame", {
        Name = "OverlapBar",
        Size = UDim2.fromOffset(94, 63),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 7
    }, Main)

    local OverlapShadow = Create("ImageLabel", {
        Name = "OverlapShadow",
        Size = UDim2.new(1.2, 0, 1.35, 0),
        Position = UDim2.new(-0.1, 0, 0.035, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://112221635299950",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.55,
        ZIndex = 8
    }, OverlapBar)

    local OverlapImage = Create("ImageLabel", {
        Name = "OverlapImage",
        Size = UDim2.new(1.15, 0, 1.35, 0),
        Position = UDim2.new(-0.2, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://73486110117444",
        ZIndex = 9
    }, OverlapBar)

    local UnloadPanel = Create("Frame", {
        Name = "UnloadPanel",
        Size = UDim2.fromOffset(33, 30),
        Position = UDim2.fromOffset(-33, 0),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 8
    }, OverlapBar)

    Corner(UnloadPanel, 4)

    Gradient(UnloadPanel, {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(136, 0, 227)
    }, 125)

    Stroke(UnloadPanel)

    local MinimizePanel = Create("Frame", {
        Name = "MinimizePanel",
        Size = UDim2.fromOffset(33, 30),
        Position = UDim2.fromOffset(-33, 31),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 8
    }, OverlapBar)

    Corner(MinimizePanel, 4)

    Gradient(MinimizePanel, {
        Color3.fromRGB(102, 0, 180),
        Color3.fromRGB(53, 53, 53),
        Color3.fromRGB(0, 0, 0)
    }, 55)

    Stroke(MinimizePanel)

    local Unload = Create("TextButton", {
        Name = "Unload",
        Size = UDim2.fromOffset(44, 30),
        Position = UDim2.fromOffset(-38, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(128, 38, 58),
        TextSize = 20,
        FontFace = FONT,
        AutoButtonColor = false,
        ZIndex = 10
    }, OverlapBar)

    local MinimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.fromOffset(44, 33),
        Position = UDim2.fromOffset(-39, 19),
        BackgroundTransparency = 1,
        Text = "_",
        TextColor3 = Color3.fromRGB(158, 158, 158),
        TextSize = 30,
        FontFace = FONT,
        AutoButtonColor = false,
        ZIndex = 10
    }, OverlapBar)

    Unload.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    --------------------------------------------------
    -- SEARCH
    --------------------------------------------------

    local SearchBar = Create("Frame", {
        Name = "SearchBar",
        Size = UDim2.fromOffset(300, 34),
        Position = UDim2.new(1, -360, 0, 14),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 8
    }, TopBar)

    Corner(SearchBar, 4)

    Gradient(SearchBar, {
        Color3.fromRGB(117, 0, 212),
        Color3.fromRGB(0, 0, 0)
    }, 90)

    Stroke(SearchBar)

    local SearchBox = Create("TextBox", {
        Name = "SearchBox",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        FontFace = FONT,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10
    }, SearchBar)

    --------------------------------------------------
    -- DRAGGING
    --------------------------------------------------

    local dragging = false
    local dragStart
    local startPosition

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    --------------------------------------------------
    -- MINIMIZE
    --------------------------------------------------

    local minimized = false
    local NormalSize = Main.Size
    local NormalPosition = Main.Position

    local function SetMinimized(state)
        minimized = state

        if state then
            NormalSize = Main.Size
            NormalPosition = Main.Position

            for _, child in ipairs(Main:GetChildren()) do
                if child ~= OverlapBar and child:IsA("GuiObject") then
                    child.Visible = false
                end
            end

            OverlapBar.Visible = true
            OverlapImage.Visible = true
            OverlapShadow.Visible = false

            Main.Size = UDim2.fromOffset(94, 63)
        else
            Main.Size = NormalSize

            for _, child in ipairs(Main:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.Visible = true
                end
            end

            OverlapBar.Visible = true
            OverlapImage.Visible = true
            OverlapShadow.Visible = true
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            SetMinimized(true)
        end
    end)

    local minimizedDragStart
    local minimizedStartPosition
    local minimizedMoved = false
    local draggingMinimized = false

    OverlapImage.Active = true

    OverlapImage.InputBegan:Connect(function(input)
        if not minimized then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingMinimized = true
            minimizedMoved = false
            minimizedDragStart = input.Position
            minimizedStartPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not draggingMinimized or not minimized then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - minimizedDragStart

            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
                minimizedMoved = true
            end

            Main.Position = UDim2.new(
                minimizedStartPosition.X.Scale,
                minimizedStartPosition.X.Offset + delta.X,
                minimizedStartPosition.Y.Scale,
                minimizedStartPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if not draggingMinimized then
            return
        end

        draggingMinimized = false

        if minimized and not minimizedMoved then
            SetMinimized(false)
        end

        minimizedDragStart = nil
        minimizedStartPosition = nil
        minimizedMoved = false
    end)

    --------------------------------------------------
    -- TAB CREATION
    --------------------------------------------------

    function Window:CreateTab(tabConfig)
        local Tab = {}
        Tab.__index = Tab

        local tabName

        if type(tabConfig) == "string" then
            tabName = tabConfig
        else
            tabName = tabConfig.Name or "Tab"
        end

        local Page = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(117, 0, 212),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 6
        }, PageContainer)

        Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5)
        }, Page)

        local Button = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Text = string.upper(tabName),
            TextColor3 = Color3.fromRGB(190, 190, 190),
            TextSize = 12,
            FontFace = FONT,
            AutoButtonColor = false,
            ZIndex = 11
        }, TabBar)

        Corner(Button, 4)
        Stroke(Button)

        Tab.Name = tabName
        Tab.Page = Page
        Tab.Button = Button

        function Window:SelectTab(tab)
            for _, otherTab in ipairs(self.Tabs) do
                otherTab.Page.Visible = false
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                otherTab.Button.TextColor3 = Color3.fromRGB(190, 190, 190)
            end

            tab.Page.Visible = true
            tab.Button.BackgroundColor3 = Color3.fromRGB(100, 0, 145)
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)

            self.CurrentTab = tab
        end

        Button.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        --------------------------------------------------
        -- LABEL
        --------------------------------------------------

        function Tab:CreateLabel(text)
            return Create("TextLabel", {
                Size = UDim2.new(1, -10, 0, 28),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(190, 190, 190),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, Page)
        end

        --------------------------------------------------
        -- SECTION
        --------------------------------------------------

        function Tab:CreateSection(text)
            local Section = Create("TextLabel", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundTransparency = 1,
                Text = string.upper(text),
                TextColor3 = Color3.fromRGB(160, 0, 220),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, Page)

            return Section
        end

        --------------------------------------------------
        -- BUTTON
        --------------------------------------------------

        function Tab:CreateButton(options)
            options = options or {}

            local Button = Create("TextButton", {
                Size = UDim2.new(1, -10, 0, 38),
                BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Text = options.Name or "Button",
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                FontFace = FONT,
                AutoButtonColor = false,
                ZIndex = 7
            }, Page)

            Corner(Button, 4)
            Stroke(Button)

            Button.MouseEnter:Connect(function()
                TweenService:Create(
                    Button,
                    TweenInfo.new(0.15),
                    {BackgroundColor3 = Color3.fromRGB(90, 0, 120)}
                ):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(
                    Button,
                    TweenInfo.new(0.15),
                    {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
                ):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                if options.Callback then
                    options.Callback()
                end
            end)

            return Button
        end

        --------------------------------------------------
        -- TOGGLE
        --------------------------------------------------

        function Tab:CreateToggle(options)
            options = options or {}

            local state = options.Default or false

            local Holder = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                ZIndex = 7
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder)

            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = options.Name or "Toggle",
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            }, Holder)

            local Toggle = Create("TextButton", {
                Size = UDim2.fromOffset(38, 20),
                Position = UDim2.new(1, -48, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9
            }, Holder)

            Corner(Toggle, 10)
            Stroke(Toggle)

            local Indicator = Create("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                BorderSizePixel = 0,
                ZIndex = 10
            }, Toggle)

            Corner(Indicator, 8)

            local function Update(value)
                state = value

                if state then
                    TweenService:Create(
                        Toggle,
                        TweenInfo.new(0.15),
                        {BackgroundColor3 = Color3.fromRGB(100, 0, 145)}
                    ):Play()

                    TweenService:Create(
                        Indicator,
                        TweenInfo.new(0.15),
                        {
                            Position = UDim2.new(1, -18, 0, 2),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }
                    ):Play()
                else
                    TweenService:Create(
                        Toggle,
                        TweenInfo.new(0.15),
                        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                    ):Play()

                    TweenService:Create(
                        Indicator,
                        TweenInfo.new(0.15),
                        {
                            Position = UDim2.fromOffset(2, 2),
                            BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                        }
                    ):Play()
                end

                if options.Callback then
                    options.Callback(state)
                end
            end

            Toggle.MouseButton1Click:Connect(function()
                Update(not state)
            end)

            Update(state)

            return {
                SetValue = Update,
                GetValue = function()
                    return state
                end,
                Instance = Holder
            }
        end

        --------------------------------------------------
        -- TEXTBOX
        --------------------------------------------------

        function Tab:CreateTextbox(options)
            options = options or {}

            local Holder = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 62),
                BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                ZIndex = 7
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.fromOffset(10, 3),
                BackgroundTransparency = 1,
                Text = options.Name or "Input",
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 13,
                FontFace = FONT,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            }, Holder)

            local Box = Create("TextBox", {
                Size = UDim2.new(1, -20, 0, 27),
                Position = UDim2.fromOffset(10, 30),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Text = options.Default or "",
                PlaceholderText = options.PlaceholderText or "Enter value...",
                PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                FontFace = FONT,
                ClearTextOnFocus = false,
                ZIndex = 8
            }, Holder)

            Corner(Box, 3)
            Stroke(Box)

            Box.FocusLost:Connect(function()
                if options.Callback then
                    options.Callback(Box.Text)
                end
            end)

            return {
                SetValue = function(value)
                    Box.Text = tostring(value)
                end,

                GetValue = function()
                    return Box.Text
                end,

                Instance = Holder
            }
        end

        --------------------------------------------------
        -- DROPDOWN
        --------------------------------------------------

        function Tab:CreateDropdown(options)
            options = options or {}

            local selected = options.Default
            local values = options.Options or {}

            local Holder = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 20
            }, Page)

            Corner(Holder, 4)
            Stroke(Holder)

            local Button = Create("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = (options.Name or "Dropdown") .. ": " .. tostring(selected or "None"),
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 13,
                FontFace = FONT,
                AutoButtonColor = false,
                ZIndex = 22
            }, Holder)

            local List = Create("Frame", {
                Name = "DropdownList",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 100
            }, Holder)

            Corner(List, 4)
            Stroke(List)

            local Layout = Create("UIListLayout", {
                Padding = UDim.new(0, 2)
            }, List)

            local open = false

            local function Rebuild()
                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, value in ipairs(values) do
                    local Option = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        BorderSizePixel = 0,
                        Text = tostring(value),
                        TextColor3 = Color3.fromRGB(220, 220, 220),
                        TextSize = 12,
                        FontFace = FONT,
                        AutoButtonColor = false,
                        ZIndex = 101
                    }, List)

                    Option.MouseButton1Click:Connect(function()
                        selected = value
                        Button.Text = (options.Name or "Dropdown") .. ": " .. tostring(value)

                        open = false
                        List.Visible = false
                        List.Size = UDim2.new(1, 0, 0, 0)

                        if options.Callback then
                            options.Callback(value)
                        end
                    end)
                end

                List.Size = UDim2.new(
                    1,
                    0,
                    0,
                    math.min(#values * 32, 160)
                )
            end

            Button.MouseButton1Click:Connect(function()
                open = not open
                List.Visible = open

                if open then
                    Rebuild()
                end
            end)

            Rebuild()

            return {
                SetValue = function(value)
                    selected = value
                    Button.Text = (options.Name or "Dropdown") .. ": " .. tostring(value)

                    if options.Callback then
                        options.Callback(value)
                    end
                end,

                Refresh = function(newValues)
                    values = newValues or {}
                    Rebuild()
                end,

                GetValue = function()
                    return selected
                end,

                Instance = Holder
            }
        end

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end

        return Tab
    end

    function Window:Destroy()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    return Window
end

return Library
