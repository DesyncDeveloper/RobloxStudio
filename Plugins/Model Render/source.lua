--// Services
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local Selection = game:GetService("Selection")


--// Helpers
local CircularSlider_C = HttpService:GetAsync("https://raw.githubusercontent.com/DesyncDeveloper/RobloxStudio/refs/heads/main/Plugins/Model%20Render/Helpers/CircularSlider.lua", true)
local Slider_C = HttpService:GetAsync("https://raw.githubusercontent.com/DesyncDeveloper/RobloxStudio/refs/heads/main/Plugins/Model%20Render/Helpers/Slider.lua", true)
local Render_C = HttpService:GetAsync("https://raw.githubusercontent.com/DesyncDeveloper/RobloxStudio/refs/heads/main/Plugins/Model%20Render/Helpers/Render.lua", true)
local CircularSlider_F = loadstring(CircularSlider_C)
local Slider_F = loadstring(Slider_C)
local Render_F = loadstring(Render_C)

local CircularSlider = CircularSlider_F()
local Slider = Slider_F()
local Render = Render_F()

--// Module
local module = {
	Ui = nil
}

local PluginSettings = {
	CurrentAngle = "X",
	IsInPreviewMode = false,
	Sliders = {}
}

local RenderSettings = {
	Distance = 0,
	RotationX = 0,
	RotationY = 0,
	RotationZ = 0,
	Scale = 0,
	DynamicCamera = false, 
	Model = Selection:Get()
}

local function setVisibility(elements, visible)
	for _, element in pairs(elements) do
		element.Visible = visible
	end
end

local function updateAngleSelectionUI(selectedAngle)
	local angles = {"X", "Y", "Z"}
	for _, angle in ipairs(angles) do
		local isSelected = angle == selectedAngle
		
		print(module.Ui.Main:FindFirstChild("Angle"..angle))
				
		module.Ui.Main:FindFirstChild("Angle"..angle).Visible = isSelected
		module.Ui.Main.AngleSelection[angle].Icon.Visible = isSelected
		module.Ui.Main.AngleSelection[angle].Indication.Visible = not isSelected
	end
end


function module.Open()
	if not module.Ui then
		local screenGui = InsertService:LoadAsset(108084540237363):GetChildren()[1]
		if screenGui:IsA("ScreenGui") then
			screenGui.Parent = game:WaitForChild("CoreGui")
			module.Ui = screenGui
		else
			warn("The asset is not a ScreenGui")
		end
	end
end

function module.Close()
	if module.Ui then
		module.Ui:Destroy()
		module.Ui = nil
	end
end

function module.HandleButton(Button, callback)
	if module.Ui then
		Button.MouseButton1Click:Connect(callback)
	end
end

function module.HandlePreview()
	if RenderSettings.Model[1] == nil then
		warn("Please select the model inside the explorer")
	end

	if RenderSettings.Model[1]:IsA("Model") then
		if RenderSettings.Scale == 0 then
			RenderSettings.DynamicCamera = true
			RenderSettings.Scale = RenderSettings.Model[1]:GetScale()
		end

		RenderSettings.Frame = module.Ui.Main.Preview.ModelViewport
		Render.RenderModelInPreviewViewport(RenderSettings)

		if RenderSettings.Scale > 1 then
			RenderSettings.DynamicCamera = false
			RenderSettings.Frame:FindFirstChild(RenderSettings.Model[1].Name):ScaleTo(RenderSettings.Scale)
		end

		PluginSettings.IsInPreviewMode = true
	else
		warn("Please select a model not a: ", type(RenderSettings.Model[1]))
	end
end

function module.Start()
	if module.Ui then
		local buttonActions = {
			{button = module.Ui.Main.Info.DistanceIcon.Click, infoElements = {module.Ui.Main.Info.DistanceInfo}},
			{button = module.Ui.Main.Info.ScaleIcon.Click, infoElements = {module.Ui.Main.Info.ScaleInfo}},
			{button = module.Ui.Main.Info.AngleIcon.Click, infoElements = {module.Ui.Main.Info.AngleInfo}},
			{button = module.Ui.Main.Info.ValueIcon.Click, infoElements = {module.Ui.Main.Info.ValueInfo}},
			{button = module.Ui.Main.Info.Close, infoElements = {
				module.Ui.Main.Info.DistanceInfo,
				module.Ui.Main.Info.ScaleInfo,
				module.Ui.Main.Info.AngleInfo,
				module.Ui.Main.Info.ValueInfo
			}},
		}

		for _, action in ipairs(buttonActions) do
			module.HandleButton(action.button, function()
				setVisibility({module.Ui.Main.Info.DistanceInfo, module.Ui.Main.Info.ScaleInfo, module.Ui.Main.Info.AngleInfo, module.Ui.Main.Info.ValueInfo}, false)
				setVisibility(action.infoElements, true)

				module.Ui.Main.Info.Close.Visible = action.button ~= module.Ui.Main.Info.Close
				setVisibility({
					module.Ui.Main.PreviewModel, module.Ui.Main.RemoveModel, module.Ui.Main.Preview
				}, action.button == module.Ui.Main.Info.Close)
			end)
		end

		module.HandleButton(module.Ui.Main.AngleSelection.X, function()
			updateAngleSelectionUI("X")
			PluginSettings.CurrentAngle = "X"
		end)
		module.HandleButton(module.Ui.Main.AngleSelection.Y, function()
			updateAngleSelectionUI("Y")
			PluginSettings.CurrentAngle = "Y"
		end)
		module.HandleButton(module.Ui.Main.AngleSelection.Z, function()
			updateAngleSelectionUI("Z")
			PluginSettings.CurrentAngle = "Z"
		end)

		module.HandleButton(module.Ui.Main.PreviewModel.Click, function() module.HandlePreview() end)
		module.HandleButton(module.Ui.Main.RemoveModel.Click, function()
			PluginSettings.IsInPreviewMode = false
			for _, child in pairs(module.Ui.Main.Preview.ModelViewport:GetChildren()) do
				if not child:IsA("UIAspectRatioConstraint") then
					child:Destroy()
				end
			end
		end)

		Selection.SelectionChanged:Connect(function()
			if not PluginSettings.IsInPreviewMode then
				RenderSettings.Model = Selection:Get()
			end
		end)

		local sliders = {
			{frame = module.Ui.Main.Distance, SliderType ="Line", name = "Distance", property = "Distance", min = 0, max = 100, inc = 1},
			{frame = module.Ui.Main.Scale, SliderType = "Line", name = "Scale", property = "Scale", min = 0, max = 100, inc = 0.5},
			{frame = module.Ui.Main.AngleX, SliderType = "Circle", name = "AngleX", property = "RotationX"},
			{frame = module.Ui.Main.AngleY, SliderType = "Circle", name = "AngleY", property = "RotationY"},
			{frame = module.Ui.Main.AngleZ, SliderType = "Circle", name = "AngleZ", property = "RotationZ"}
		}

		for _, sliderInfo in pairs(sliders) do
			local slider
			if sliderInfo.SliderType == "Line" then
				slider = Slider.new(sliderInfo.frame, 0, {
					MinValue = sliderInfo.min,
					MaxValue = sliderInfo.max,
					Increment = sliderInfo.inc,
				})
			elseif sliderInfo.SliderType == "Circle" then
				slider = CircularSlider.new(sliderInfo.frame)
			end

			slider.Released:Connect(function(value)
				RenderSettings[sliderInfo.property] = value
				if PluginSettings.IsInPreviewMode then
					module.HandlePreview()
				end
			end)
						
			PluginSettings.Sliders[sliderInfo.name] = slider
		end
	end
end

return module
