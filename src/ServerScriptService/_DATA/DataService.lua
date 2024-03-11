local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _DATA = ReplicatedStorage:WaitForChild("_DATA")
local _ConnectDataService = _DATA:FindFirstChild("_ConnectDataService")
local _ConnectRemoteDataService = _DATA:FindFirstChild("_ConnectRemoteDataService")

local DataService = {}

local Templates = {}
local Clans = {}

-- Usage

function DataService:RequestUserData(player)
	if Templates[player.UserId] and Templates[player.UserId].Loaded then
		return Templates[player.UserId].Data
	end
end

function DataService:ChangeStat(player, Stat, State)
	if Templates[player.UserId] and Templates[player.UserId].Loaded then
		Templates[player.UserId].Data[Stat] = State
		_ConnectRemoteDataService:Fire(player, Templates[player.UserId].Data, "Save")
	end
end

-- Development

function DataService:SetData(player, StoredData)
	if Templates[player.UserId] then
		Templates[player.UserId].Data = StoredData
		Templates[player.UserId].Loaded = true
	else
		player:Kick("Data Issue")
		return
	end
end

function DataService:CreateTemplate(player)
	if Templates[player.UserId] then
		player:Kick("Data Issue")
		return
	end

	Templates[player.UserId] = {
		Data = "None",
		Loaded = false,
	}
	
	return true
end

function DataService:Initialize()
	_ConnectDataService.Event:Connect(function(...)
		local data = {...}
		
		if data[3] and data[3] == "Load" then
			local _Data = {}
			_Data.User = data[1]
			_Data.Data = data[2]

			task.spawn(function()
				while not self:CreateTemplate(_Data.User) do
					task.wait(0.5)
				end

				self:SetData(_Data.User, _Data.Data)
			end)
		elseif data[3] and data[3] == "Update" then
			local _Data = {}
			_Data.User = data[1]
			_Data.Data = data[2]
			
			
					
			self:SetData(_Data.User, _Data.Data)
		elseif data[3] and data[3] == "Clans" then
			local _Data = {}
			_Data.Data = data[1]
			
			Clans = _Data.Data
		end
	end)
	
	task.spawn(function()
		while true do
			for _, player in pairs(Players:GetPlayers()) do
				_ConnectRemoteDataService:Fire(player, nil, "Update")
				wait(0.2)
			end
			task.wait(25)
		end
	end)
	
	task.spawn(function()
		while true do
			
			_ConnectRemoteDataService:Fire(nil, nil, "GetClans")
			
			task.wait(120)
		end
	end)
end


return DataService
