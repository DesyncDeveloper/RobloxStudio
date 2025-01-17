--// Services
local InsertService = game:GetService("InsertService")
local Selection = game:GetService("Selection")

--//
local module = {
	Ui = nil
}

local PluginSettings = {
	CurrentAngle = "X",
	IsInPreviewMode = false	
}

local RenderSettings = {
	Distance = 0,
	RotationX = 0,
	RotationY = 0,
	RotationZ = 0,
	Scale = 0,
	Model = Selection:Get()
}

function module.Open()
	if module.Ui == nil then
		local function insertScreenGui()
			local screenGui = InsertService:LoadAsset(108084540237363):GetChildren()[1]
			if screenGui:IsA("ScreenGui") then
				screenGui.Ui.Parent = game:WaitForChild("CoreGui")
				module.Ui = screenGui
			else
				warn("The asset is not a ScreenGui")
			end
		end
	end
end

function module.Close()
	if module.Ui ~= nil then
		module.Ui:Destroy()
		module.Ui = nil
	end
end

function module.HandleButton(Button, callback)
	if module.Ui ~= nil then
		Button.MouseButton1Click:Connect(function()
			callback()
		end)
	end
end

function module.Start()
	if module.Ui ~= nil then
		module.HandleButton(module.Ui.Main.Info.DistanceIcon.Click, function()
			module.Ui.Main.Info.DistanceInfo.Visible = true
			module.Ui.Main.Info.ScaleInfo.Visible = false
			module.Ui.Main.Info.AngleInfo.Visible = false
			module.Ui.Main.Info.ValueInfo.Visible = false

			module.Ui.Main.Info.Close.Visible = true

			module.Ui.Main.PreviewModel.Visible = false
			module.Ui.Main.RemoveModel.Visible = false
			module.Ui.Main.Preview.Visible = false
		end)
		
		module.HandleButton(module.Ui.Main.Info.DistanceIcon.Click, function()
			module.Ui.Main.Info.DistanceInfo.Visible = true
			module.Ui.Main.Info.ScaleInfo.Visible = false
			module.Ui.Main.Info.AngleInfo.Visible = false
			module.Ui.Main.Info.ValueInfo.Visible = false

			module.Ui.Main.Info.Close.Visible = true

			module.Ui.Main.PreviewModel.Visible = false
			module.Ui.Main.RemoveModel.Visible = false
			module.Ui.Main.Preview.Visible = false
		end)
		
		module.HandleButton(module.Ui.Main.Info.ScaleIcon.Click, function()
			module.Ui.Main.Info.DistanceInfo.Visible = false
			module.Ui.Main.Info.ScaleInfo.Visible = true
			module.Ui.Main.Info.AngleInfo.Visible = false
			module.Ui.Main.Info.ValueInfo.Visible = false

			module.Ui.Main.Info.Close.Visible = true

			module.Ui.Main.PreviewModel.Visible = false
			module.Ui.Main.RemoveModel.Visible = false
			module.Ui.Main.Preview.Visible = false
		end)

		module.HandleButton(module.Ui.Main.Info.AngleIcon.Click, function()
			module.Ui.Main.Info.DistanceInfo.Visible = false
			module.Ui.Main.Info.ScaleInfo.Visible = false
			module.Ui.Main.Info.AngleInfo.Visible = true
			module.Ui.Main.Info.ValueInfo.Visible = false

			module.Ui.Main.Info.Close.Visible = true

			module.Ui.Main.PreviewModel.Visible = false
			module.Ui.Main.RemoveModel.Visible = false
			module.Ui.Main.Preview.Visible = false
		end)

		module.HandleButton(module.Ui.Main.ValueIcon.AngleIcon.Click, function()
			module.Ui.Main.Info.DistanceInfo.Visible = false
			module.Ui.Main.Info.ScaleInfo.Visible = false
			module.Ui.Main.Info.AngleInfo.Visible = false
			module.Ui.Main.Info.ValueInfo.Visible = true

			module.Ui.Main.Info.Close.Visible = true

			module.Ui.Main.PreviewModel.Visible = false
			module.Ui.Main.RemoveModel.Visible = false
			module.Ui.Main.Preview.Visible = false
		end)

		module.HandleButton(module.Ui.Main.Info.Close, function()
			module.Ui.Main.Info.DistanceInfo.Visible = false
			module.Ui.Main.Info.ScaleInfo.Visible = false
			module.Ui.Main.Info.AngleInfo.Visible = false
			module.Ui.Main.Info.ValueInfo.Visible = false

			module.Ui.Main.Info.Close.Visible = false

			module.Ui.Main.PreviewModel.Visible = true
			module.Ui.Main.RemoveModel.Visible = true
			module.Ui.Main.Preview.Visible = true
		end)

		module.HandleButton(module.Ui.AngleSelection.X, function()
			module.Ui.Main.AngleSelection.X.Icon.Visible = true
			module.Ui.Main.AngleSelection.Y.Icon.Visible = false
			module.Ui.Main.AngleSelection.Z.Icon.Visible = false

			module.Ui.Main.AngleSelection.X.Indication.Visible = false
			module.Ui.Main.AngleSelection.Y.Indication.Visible = true
			module.Ui.Main.AngleSelection.Z.Indication.Visible = true

			PluginSettings.CurrentAngle = "X"
		end)

		module.HandleButton(module.Ui.AngleSelection.Y, function()
			module.Ui.Main.AngleSelection.Y.Icon.Visible = true
			module.Ui.Main.AngleSelection.Z.Icon.Visible = false
			module.Ui.Main.AngleSelection.X.Icon.Visible = false

			module.Ui.Main.AngleSelection.X.Indication.Visible = true
			module.Ui.Main.AngleSelection.Y.Indication.Visible = false
			module.Ui.Main.AngleSelection.Z.Indication.Visible = true

			PluginSettings.CurrentAngle = "Y"
		end)

		module.HandleButton(module.Ui.AngleSelection.Z, function()
			module.Ui.Main.AngleSelection.Z.Icon.Visible = true
			module.Ui.Main.AngleSelection.Y.Icon.Visible = false
			module.Ui.Main.AngleSelection.X.Icon.Visible = false

			module.Ui.Main.AngleSelection.X.Indication.Visible = true
			module.Ui.Main.AngleSelection.Y.Indication.Visible = true
			module.Ui.Main.AngleSelection.Z.Indication.Visible = false

			PluginSettings.CurrentAngle = "Z"
		end)
	end
end

return module
