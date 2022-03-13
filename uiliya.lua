local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local UserInterface = { Settings = {}, Instances = {}, Windows = {}, Creation = {}, Input = {} }

local Control = {}

function Control.__index(t, i)
	local Children = rawget(t, "Children") or {}
	return Control[i] or Children[i]
end

function Control:Create(controlType, controlIndexName, ...)
	if self.Children and self.AllowedControls and self.AllowedControls[controlType] then
		local TempControl = UserInterface.Creation.Controls[controlType]({
			Index = controlIndexName,
			Type = controlType,
			Value = nil,
			Parent = self,
			Window = UserInterface.Creation.Windows[self.Type] and self or self.Window
		}, ...)

		TempControl.Value.Parent = self.Content or self.Value:FindFirstChild("Content") or self.Value

		TempControl = setmetatable(TempControl, Control)
		self.Children[controlIndexName] = TempControl

		return TempControl
	end

	return nil
end

function Control:Destroy(seconds)
	if seconds then
		wait(seconds)
	end

	if self.Parent then
		self.Parent.Children[self.Index] = nil
	end

	self.Value:Destroy()
end

UserInterface.Input = {
	ControlDown = false,
	IsMouseDown = function() return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end
}

UserInterface.Settings = {
	ScreenResolution = { X = 1920, Y = 1080 },
	MainColor = Color3.fromRGB(255, 255, 255),
	SecondaryColor = Color3.fromRGB(125, 125, 125)
}

UserInterface.Creation = {
	Merge = function(t1, t2)
		for k, v in pairs(t1) do
			t2[k] = v
		end

		return t2
	end,
	Windows = {
		["Panel"] = function(tempWindow, screenGui, panelTitle, panelPosition, panelSize, resizeable)
			local Panel = Instance.new("Frame")

			local Titlebar = Instance.new("TextButton")

			local Resize = Instance.new("TextButton")

			local UIListLayout = Instance.new("UIListLayout")
			do
				local UICorner = Instance.new("UICorner")
				local UIGradient = Instance.new("UIGradient")

				local Content = Instance.new("Frame")
				
				local UIGradient_2 = Instance.new("UIGradient")
				local UICorner_2 = Instance.new("UICorner")

				local TextLabel = Instance.new("TextLabel")

				local UICorner_3 = Instance.new("UICorner")
				local UIGradient_3 = Instance.new("UIGradient")

				Panel.Name = "Panel"
				Panel.Parent = screenGui
				Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Panel.BorderSizePixel = 0
				Panel.Position = panelPosition
				Panel.Size = panelSize

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Panel

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100, 100, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))}
				UIGradient.Rotation = 90
				UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.20, 0.05), NumberSequenceKeypoint.new(1.00, 0.50)}
				UIGradient.Parent = Panel

				Content.Name = "Content"
				Content.Parent = Panel
				Content.BackgroundTransparency = 1.000
				Content.Position = UDim2.new(0.025, 0, 0.05, 16)
				Content.Size = UDim2.new(0.95, 0, 0.9, -16)
				Content.ClipsDescendants = true

				UIListLayout.Parent = Content
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 4)

				Titlebar.Name = "Titlebar"
				Titlebar.Parent = Panel
				Titlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Titlebar.BorderSizePixel = 0
				Titlebar.Size = UDim2.new(1, 0, 0, 16)
				Titlebar.AutoButtonColor = false
				Titlebar.Text = ""

				UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient_2.Parent = Titlebar

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = Titlebar

				TextLabel.Parent = Titlebar
				TextLabel.AnchorPoint = Vector2.new(0, 0.5)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.Position = UDim2.new(0, 10, 0.5, 0)
				TextLabel.Size = UDim2.new(1, -10, 0.75, 0)
				TextLabel.Font = Enum.Font.Arial
				TextLabel.Text = panelTitle
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 10.000
				TextLabel.TextStrokeColor3 = UserInterface.Settings.MainColor
				TextLabel.TextStrokeTransparency = 0.500
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				Resize.Name = "Resize"
				Resize.Parent = Panel
				Resize.AnchorPoint = Vector2.new(1, 1)
				Resize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Resize.Position = UDim2.new(1, -3, 1, -3)
				Resize.Size = UDim2.new(0, 10, 0, 10)
				Resize.AutoButtonColor = false
				Resize.Text = ""
				Resize.Visible = resizeable

				UICorner_3.CornerRadius = UDim.new(1, 0)
				UICorner_3.Parent = Resize

				UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient_3.Parent = Resize
			end

			local function TitlebarMouseButton1Down()
				local DeltaX = Mouse.X - Titlebar.AbsolutePosition.X
				local DeltaY = Mouse.Y - Titlebar.AbsolutePosition.Y - 36

				while UserInterface.Input.IsMouseDown() do
					Panel.Position = UDim2.fromOffset((Mouse.X - DeltaX), (Mouse.Y - DeltaY))
					RunService.RenderStepped:Wait()
				end
			end
			Titlebar.MouseButton1Down:Connect(TitlebarMouseButton1Down)

			-- REWORK :CONSIDER ASPECT RATIO
			local function ResizeMouseButton1Down()
				local OffsetX = Panel.AbsolutePosition.X - Resize.Position.X.Offset - Resize.AbsoluteSize.X
				local OffsetY = Panel.AbsolutePosition.Y - Resize.Position.Y.Offset - Resize.AbsoluteSize.Y

				while UserInterface.Input.IsMouseDown() do
					tempWindow.AspectSize = UDim2.fromOffset((Mouse.X - OffsetX), (Mouse.Y - OffsetY))
					RunService.RenderStepped:Wait()
				end
			end
			Resize.MouseButton1Down:Connect(ResizeMouseButton1Down)
			
			tempWindow.Value = Panel

			local TempPanel = UserInterface.Creation.Merge({
				AllowedControls = {
					["Label"] = "Label",
					["Textox"] = "Textbox",
					["Button"] = "Button",
					["Check"] = "Check",
					["Slider"] = "Slider",
					["Combobox"] = "Combobox",
					["Group"] = "Group"
				},
				AspectSize = tempWindow.Value.Size
			}, tempWindow)

			UserInterface.AspectRatio(TempPanel)
			UserInterface.WindowTween(TempPanel)

			return TempPanel
		end,
		["Form"] = function(tempWindow, screenGui, formTitle, formPosition, formSize, resizeable)
			local Form = Instance.new("Frame")

			local Selectionbar = Instance.new("Frame")

			local Titlebar = Instance.new("TextButton")

			local UIListLayout = Instance.new("UIListLayout")

			local Resize = Instance.new("TextButton")
			do
				local UICorner = Instance.new("UICorner")
				local UIGradient = Instance.new("UIGradient")

				local Content = Instance.new("Frame")
				local UIPageLayout = Instance.new("UIPageLayout")

				local UIGradient_2 = Instance.new("UIGradient")
				local UICorner_2 = Instance.new("UICorner")

				local TextLabel = Instance.new("TextLabel")

				local Background = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")

				local UICorner_4 = Instance.new("UICorner")
				local UIGradient_3 = Instance.new("UIGradient")

				local Content_2 = Instance.new("Frame")

				Form.Name = "Form"
				Form.Parent = screenGui
				Form.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Form.BorderSizePixel = 0
				Form.Position = formPosition
				Form.Size = formSize

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Form

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100, 100, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))}
				UIGradient.Rotation = 90
				UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.20, 0.05), NumberSequenceKeypoint.new(1.00, 0.50)}
				UIGradient.Parent = Form

				Content.Name = "Content"
				Content.Parent = Form
				Content.BackgroundTransparency = 1.000
				Content.ClipsDescendants = true
				Content.Position = UDim2.new(0, 0, 0, 16)
				Content.Size = UDim2.new(1, 0, 1, -47)

				UIPageLayout.Name = "UIPageLayout"
				UIPageLayout.Parent = Content
				UIPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIPageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIPageLayout.EasingStyle = Enum.EasingStyle.Quint
				UIPageLayout.GamepadInputEnabled = false
				UIPageLayout.TouchInputEnabled = false
				UIPageLayout.ScrollWheelInputEnabled = false
				UIPageLayout.TweenTime = 0.500

				Titlebar.Name = "Titlebar"
				Titlebar.Parent = Form
				Titlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Titlebar.BorderSizePixel = 0
				Titlebar.Size = UDim2.new(1, 0, 0, 16)
				Titlebar.AutoButtonColor = false
				Titlebar.Text = ""

				UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient_2.Parent = Titlebar

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = Titlebar

				TextLabel.Parent = Titlebar
				TextLabel.AnchorPoint = Vector2.new(0, 0.5)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.Position = UDim2.new(0, 10, 0.5, 0)
				TextLabel.Size = UDim2.new(1, -10, 0.75, 0)
				TextLabel.Font = Enum.Font.Arial
				TextLabel.Text = formTitle
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 10.000
				TextLabel.TextStrokeColor3 = UserInterface.Settings.SecondaryColor
				TextLabel.TextStrokeTransparency = 0.500
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				Selectionbar.Name = "Selectionbar"
				Selectionbar.Parent = Form
				Selectionbar.AnchorPoint = Vector2.new(0, 1)
				Selectionbar.BackgroundTransparency = 1.000
				Selectionbar.ClipsDescendants = true
				Selectionbar.Position = UDim2.new(0, 0, 1, 0)
				Selectionbar.Size = UDim2.new(1, 0, 0, 31)

				Background.Name = "Background"
				Background.Parent = Selectionbar
				Background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background.BackgroundTransparency = 0.250
				Background.BorderSizePixel = 0
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0, 0, 0, 0)
				Background.Size = UDim2.new(1, 0, 1, 0)

				UICorner_3.CornerRadius = UDim.new(0, 3)
				UICorner_3.Parent = Background

				Resize.Parent = Background
				Resize.AnchorPoint = Vector2.new(1, 1)
				Resize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Resize.Position = UDim2.new(1, -3, 1, -3)
				Resize.Size = UDim2.new(0, 10, 0, 10)
				Resize.AutoButtonColor = false
				Resize.Text = ""
				Resize.Visible = resizeable

				UICorner_4.CornerRadius = UDim.new(1, 0)
				UICorner_4.Parent = Resize

				UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient_3.Parent = Resize

				Content_2.Name = "Content"
				Content_2.Parent = Selectionbar
				Content_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Content_2.BackgroundTransparency = 1.000
				Content_2.ClipsDescendants = true
				Content_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Content_2.Size = UDim2.new(1, 0, 0.75, 0)

				UIListLayout.Parent = Content_2
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 5)
			end

			local function SelectionbarAbsoluteSizeChanged()
				local Content = Selectionbar.Content:GetChildren()

				if #Content > 1 then
					local AbsoluteSize = Selectionbar.Content.AbsoluteSize
					local IncrementAbsoluteSize = AbsoluteSize / (#Content - 1)

					for k, v in pairs(Content) do
						if v:IsA("Frame") then
							local SizeCorrection = (IncrementAbsoluteSize.x - UIListLayout.Padding.Offset) / AbsoluteSize.x
							v.Size = UDim2.fromScale(SizeCorrection, SizeCorrection)
						end
					end
				end
			end
			Selectionbar:GetPropertyChangedSignal("AbsoluteSize"):Connect(SelectionbarAbsoluteSizeChanged)

			local function TitlebarMouseButton1Down()
				local DeltaX = Mouse.X - Titlebar.AbsolutePosition.X
				local DeltaY = Mouse.Y - Titlebar.AbsolutePosition.Y - 36

				while UserInterface.Input.IsMouseDown() do
					Form.Position = UDim2.fromOffset((Mouse.X - DeltaX), (Mouse.Y - DeltaY))
					RunService.RenderStepped:Wait()
				end
			end
			Titlebar.MouseButton1Down:Connect(TitlebarMouseButton1Down)

			-- REWORK :CONSIDER ASPECT RATIO
			local function ResizeMouseButton1Down()
				local OffsetX = Form.AbsolutePosition.X - Resize.Position.X.Offset - Resize.AbsoluteSize.X
				local OffsetY = Form.AbsolutePosition.Y - Resize.Position.Y.Offset - Resize.AbsoluteSize.Y

				while UserInterface.Input.IsMouseDown() do
					tempWindow.AspectSize = UDim2.fromOffset((Mouse.X - OffsetX), (Mouse.Y - OffsetY))
					RunService.RenderStepped:Wait()
				end
			end
			Resize.MouseButton1Down:Connect(ResizeMouseButton1Down)

			tempWindow.Value = Form

			local TempForm = UserInterface.Creation.Merge({
				AllowedControls = {
					["Page"] = "Page"
				},
				AspectSize = tempWindow.Value.Size
			}, tempWindow)

			UserInterface.AspectRatio(TempForm)
			UserInterface.WindowTween(TempForm)

			return TempForm
		end
	},
	Controls = {
		["Color"] = function(tempControl, defaultColor, defaultTransparency, eventCallback)
			local Color = Instance.new("Frame")

			local TextButton = Instance.new("TextButton")
			do
				local UICorner = Instance.new("UICorner")

				Color.Name = "Color"
				Color.AnchorPoint = Vector2.new(1, 0.5)
				Color.BackgroundColor3 = defaultColor
				Color.Position = UDim2.new(1, -8, 0.5, 0)
				Color.Size = UDim2.new(0.6, 0, 0.6, 0)
				Color.SizeConstraint = Enum.SizeConstraint.RelativeYY

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Color

				TextButton.Parent = Color
				TextButton.BackgroundTransparency = 1.000
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.Text = ""
			end

			local function TextButtonClicked()
				if UserInterface.Instances.Swatch.Target ~= tempControl then
					UserInterface.Instances.Swatch.Begin(tempControl)
				else
					UserInterface.Instances.Swatch.End()
				end
			end
			TextButton.MouseButton1Click:Connect(TextButtonClicked)

			local function ColorAbsolutePositionChanged()
				if UserInterface.Instances.Swatch.Target == tempControl then
					UserInterface.Instances.Swatch.Value.Position = UDim2.fromOffset(Color.AbsolutePosition.X + Color.AbsoluteSize.X, Color.AbsolutePosition.Y + Color.AbsoluteSize.Y + 36)
				end
			end
			Color:GetPropertyChangedSignal("AbsolutePosition"):Connect(ColorAbsolutePositionChanged)

			local function WindowVisible()
				if not tempControl.Window.Value.Visible then
					UserInterface.Instances.Swatch.End()
				end
			end
			tempControl.Window.Value:GetPropertyChangedSignal("Visible"):Connect(WindowVisible)

			tempControl.Color = defaultColor or Color3.fromRGB(255, 255, 255)
			tempControl.Transparency = defaultTransparency or 0
			tempControl.ThumbPosition = UDim2.fromScale(0.5, 0.5)
			tempControl.EventCallback = eventCallback
			tempControl.Connection = {
				Color:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
					tempControl.Color = Color.BackgroundColor3

					if tempControl.EventCallback then
						tempControl.EventCallback(Color)
					end
				end),
				TextButton:GetPropertyChangedSignal("TextTransparency"):Connect(function()
					tempControl.Transparency = TextButton.TextTransparency

					if tempControl.EventCallback then
						tempControl.EventCallback(Color)
					end
				end)
			}
			tempControl.Value = Color

			return tempControl
		end,
		["Label"] = function(tempControl, labelTitle)
			local Label = Instance.new("Frame")
			do
				local TextLabel = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.Position = UDim2.new(0, 0, 0.5, 0)
				Label.Size = UDim2.new(1, 0, 0, 12)

				TextLabel.Parent = Label
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.Position = UDim2.new(0, 5, 0, 0)
				TextLabel.Size = UDim2.new(1, -10, 1, 0)
				TextLabel.Font = Enum.Font.Arial
				TextLabel.Text = labelTitle
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 10.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 100, 100)
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			end

			tempControl.Value = Label

			return tempControl
		end,
		["Textbox"] = function(tempControl, textboxPlaceholder, eventCallback)
			local TextBox = Instance.new("Frame")

			local TextBox_2 = Instance.new("TextBox")
			do
				local Background = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")

				TextBox.Name = "TextBox"
				TextBox.BackgroundTransparency = 1.000
				TextBox.ClipsDescendants = true
				TextBox.Position = UDim2.new(0, 0, 0.5, 0)
				TextBox.Size = UDim2.new(1, 0, 0, 16)

				Background.Name = "Background"
				Background.Parent = TextBox
				Background.AnchorPoint = Vector2.new(0.5, 0.5)
				Background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background.BackgroundTransparency = 0.500
				Background.BorderSizePixel = 0
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0.5, 0, 0.5, 0)
				Background.Size = UDim2.new(1, -12, 1, 0)

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Background

				TextBox_2.Parent = Background
				TextBox_2.BackgroundTransparency = 1.000
				TextBox_2.ClipsDescendants = true
				TextBox_2.Size = UDim2.new(1, 0, 1, 0)
				TextBox_2.ClearTextOnFocus = false
				TextBox_2.Font = Enum.Font.Arial
				TextBox_2.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
				TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox_2.TextSize = 10.000
				TextBox_2.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextBox_2.TextStrokeTransparency = 0.500
				TextBox_2.PlaceholderText = textboxPlaceholder
				TextBox_2.Text = ""
			end

			tempControl.EventCallback = eventCallback
			tempControl.Connection = TextBox_2.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					UserInterface.CrossEffect(TextBox_2, UserInterface.Settings.MainColor)

					if tempControl.EventCallback then
						tempControl.EventCallback(tempControl)
					end
				end
			end)
			tempControl.Value = TextBox

			return tempControl
		end,
		["Button"] = function(tempControl, buttonTitle, eventCallback)
			local Button = Instance.new("Frame")

			local TextButton = Instance.new("TextButton")
			do
				local Background = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")

				Button.Name = "Button"
				Button.BackgroundTransparency = 1.000
				Button.ClipsDescendants = true
				Button.Position = UDim2.new(0, 0, 0.5, 0)
				Button.Size = UDim2.new(1, 0, 0, 16)

				Background.Name = "Background"
				Background.Parent = Button
				Background.AnchorPoint = Vector2.new(0.5, 0.5)
				Background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background.BackgroundTransparency = 0.500
				Background.BorderSizePixel = 0
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0.5, 0, 0.5, 0)
				Background.Size = UDim2.new(1, -12, 1, 0)

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Background

				TextButton.Parent = Background
				TextButton.BackgroundTransparency = 1.000
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.Arial
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.TextSize = 10.000
				TextButton.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextButton.TextStrokeTransparency = 0.500
				TextButton.Text = buttonTitle
			end

			tempControl.EventCallback = eventCallback
			tempControl.Connection = TextButton.MouseButton1Click:Connect(function()
				UserInterface.CrossEffect(TextButton, UserInterface.Settings.MainColor)

				if tempControl.EventCallback then
					tempControl.EventCallback(tempControl)
				end
			end)
			tempControl.Value = Button

			local TempButton = UserInterface.Creation.Merge({
				AllowedControls = {
					["Color"] = "Color"
				},
				Children = {}
			}, tempControl)

			return TempButton
		end,
		["Check"] = function(tempControl, checkTitle, checked, eventCallback)
			local Check = Instance.new("Frame")

			local TextButton = Instance.new("TextButton")

			local Thumb = Instance.new("Frame")
			do
				local Background = Instance.new("Frame")

				local UICorner = Instance.new("UICorner")

				local TextLabel = Instance.new("TextLabel")

				local UICorner_2 = Instance.new("UICorner")
				local UIGradient = Instance.new("UIGradient")

				Check.Name = "Check"
				Check.BackgroundTransparency = 1.000
				Check.ClipsDescendants = true
				Check.Position = UDim2.new(0, 0, 0.5, 0)
				Check.Size = UDim2.new(1, 0, 0, 16)

				Background.Name = "Background"
				Background.Parent = Check
				Background.AnchorPoint = Vector2.new(0.5, 0.5)
				Background.BackgroundTransparency = 1.000
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0.5, 0, 0.5, 0)
				Background.Size = UDim2.new(1, -12, 1, 0)

				TextButton.Parent = Background
				TextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				TextButton.BackgroundTransparency = 0.500
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
				TextButton.AutoButtonColor = false
				TextButton.Text = ""

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = TextButton

				TextLabel.Parent = TextButton
				TextLabel.AnchorPoint = Vector2.new(0, 0.5)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.Position = UDim2.new(1, 6, 0.5, 0)
				TextLabel.Size = UDim2.new(12.9169998, -6, 1, 0)
				TextLabel.Font = Enum.Font.Arial
				TextLabel.Text = checkTitle
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 10.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextLabel.TextStrokeTransparency = 0.500
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				Thumb.Name = "Thumb"
				Thumb.Parent = TextButton
				Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
				Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Thumb.Position = UDim2.new(0.5, 0, 0.5, 0)
				Thumb.Size = UDim2.new(0.5, 0, 0.5, 0)
				Thumb.Visible = checked or false

				UICorner_2.CornerRadius = UDim.new(1, 0)
				UICorner_2.Parent = Thumb

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient.Parent = Thumb
			end

			tempControl.Checked = checked or false
			tempControl.EventCallback = eventCallback
			tempControl.Connection = TextButton.MouseButton1Click:Connect(function()
				tempControl.Checked = not tempControl.Checked

				UserInterface.Tween(Thumb, 0.15, { BackgroundTransparency = (not tempControl.Checked and 1 or 0) }, { BackgroundTransparency = (tempControl.Checked and 1 or 0) }, true)

				Thumb.Visible = tempControl.Checked

				if tempControl.EventCallback then
					tempControl.EventCallback(tempControl, tempControl.Checked)
				end
			end)
			tempControl.Value = Check

			local TempCheck = UserInterface.Creation.Merge({
				AllowedControls = {
					["Color"] = "Color"
				},
				Children = {}
			}, tempControl)

			return TempCheck
		end,
		["Slider"] = function(tempControl, sliderMin, sliderMax, sliderValue, eventCallback)
			local Slider = Instance.new("Frame")

			local TextButton = Instance.new("TextButton")

			local Thumb = Instance.new("Frame")

			local TextBox = Instance.new("TextBox")

			local Frame = Instance.new("Frame")
			do
				local Background = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")

				local UIGradient = Instance.new("UIGradient")
				local UICorner_2 = Instance.new("UICorner")

				Slider.Name = "Slider"
				Slider.BackgroundTransparency = 1.000
				Slider.ClipsDescendants = true
				Slider.Position = UDim2.new(0, 0, 0.5, 0)
				Slider.Size = UDim2.new(1, 0, 0, 16)

				Background.Name = "Background"
				Background.Parent = Slider
				Background.AnchorPoint = Vector2.new(0.5, 0.5)
				Background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background.BackgroundTransparency = 0.500
				Background.BorderSizePixel = 0
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0.5, 0, 0.5, 0)
				Background.Size = UDim2.new(1, -12, 1, 0)

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Background

				TextButton.Parent = Background
				TextButton.BackgroundTransparency = 1.000
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.AutoButtonColor = false
				TextButton.Text = ""

				Frame.Parent = TextButton
				Frame.AnchorPoint = Vector2.new(0, 0.5)
				Frame.BackgroundTransparency = 1.000
				Frame.Position = UDim2.new(0, 3, 0.5, 0)
				Frame.Size = UDim2.new(1, -6, 0.400000006, 0)

				Thumb.Name = "Thumb"
				Thumb.Parent = Frame
				Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Thumb.BorderSizePixel = 0
				Thumb.Size = UDim2.fromScale((sliderValue - sliderMin) / (sliderMax - sliderMin), 1)

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient.Parent = Thumb

				UICorner_2.CornerRadius = UDim.new(1, 0)
				UICorner_2.Parent = Thumb

				TextBox.Parent = TextButton
				TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox.BackgroundTransparency = 1.000
				TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextBox.Size = UDim2.new(0, 0, 0, 0)
				TextBox.Font = Enum.Font.Arial
				TextBox.PlaceholderColor3 = Color3.fromRGB(125, 125, 125)
				TextBox.Text = sliderValue
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 10.000
				TextBox.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextBox.TextStrokeTransparency = 0.500
			end

			tempControl.Min = sliderMin
			tempControl.Max = sliderMax
			tempControl.Val = sliderValue
			tempControl.EventCallback = eventCallback
			tempControl.Connection = TextButton.MouseButton1Click:Connect(function()
				if UserInterface.Input.ControlDown then
					TextBox:CaptureFocus()
					TextBox.FocusLost:Wait()

					tempControl.Val = math.clamp(tonumber(TextBox.Text), tempControl.Min, tempControl.Max)
					TextBox.Text = tempControl.Val
				else
					tempControl.Val = math.clamp(((tempControl.Max - tempControl.Min) * ((Mouse.X - Frame.AbsolutePosition.X) / Frame.AbsoluteSize.X)) + tempControl.Min, tempControl.Min, tempControl.Max)
					TextBox.Text = math.floor(tempControl.Val)
				end

				UserInterface.Tween(Thumb, 0.15, { Size = UDim2.fromScale((tempControl.Val - tempControl.Min) / (tempControl.Max - tempControl.Min), 1) })

				if tempControl.EventCallback then
					tempControl.EventCallback(tempControl, tempControl.Val)
				end
			end)
			tempControl.Value = Slider

			return tempControl
		end,
		["Combobox"] = function(tempControl, comboTitle, searchable, eventCallback)
			local Combo = Instance.new("Frame")

			local TextButton = Instance.new("TextButton")

			local Content = Instance.new("ScrollingFrame")

			local TextBox = Instance.new("TextBox")
			do
				local Background = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")

				local Frame = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")

				local UIListLayout = Instance.new("UIListLayout")

				local Search = Instance.new("Frame")
				local Background_2 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local ImageLabel = Instance.new("ImageLabel")
				local UIGradient = Instance.new("UIGradient")

				Combo.Name = "Combo"
				Combo.BackgroundTransparency = 1.000
				Combo.ClipsDescendants = true
				Combo.Position = UDim2.new(0, 0, 0.5, 0)
				Combo.Size = UDim2.new(1, 0, 0, 16)

				Background.Name = "Background"
				Background.Parent = Combo
				Background.AnchorPoint = Vector2.new(0.5, 0)
				Background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background.BackgroundTransparency = 0.500
				Background.BorderSizePixel = 0
				Background.ClipsDescendants = true
				Background.Position = UDim2.new(0.5, 0, 0, 0)
				Background.Size = UDim2.new(1, -12, 0, 16)

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Background

				TextButton.Parent = Background
				TextButton.BackgroundTransparency = 1.000
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.Arial
				TextButton.Text = comboTitle
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.TextSize = 10.000
				TextButton.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextButton.TextStrokeTransparency = 0.500

				Frame.Parent = Combo
				Frame.AnchorPoint = Vector2.new(0.5, 0)
				Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Frame.BackgroundTransparency = 0.500
				Frame.Position = UDim2.new(0.5, 0, 0, 18)
				Frame.Size = UDim2.new(1, -24, 0, 80)

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = Frame

				Content.Name = "Content"
				Content.Parent = Frame
				Content.Active = true
				Content.AnchorPoint = Vector2.new(0, 0.5)
				Content.BackgroundTransparency = 1.000
				Content.BorderSizePixel = 0
				Content.Position = UDim2.new(0, 0, 0.5, 0)
				Content.Size = UDim2.new(1, 0, 0.899999976, 0)
				Content.CanvasSize = UDim2.new(0, 0, 0, 0)
				Content.ScrollBarThickness = 0
				Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

				UIListLayout.Parent = Content
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 4)

				Search.Name = "Search"
				Search.Parent = Content
				Search.BackgroundTransparency = 1.000
				Search.ClipsDescendants = true
				Search.Position = UDim2.new(0, 0, 0.5, 0)
				Search.Size = UDim2.new(1, 0, 0, 16)
				Search.Visible = searchable

				Background_2.Name = "Background"
				Background_2.Parent = Search
				Background_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Background_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Background_2.BackgroundTransparency = 0.500
				Background_2.BorderSizePixel = 0
				Background_2.ClipsDescendants = true
				Background_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Background_2.Size = UDim2.new(1, -12, 1, 0)

				UICorner_3.CornerRadius = UDim.new(0, 3)
				UICorner_3.Parent = Background_2

				TextBox.Parent = Background_2
				TextBox.BackgroundTransparency = 1.000
				TextBox.ClipsDescendants = true
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.ClearTextOnFocus = false
				TextBox.Font = Enum.Font.Arial
				TextBox.Text = ""
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 10.000
				TextBox.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
				TextBox.TextStrokeTransparency = 0.500

				ImageLabel.Parent = TextBox
				ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = 1.000
				ImageLabel.Position = UDim2.new(0, 2, 0.5, 0)
				ImageLabel.Size = UDim2.new(0.649999976, 0, 0.649999976, 0)
				ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
				ImageLabel.Image = "rbxassetid://7486214483"

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient.Parent = ImageLabel
			end

			tempControl.Content = Content
			tempControl.Toggled = false
			tempControl.EventCallback = eventCallback
			tempControl.Connection = TextButton.MouseButton1Click:Connect(function()
				tempControl.Toggled = not tempControl.Toggled
				UserInterface.Tween(Combo, 0.15, { Size = UDim2.new(1, 0, 0, 16 + 82 * (tempControl.Toggled and 1 or 0)) }, nil, false)

				if tempControl.EventCallback then
					tempControl.EventCallback(tempControl, tempControl)
				end
			end)

			local function SearchTextChanged()
				if TextBox.Text:len() == 0 then
					for k, v in pairs(tempControl.Children) do
						v.Value.Visible = true
					end

					return
				end

				if tempControl.Children then
					for k, v in pairs(tempControl.Children) do
						v.Value.Visible = string.find(k:lower(), TextBox.Text:lower()) and true or false
					end
				end
			end
			TextBox:GetPropertyChangedSignal("Text"):Connect(SearchTextChanged)

			tempControl.Value = Combo

			local TempCombo = UserInterface.Creation.Merge({
				AllowedControls = {
					["Label"] = "Label",
					["Textbox"] = "Textbox",
					["Button"] = "Button",
					["Check"] = "Check",
					["Slider"] = "Slider"
				},
				Children = {}
			}, tempControl)

			return TempCombo
		end,
		["Group"] = function(tempControl, groupTitle)
			local Group = Instance.new("Frame")

			local Content = Instance.new("Frame")

			local UIListLayout = Instance.new("UIListLayout")
			do
				local UICorner = Instance.new("UICorner")

				local Title = Instance.new("Frame")
				local TextLabel = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UIGradient = Instance.new("UIGradient")

				Group.Name = "Group"
				Group.BackgroundTransparency = 1.000
				Group.Size = UDim2.new(1, 0, 0, 0)
				Group.AutomaticSize = Enum.AutomaticSize.Y

				Content.Name = "Content"
				Content.Parent = Group
				Content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				Content.BackgroundTransparency = 0.650
				Content.BorderSizePixel = 0
				Content.ClipsDescendants = true
				Content.Size = UDim2.new(1, 0, 0, 20)

				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = Content

				UIListLayout.Parent = Content
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 4)

				Title.Name = "Title"
				Title.Parent = Content
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title.Position = UDim2.new(0, 0, 0.5, 0)
				Title.Size = UDim2.new(1, 0, 0, 12)

				TextLabel.Name = "TitleTextLabel"
				TextLabel.Parent = Title
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.Position = UDim2.new(0, 5, 0, 0)
				TextLabel.Size = UDim2.new(1, -5, 1, 0)
				TextLabel.Font = Enum.Font.Arial
				TextLabel.Text = groupTitle
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 10.000
				TextLabel.TextStrokeColor3 = UserInterface.Settings.SecondaryColor
				TextLabel.TextStrokeTransparency = 0.500
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = Title

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient.Parent = Title
			end

			tempControl.Connection = {
				Content.ChildAdded:Connect(function(instance)
					Content.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + instance.AbsoluteSize.Y + UIListLayout.Padding.Offset)

					instance:SetAttribute("Y", instance.AbsoluteSize.Y)

					instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						Content.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y - instance:GetAttribute("Y"))
						Content.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + instance.AbsoluteSize.Y)

						instance:SetAttribute("Y", instance.AbsoluteSize.Y)
					end)
				end),
				Content.ChildRemoved:Connect(function(instance)
					Content.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y - instance.AbsoluteSize.Y - UIListLayout.Padding.Offset)
				end)
			}

			tempControl.Value = Group

			local TempGroup = UserInterface.Creation.Merge({
				AllowedControls = {
					["Label"] = "Label",
					["Textbox"] = "Textbox",
					["Button"] = "Button",
					["Check"] = "Check",
					["Slider"] = "Slider",
					["Combobox"] = "Combobox"
				},
				Children = {}
			}, tempControl)

			return TempGroup
		end,
		["Page"] = function(tempControl, selectionButtonImage)
			-- REWORK
			local Page = Instance.new("ScrollingFrame")

			local Content = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")

			local Content_2 = Instance.new("Frame")
			local UIListLayout_2 = Instance.new("UIListLayout")

			local SelectionButton = Instance.new("Frame")
			local ImageButton = Instance.new("ImageButton")
			do
				local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				local UIGradient = Instance.new("UIGradient")

				Page.Name = "Page"
				Page.BackgroundTransparency = 1.000
				Page.Size = UDim2.new(1, 0, 1, 0)
				Page.CanvasSize = UDim2.new(1, 0, 0, 0)
				Page.ScrollBarThickness = 0

				Content.Name = "Content"
				Content.Parent = Page
				Content.BackgroundTransparency = 1.000
				Content.BorderSizePixel = 0
				Content.Position = UDim2.new(0, 6, 0, 2)
				Content.Size = UDim2.new(0.5, -8, 0, 0)
				Content.AutomaticSize = Enum.AutomaticSize.Y

				UIListLayout.Name = "ContentUIListLayout"
				UIListLayout.Parent = Content
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)

				Content_2.Name = "SwapContent"
				Content_2.Parent = Page
				Content_2.BackgroundTransparency = 1.000
				Content_2.BorderSizePixel = 0
				Content_2.Position = UDim2.new(0.5, 2, 0, 2)
				Content_2.Size = UDim2.new(0.5, -8, 0, 0)
				Content_2.AutomaticSize = Enum.AutomaticSize.Y

				UIListLayout_2.Name = "ContentUIListLayout"
				UIListLayout_2.Parent = Content_2
				UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_2.Padding = UDim.new(0, 5)

				SelectionButton.Name = "SelectionButton"
				SelectionButton.Parent = tempControl.Parent.Value.Selectionbar.Content
				SelectionButton.AnchorPoint = Vector2.new(0.5, 0.5)
				SelectionButton.BackgroundTransparency = 1.000
				SelectionButton.BorderSizePixel = 0
				SelectionButton.Size = UDim2.new(1, -4, 1, -4)
				SelectionButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

				ImageButton.Name = "SelectionButtonImageButton"
				ImageButton.Parent = SelectionButton
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.BorderSizePixel = 0
				ImageButton.Size = UDim2.new(1, 0, 1, 0)
				ImageButton.Image = selectionButtonImage

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, UserInterface.Settings.MainColor), ColorSequenceKeypoint.new(1.00, UserInterface.Settings.SecondaryColor)}
				UIGradient.Name = "SelectionButtonImageButtonUIGradient"
				UIGradient.Parent = ImageButton

				UIAspectRatioConstraint.Parent = SelectionButton
				UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
			end

			local function ContentChildAdded(instance)
				if Content.Name == "Content" then
					Content.Name = "SwapContent"
					Content_2.Name = "Content"
				else
					Content.Name = "Content"
					Content_2.Name = "SwapContent"
				end
			end
			Content.ChildAdded:Connect(ContentChildAdded)
			Content_2.ChildAdded:Connect(ContentChildAdded)

			local function ContentAbsoluteSize()
				Page.CanvasSize = UDim2.new(1, 0, 0, ((Content.AbsoluteSize.Y > Content_2.AbsoluteSize.Y) and Content.AbsoluteSize.Y or Content_2.AbsoluteSize.Y) + 4)
			end
			Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(ContentAbsoluteSize)
			Content_2:GetPropertyChangedSignal("AbsoluteSize"):Connect(ContentAbsoluteSize)

			local function SelectionButtonActivated(input, clickCount)
				if clickCount <= 5 then
					tempControl.Parent.Value.Content.UIPageLayout:JumpTo(Page)
				end

				UserInterface.FloodEffect(ImageButton, UserInterface.Settings.MainColor)
			end
			ImageButton.Activated:Connect(SelectionButtonActivated)

			local Content = SelectionButton.Parent:GetChildren()

			if #Content > 1 then
				local AbsoluteSize = SelectionButton.Parent.AbsoluteSize
				local IncrementAbsoluteSize = AbsoluteSize / (#Content - 1)

				for k, v in pairs(Content) do
					if v:IsA("Frame") then
						local SizeCorrection = (IncrementAbsoluteSize.x - SelectionButton.Parent.UIListLayout.Padding.Offset) / AbsoluteSize.x
						v.Size = UDim2.fromScale(SizeCorrection, SizeCorrection)
					end
				end
			end

			tempControl.Value = Page

			local TempPage = UserInterface.Creation.Merge({
				AllowedControls = {
					["Group"] = "Group"
				},
				Children = {}
			}, tempControl)

			UserInterface.Tween(ImageButton, 0.45, { Rotation = ImageButton.Rotation, ImageTransparency = ImageButton.ImageTransparency }, { Rotation = 359, ImageTransparency = 1 }, true)

			return TempPage
		end
	}
}

function UserInterface.SetScreenGui(screenGui)
	UserInterface.Instances.ScreenGui = screenGui
end

function UserInterface.CreateSwatch()
	if not UserInterface.Instances.Swatch then
		local Swatch = Instance.new("Frame")

		local Circle = Instance.new("ImageButton")

		local Thumb = Instance.new("ImageLabel")

		local Background = Instance.new("Frame")

		--[[Slider]]--

		local TextButton = Instance.new("TextButton")

		local Frame_2 = Instance.new("Frame")

		local TextBox = Instance.new("TextBox")

		local Thumb_2 = Instance.new("Frame")

		--[[TextBox]]--

		local TextBox_3 = Instance.new("TextBox")
		do
			local UIGradient = Instance.new("UIGradient")
			local UICorner = Instance.new("UICorner")

			--[[Circle]]--
			local Frame = Instance.new("Frame")

			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			local UICorner_2 = Instance.new("UICorner")

			local ImageLabel = Instance.new("ImageLabel")
			local UICorner_3 = Instance.new("UICorner")

			local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

			--[[Slider]]--

			local Slider = Instance.new("Frame")

			local Background_2 = Instance.new("Frame")
			local UICorner_4 = Instance.new("UICorner")

			local UIGradient_2 = Instance.new("UIGradient")
			local UICorner_5 = Instance.new("UICorner")

			--[[TextBox]]--

			local TextBox_2 = Instance.new("Frame")

			local Background_3 = Instance.new("Frame")
			local UICorner_6 = Instance.new("UICorner")

			--[[UpLeft]]--

			local UpLeft = Instance.new("ImageLabel")

			Swatch.Name = "Swatch"
			Swatch.Parent = UserInterface.Instances.ScreenGui
			Swatch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Swatch.BorderSizePixel = 0
			Swatch.Size = UDim2.new(0, 164, 0, 197)
			Swatch.ZIndex = 2
			Swatch.Visible = false

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100, 100, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))}
			UIGradient.Rotation = 90
			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.20, 0.05), NumberSequenceKeypoint.new(1.00, 0.50)}
			UIGradient.Parent = Swatch

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Swatch

			Frame.Parent = Swatch
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.Position = UDim2.new(0, 0, 0, 5)
			Frame.Size = UDim2.new(1, 0, 1, -61)
			Frame.ZIndex = 2

			Circle.Name = "Circle"
			Circle.Parent = Frame
			Circle.AnchorPoint = Vector2.new(0.5, 0.5)
			Circle.BackgroundTransparency = 1.000
			Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
			Circle.Size = UDim2.new(0.75, 0, 0.75, 0)
			Circle.ZIndex = 3
			Circle.Image = "rbxassetid://2849458409"

			UIAspectRatioConstraint.Parent = Circle
			UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize

			Background.Name = "Background"
			Background.Parent = Circle
			Background.AnchorPoint = Vector2.new(0.5, 0.5)
			Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Background.BorderSizePixel = 0
			Background.Position = UDim2.new(0.5, 0, 0.5, 0)
			Background.Size = UDim2.new(1.05, 0, 1.05, 0)
			Background.ZIndex = 2

			UICorner_2.CornerRadius = UDim.new(1, 0)
			UICorner_2.Parent = Background

			ImageLabel.Parent = Background
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			ImageLabel.Size = UDim2.new(1, -6, 1, -6)
			ImageLabel.ZIndex = 2
			ImageLabel.Image = "http://www.roblox.com/asset/?id=70140162"

			UICorner_3.CornerRadius = UDim.new(1, 0)
			UICorner_3.Parent = ImageLabel

			Thumb.Name = "Thumb"
			Thumb.Parent = Circle
			Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
			Thumb.BackgroundTransparency = 1.000
			Thumb.Position = UDim2.new(0.5, 0, 0.5, 0)
			Thumb.Size = UDim2.new(0.08, 0, 0.08, 0)
			Thumb.ZIndex = 3
			Thumb.Image = "rbxassetid://1770570346"
			Thumb.ImageColor3 = Color3.fromRGB(125, 125, 125)

			UIAspectRatioConstraint_2.Parent = Thumb
			UIAspectRatioConstraint_2.AspectType = Enum.AspectType.ScaleWithParentSize
			UIAspectRatioConstraint_2.DominantAxis = Enum.DominantAxis.Height

			Slider.Name = "Slider"
			Slider.Parent = Swatch
			Slider.AnchorPoint = Vector2.new(0, 1)
			Slider.BackgroundTransparency = 1.000
			Slider.ClipsDescendants = true
			Slider.Position = UDim2.new(0, 0, 1, -25)
			Slider.Size = UDim2.new(1, 0, 0, 16)
			Slider.ZIndex = 2

			Background_2.Name = "Background"
			Background_2.Parent = Slider
			Background_2.AnchorPoint = Vector2.new(0.5, 0.5)
			Background_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Background_2.BackgroundTransparency = 0.500
			Background_2.BorderSizePixel = 0
			Background_2.ClipsDescendants = true
			Background_2.Position = UDim2.new(0.5, 0, 0.5, 0)
			Background_2.Size = UDim2.new(1, -12, 1, 0)
			Background_2.ZIndex = 2

			UICorner_4.CornerRadius = UDim.new(0, 3)
			UICorner_4.Parent = Background_2

			TextButton.Parent = Background_2
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.ZIndex = 2
			TextButton.AutoButtonColor = false
			TextButton.Text = ""

			Frame_2.Parent = TextButton
			Frame_2.AnchorPoint = Vector2.new(0, 0.5)
			Frame_2.BackgroundTransparency = 1.000
			Frame_2.Position = UDim2.new(0, 3, 0.5, 0)
			Frame_2.Size = UDim2.new(1, -6, 0.4, 0)
			Frame_2.ZIndex = 2

			Thumb_2.Name = "Thumb"
			Thumb_2.Parent = Frame_2
			Thumb_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Thumb_2.BorderSizePixel = 0
			Thumb_2.Size = UDim2.new(0, 0, 1, 0)
			Thumb_2.ZIndex = 2

			UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100, 100, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
			UIGradient_2.Parent = Thumb_2

			UICorner_5.CornerRadius = UDim.new(1, 0)
			UICorner_5.Parent = Thumb_2

			TextBox.Parent = TextButton
			TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
			TextBox.BackgroundTransparency = 1.000
			TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
			TextBox.ZIndex = 2
			TextBox.Font = Enum.Font.Arial
			TextBox.Text = "0"
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 10.000
			TextBox.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
			TextBox.TextStrokeTransparency = 0.500

			TextBox_2.Name = "TextBox"
			TextBox_2.Parent = Swatch
			TextBox_2.AnchorPoint = Vector2.new(0, 1)
			TextBox_2.BackgroundTransparency = 1.000
			TextBox_2.ClipsDescendants = true
			TextBox_2.Position = UDim2.new(0, 0, 1, -5)
			TextBox_2.Size = UDim2.new(1, 0, 0, 16)
			TextBox_2.ZIndex = 2

			Background_3.Name = "Background"
			Background_3.Parent = TextBox_2
			Background_3.AnchorPoint = Vector2.new(0.5, 0.5)
			Background_3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Background_3.BackgroundTransparency = 0.500
			Background_3.BorderSizePixel = 0
			Background_3.ClipsDescendants = true
			Background_3.Position = UDim2.new(0.5, 0, 0.5, 0)
			Background_3.Size = UDim2.new(1, -12, 1, 0)
			Background_3.ZIndex = 2

			UICorner_6.CornerRadius = UDim.new(0, 3)
			UICorner_6.Parent = Background_3

			TextBox_3.Parent = Background_3
			TextBox_3.BackgroundTransparency = 1.000
			TextBox_3.ClipsDescendants = true
			TextBox_3.Size = UDim2.new(1, 0, 1, 0)
			TextBox_3.ZIndex = 2
			TextBox_3.ClearTextOnFocus = false
			TextBox_3.Font = Enum.Font.Arial
			TextBox_3.Text = "255 255 255"
			TextBox_3.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox_3.TextSize = 10.000
			TextBox_3.TextStrokeColor3 = Color3.fromRGB(125, 125, 125)
			TextBox_3.TextStrokeTransparency = 0.500

			UpLeft.Name = "UpLeft"
			UpLeft.Parent = Swatch
			UpLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UpLeft.BackgroundTransparency = 1.000
			UpLeft.Position = UDim2.new(0, 4, 0, 2)
			UpLeft.Size = UDim2.new(0.05, 0, 0.05, 0)
			UpLeft.SizeConstraint = Enum.SizeConstraint.RelativeXX
			UpLeft.ZIndex = 2
			UpLeft.Image = "rbxassetid://7501876217"
		end

		local function CircleMouseDown()
			local CircleCenter = Vector2.new(Circle.AbsolutePosition.X + (Circle.AbsoluteSize.X / 2), Circle.AbsolutePosition.Y + (Circle.AbsoluteSize.Y / 2))

			while UserInterface.Input.IsMouseDown() do
				local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
				local CircleRadius = (Circle.AbsoluteSize.Y / 2)
				local CircleMouseDelta = (MousePosition - CircleCenter)
				local CircleMouseDistance = CircleMouseDelta.Magnitude

				if CircleMouseDistance <= CircleRadius then
					Thumb.Position = UDim2.fromScale((Mouse.X - Circle.AbsolutePosition.X) / Circle.AbsoluteSize.X, (Mouse.Y - Circle.AbsolutePosition.Y) / Circle.AbsoluteSize.Y)
					UserInterface.Instances.Swatch.Target.ThumbPosition = Thumb.Position

					Background.BackgroundColor3 = Color3.fromHSV(1 - ((math.atan2(CircleMouseDelta.Y, CircleMouseDelta.X) + math.pi) / (math.pi * 2)), CircleMouseDistance / CircleRadius, 1)
				end

				UserInterface.Instances.Swatch.Target.Value.BackgroundColor3 = Background.BackgroundColor3
				TextBox_3.Text = math.round(Background.BackgroundColor3.R * 255) .. ' ' .. math.round(Background.BackgroundColor3.G * 255) .. ' ' .. math.round(Background.BackgroundColor3.B * 255)

				RunService.RenderStepped:Wait()
			end
		end
		Circle.MouseButton1Down:Connect(CircleMouseDown)

		local function SliderMouseDown()
			local Slider = UserInterface.Instances.Swatch.Slider
			local TempVal = nil

			if UserInterface.Input.ControlDown then
				TextBox:CaptureFocus()
				TextBox.FocusLost:Wait()

				TempVal = math.clamp(tonumber(TextBox.Text), Slider.Min, Slider.Max)
				Slider.Val = TempVal / Slider.Max

				TextBox.Text = TempVal
			else
				TempVal = math.clamp(((Slider.Max - Slider.Min) * ((Mouse.X - Frame_2.AbsolutePosition.X) / Frame_2.AbsoluteSize.X)) + Slider.Min, Slider.Min, Slider.Max)
				Slider.Val = TempVal / Slider.Max

				TextBox.Text = math.floor(TempVal)
			end

			Circle.ImageTransparency = Slider.Val
			UserInterface.Instances.Swatch.Target.Value.TextButton.TextTransparency = Slider.Val

			UserInterface.Tween(Thumb_2, 0.15, { Size = UDim2.fromScale(Slider.Val, 1) })
		end
		TextButton.MouseButton1Click:Connect(SliderMouseDown)

		local function TextBoxFocusLost()
			local Split = TextBox_3.Text:split(' ')

			Background.BackgroundColor3 = Color3.fromRGB(tonumber(Split[1]), tonumber(Split[2]), tonumber(Split[3]))
			UserInterface.Instances.Swatch.Target.Value.BackgroundColor3 = Background.BackgroundColor3
		end
		TextBox_3.FocusLost:Connect(TextBoxFocusLost)

		UserInterface.Instances.Swatch = {
			Value = Swatch,
			AspectSize = Swatch.Size,
			Target = nil,
			Slider = {
				Max = 100,
				Min = 0,
				Val = 0
			}
		}

		function UserInterface.Instances.Swatch.Begin(colorControl)
			local Value = colorControl.Value

			UserInterface.Instances.Swatch.Target = colorControl
			Swatch.Visible = true
			Swatch.Position = UDim2.fromOffset(Value.AbsolutePosition.X + Value.AbsoluteSize.X, Value.AbsolutePosition.Y + Value.AbsoluteSize.Y + 36)

			Circle.ImageTransparency = colorControl.Transparency
			TextBox.Text = math.round(colorControl.Transparency * UserInterface.Instances.Swatch.Slider.Max)
			Thumb_2.Size = UDim2.fromScale(colorControl.Transparency, 1)

			Background.BackgroundColor3 = colorControl.Color
			TextBox_3.Text = math.round(colorControl.Color.R * 255) .. ' ' .. math.round(colorControl.Color.G * 255) .. ' ' .. math.round(colorControl.Color.B * 255)
			Thumb.Position = colorControl.ThumbPosition
		end

		function UserInterface.Instances.Swatch.End()
			UserInterface.Instances.Swatch.Target = nil
			UserInterface.Instances.Swatch.Value.Visible = false
		end
	end
end

function UserInterface.Initialize()
	UserInterface.SetScreenGui(game.CoreGui.ThemeProvider)
	UserInterface.CreateSwatch()

	RunService.RenderStepped:Connect(UserInterface.RenderStepped)
	UserInputService.InputBegan:Connect(UserInterface.InputBegan)
	UserInputService.InputEnded:Connect(UserInterface.InputEnded)
end

function UserInterface.InputBegan(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl then
			UserInterface.Input.ControlDown = true
		end
	end
end

function UserInterface.InputEnded(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl then
			UserInterface.Input.ControlDown = false
		end
	end
end

function UserInterface.RenderStepped(deltaTime)
	for k, v in pairs(UserInterface.Windows) do
		UserInterface.AspectRatio(v)
	end

	UserInterface.AspectRatio(UserInterface.Instances.Swatch)
end

function UserInterface.FloodEffect(instance, color)
	local Flood = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")

	Flood.Name = "Flood"
	Flood.Parent = instance
	Flood.BackgroundColor3 = color
	Flood.Size = UDim2.new(0, 0, 0, 0)
	Flood.AnchorPoint = Vector2.new(0.5, 0.5)
	Flood.Position = UDim2.fromOffset(Mouse.X - instance.AbsolutePosition.X, Mouse.Y - instance.AbsolutePosition.Y)

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Flood

	UserInterface.Tween(Flood, 0.5, { Size = UDim2.fromOffset(50, 50), BackgroundTransparency = 1 })

	Debris:AddItem(Flood, 1)
end

function UserInterface.CrossEffect(instance, color)
	local Cross = Instance.new("Frame")

	Cross.Name = "Flood"
	Cross.Parent = instance
	Cross.BackgroundColor3 = color
	Cross.BorderSizePixel = 0
	Cross.Size = UDim2.new(0, 0, 1, 0)

	UserInterface.Tween(Cross, 1, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })

	Debris:AddItem(Cross, 1)
end

function UserInterface.AspectRatio(windowObject)
	if not windowObject.IgnoreAspectRatio then
		local CorrectedX = ((windowObject.AspectSize.Width.Offset / UserInterface.Settings.ScreenResolution.X) * UserInterface.Instances.ScreenGui.AbsoluteSize.X)
		windowObject.Value.Size = UDim2.fromOffset(CorrectedX, CorrectedX * (windowObject.AspectSize.Height.Offset / windowObject.AspectSize.Width.Offset))
	end
end

function UserInterface.WindowTween(windowControl)
	local InstanceChildren = {}
	for k, v in pairs(windowControl.Children) do
		if v.Value:IsA("GuiBase2d") then
			InstanceChildren[#InstanceChildren + 1] = v.Value
			v.Value.Visible = false
		end
	end

	table.sort(InstanceChildren, function(a, b)
		return ((a.AbsoluteSize.X + a.AbsoluteSize.Y) > (b.AbsoluteSize.X + b.AbsoluteSize.Y))
	end)

	UserInterface.Tween(windowControl.Value, 1, { Size = windowControl.Value.Size, Rotation = windowControl.Value.Rotation, Transparency = windowControl.Value.Transparency }, { Size = UDim2.new(windowControl.Value.Size.Width.Scale, windowControl.Value.Size.Width.Offset, 0, 0), Rotation = 359, Transparency = 1 }, true)

	for k, v in pairs(InstanceChildren) do
		UserInterface.Tween(v, 0.25, { Size = v.Size }, { Size = UDim2.fromOffset(0, 0) }, true)
	end
end

function UserInterface.Tween(instance, duration, properties, overrides, wait)
	local InstanceTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local InstanceTween = TweenService:Create(instance, InstanceTweenInfo, properties or { Size = instance.Size })

	instance.Visible = false

	if overrides then
		for k, v in pairs(overrides) do
			instance[k] = v
		end
	end

	instance.Visible = true

	InstanceTween:Play()

	if wait then
		InstanceTween.Completed:Wait()
	end
end

local uiliray = loadstring(game:HttpGet("https://raw.githubusercontent.com/uwuvik/idk-funny/main/uil.lua"))();


function UserInterface.CreateWindow(windowType, windowIndexName, toggleKey, ignoreAspectRatio, ...)
	local TempWindow = UserInterface.Creation.Windows[windowType]({
		Index = windowIndexName,
		Type = windowType,
		Value = nil,
		Children = {},
		ToggleKey = toggleKey,
		IgnoreAspectRatio = ignoreAspectRatio
	}, UserInterface.Instances.ScreenGui, ...)

	TempWindow = setmetatable(TempWindow, Control)
	UserInterface.Windows[windowIndexName] = TempWindow

	local function ToggleInputBegan(input)
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == TempWindow.ToggleKey then
			TempWindow.Value.Visible = not TempWindow.Value.Visible
		end
	end
	UserInputService.InputBegan:Connect(ToggleInputBegan)

	return TempWindow
end

UserInterface.Initialize()

return UserInterface
