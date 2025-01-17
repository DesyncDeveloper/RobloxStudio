local CircularSlider = {}
CircularSlider.__index = CircularSlider

local function calculateAngle(center, mousePosition)
	local dx = mousePosition.X - center.X
	local dy = mousePosition.Y - center.Y
	local angle = math.deg(math.atan2(dy, dx))
	return (angle + 360) % 360
end

function CircularSlider.new(frame)
	local self = setmetatable({}, CircularSlider)
	self.Frame = frame
	self.Outer = frame:WaitForChild("Outer")
	self.Click = self.Frame:WaitForChild("Click")
	self.ValueLabel = frame:WaitForChild("Value")
	self.Value = 0

	self._changed = Instance.new("BindableEvent")
	self.Changed = self._changed.Event

	self._released = Instance.new("BindableEvent")
	self.Released = self._released.Event
	
	local dragging = false
	local center = self.Outer.AbsolutePosition + self.Outer.AbsoluteSize / 2

	self.Click.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	self.Click.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			self._released:Fire(self.Value)
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local angle = calculateAngle(center, input.Position)
			if angle > 180 then
				angle = angle - 360
			end
			self:SetValue(angle)
		end
	end)

	self.ValueLabel.FocusLost:Connect(function()
		local inputValue = tonumber(self.ValueLabel.Text)
		if inputValue then
			self:SetValue(inputValue)
		else
			self.ValueLabel.Text = tostring(self.Value)
		end
	end)

	self:SetValue(0)
	return self
end

function CircularSlider:SetValue(value)
	self.Value = math.clamp(value, -360, 360)

	local angle = math.rad(self.Value)
	local radius = (self.Outer.AbsoluteSize.X / 2)
	local center = self.Outer.AbsolutePosition + self.Outer.AbsoluteSize / 2

	local x = center.X + radius * math.cos(angle) - self.Click.AbsoluteSize.X / 2
	local y = center.Y + radius * math.sin(angle) - self.Click.AbsoluteSize.Y / 2
	self.Click.Position = UDim2.new(0, x - self.Frame.AbsolutePosition.X, 0, y - self.Frame.AbsolutePosition.Y)

	self.ValueLabel.Text = tostring(math.floor(self.Value))

	self._changed:Fire(value)
end

return CircularSlider
