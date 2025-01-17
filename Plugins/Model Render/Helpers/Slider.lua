local Slider = {}
Slider.__index = Slider

local userInput = game:GetService("UserInputService")

local function Round(x, mult)
	local precision = math.log10(1 / mult)
	return math.floor(x * 10^precision + 0.5) / 10^precision
end

function Slider.new(frame, initial, config)
	config = config or {}
	local self = setmetatable({
		Frame = frame;
		Value = initial or 0;
	}, Slider)

	self.MinValue = config.MinValue or 0
	self.MaxValue = config.MaxValue or 100
	self.Increment = config.Increment or 1

	self._holder = frame:WaitForChild("Holder")
	self._slider = self._holder:WaitForChild("Slider")
	self._valueLabel = self._holder:WaitForChild("Value")

	self._changed = Instance.new("BindableEvent")
	self.Changed = self._changed.Event

	self._released = Instance.new("BindableEvent")
	self.Released = self._released.Event

	local dragging = false

	self._slider.MouseButton1Down:Connect(function(x, y)
		dragging = true
		self:Calculate(x)
	end)

	userInput.InputChanged:Connect(function(input, processed)
		if (dragging and input.UserInputType == Enum.UserInputType.MouseMovement) then
			self:Calculate(input.Position.X)
		end
	end)

	userInput.InputEnded:Connect(function(input, processed)
		if (dragging and input.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			self._released:Fire(self.Value)
		end
	end)

	self._valueLabel.FocusLost:Connect(function()
		local inputValue = tonumber(self._valueLabel.Text)
		if inputValue then
			self:SetValue(inputValue or 0)
		else
			self._valueLabel.Text = tostring(self.Value)
		end
	end)

	self:SetValue(initial or 0)

	return self
end

function Slider:SetValue(value)
	value = math.clamp(value, self.MinValue, self.MaxValue)
	local roundedValue = Round((value - self.MinValue) / self.Increment, self.Increment) * self.Increment + self.MinValue

	local normalizedValue = (roundedValue - self.MinValue) / (self.MaxValue - self.MinValue)
	self._slider.Position = UDim2.new(normalizedValue, 0, 0.5, 0)
	self.Value = roundedValue

	self._valueLabel.Text = tostring(self.Value)
end

function Slider:Calculate(mouseX)
	local ratio = math.clamp(((mouseX - self._holder.AbsolutePosition.X) / self._holder.AbsoluteSize.X), 0, 1)
	local value = ratio * (self.MaxValue - self.MinValue) + self.MinValue
	self:SetValue(value)
	self._changed:Fire(value)
end

return Slider
