-- Services
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules
local _DATA = ReplicatedStorage:WaitForChild("_DATA")
local _HTTP = ServerScriptService:WaitForChild("_HTTP")

local _CreateClan = _DATA:FindFirstChild("_CreateClan")
local _LeaveClan = _DATA:FindFirstChild("_LeaveClan")
local _DeleteClan = _DATA:FindFirstChild("_DeleteClan")

-- Http Management
local HttpService = require(_HTTP.HttpService)
local remoteHttpService = HttpService.new("https://api.desyncsystemhelix.buzz", "KeyHere")
remoteHttpService:Initialize()

-- Server Data Management (Not Global)
local DataModule = ServerScriptService:WaitForChild("_DATA")
local DataService = require(DataModule.DataService)
local RemoteDataService = require(DataModule.RemoteDataService)
local remoteDataServiceInstance = RemoteDataService.new("https://api.desyncsystemhelix.buzz", "KeyHere")
remoteDataServiceInstance:Initialize()
DataService:Initialize()