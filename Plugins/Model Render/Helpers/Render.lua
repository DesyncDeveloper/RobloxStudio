local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Render = {}

function Render.FindFromName(name, Path)	
	for i, v in pairs(Path:GetDescendants()) do
		if v.Name == name then
			return v
		end
	end
end

function Render.RenderModelInPreviewViewport(data)
	local model = data.Model[1]
	if not model:IsA("Model") or not model.PrimaryPart then
		warn("Model must have a PrimaryPart set.")
		return
	end

	local modelClone = model:Clone()
	local distance, scale, rotationX, rotationY, rotationZ = data.Distance or 0, data.Scale or false, data.RotationX or 0, data.RotationY or 0, data.RotationZ or 0

	for i,v in pairs(data.Frame:GetChildren()) do
		if not v:IsA("UIAspectRatioConstraint") then
			v:Destroy()
		end
	end

	local camera = Instance.new("Camera")
	camera.Parent = data.Frame
	data.Frame.CurrentCamera = camera

	modelClone.Parent = data.Frame

	if scale ~= nil then
		modelClone:ScaleTo(scale)
	end

	local modelCFrame = modelClone:GetModelCFrame()
	local modelSize = modelClone:GetScale()
	local cameraDistance = math.max(modelSize.Magnitude * 1.5, distance)

	local rotation = CFrame.Angles(
		math.rad(rotationX or 0),
		math.rad(rotationY or 0),
		math.rad(rotationZ or 0)
	)
	modelClone:SetPrimaryPartCFrame(modelCFrame * rotation)

	camera.CFrame = CFrame.new(
		modelCFrame.Position + Vector3.new(0, modelSize.Y / 2, cameraDistance),
		modelCFrame.Position
	)
end

function Render.RenderModelInViewport(data)
	local model = data.Model[1]
	if not model:IsA("Model") or not model.PrimaryPart then
		warn("Model must have a PrimaryPart set.")
		return
	end

	local modelClone = model:Clone()
	local distance, scale, rotationX, rotationY, rotationZ = data.Distance or 0, data.Scale or false, data.RotationX or 0, data.RotationY or 0, data.RotationZ or 0

	if scale ~= nil then
		modelClone:ScaleTo(scale)
	end

	data.Frame:ClearAllChildren()

	local camera = Instance.new("Camera")
	camera.Parent = data.Frame
	data.Frame.CurrentCamera = camera

	modelClone.Parent = data.Frame

	local modelCFrame = modelClone:GetModelCFrame()
	local modelSize = modelClone:GetExtentsSize()
	local cameraDistance = math.max(modelSize.Magnitude * 1.5, distance)

	local rotation = CFrame.Angles(
		math.rad(rotationX or 0),
		math.rad(rotationY or 0),
		math.rad(rotationZ or 0)
	)
	modelClone:SetPrimaryPartCFrame(modelCFrame * rotation)

	camera.CFrame = CFrame.new(
		modelCFrame.Position + Vector3.new(0, modelSize.Y / 2, cameraDistance),
		modelCFrame.Position
	)
end

-- require(game.ReplicatedStorage.Render).renderModelInViewport("Huge Bunny", {Distance = 0, Scale = false, RotationX = 102, RotationY = 0, RotationZ = 0})

return Render
