local TableService = {}
TableService.__index = TableService

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _DATA = ReplicatedStorage:WaitForChild("_DATA")

local _ConnectHttpService = _DATA:FindFirstChild("_ConnectHttpService")

local _TableService = nil

function TableService.new()

	if not _TableService then
		local self = setmetatable({}, TableService)
		_TableService = TableService
		return self
	else
		return _TableService
	end
end

function TableService:CreateTable(tableName, Data)
	local tableData = { 
		TableName = tableName,
		TableData = Data
	}
	local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/CreateTable", tableData)

	print(response)
end

function TableService:CreateCollum(tableName, collumName)
	local tableData = { 
		TableName = tableName,
		CollumName = collumName
	}
	local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/CreateCollum", tableData)

	print(response)
end

function TableService:DeleteRow(tableName, collumName, whereData)
	if whereData ~= nil then

		local tableData = { 
			TableName = tableName,
			CollumName = collumName,
			Where = whereData,


		}

		local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/RemoveTable", tableData)

		print(response)

	end
end

function TableService:InsertValue(tableName, collumName, value, whereData)

	if type(value) == "table" then
		local tableData = { 
			TableName = tableName,
			CollumName = "*",
			Value = value,

			Settings = {
				["TableInsert"] = true,
				["WhereToInsert"] = false
			},
		}
		local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/InsertTable", tableData)

		print(response)
	else
		local tableData = { 
			TableName = tableName,
			CollumName = collumName,
			Value = value,

			Settings = {
				TableInsert = false,
				WhereToInsert = false
			},
		}

		if whereData ~= nil then
			tableData["Where"] = whereData
			tableData.Settings.WhereToInsert = true
		end

		local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/InsertTable", tableData)
		print(response)
	end
end

function TableService:RemoveCollum(tableName, CollumName)
	local tableData = { 
		TableName = tableName,
		CollumName = CollumName
	}

	local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/RemoveCollum", tableData)
	print(response)
end

function TableService:EditValue(tableName, CollumName, value, whereData)
	local tableData = { 
		TableName = tableName,
		CollumName = CollumName,
		Value = value,
		
		whereData = whereData
	}

	local response = _ConnectHttpService:Invoke("Post", "/api/v1/roblox/EditValue", tableData)
	print(response)
end

return TableService