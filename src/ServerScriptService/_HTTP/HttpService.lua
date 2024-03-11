local RemoteHttpService = {}
RemoteHttpService.__index = RemoteHttpService

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _DATA = ReplicatedStorage:WaitForChild("_DATA")
local _ConnectHttpService = _DATA:FindFirstChild("_ConnectHttpService")

local _HttpService = nil

function RemoteHttpService.new(baseUrl, authorizationKey)

	if not _HttpService then

		local self = setmetatable({}, RemoteHttpService)
		self.baseUrl = baseUrl
		self.authorizationKey = authorizationKey

		_HttpService = RemoteHttpService

		return self
	else
		return _HttpService
	end
end

function RemoteHttpService:_buildUrl(endpoint, params, requestType)	
	local url = self.baseUrl .. endpoint

	if params then
		local queryString = ""

		local encodedParams = {}
		for key, value in pairs(params) do
			local encodedValue = HttpService:UrlEncode(tostring(value))
			table.insert(encodedParams, key .. "=" .. encodedValue)
		end

		queryString = table.concat(encodedParams, "&")

		if queryString ~= "" then
			url = url .. "?" .. queryString
		end
	end

	if requestType == "GET" then
		return url .. "&Authorization=" .. self.authorizationKey
	end

	return url .. "?Authorization=" .. self.authorizationKey
end

function RemoteHttpService:sendGet(endpoint, params)
	local url = self:_buildUrl(endpoint, params, "GET")

	local success, response = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if success then
		local jsonData = self:_parseJson(response)		
		return jsonData
	else
		warn("Failed to send GET request:", response)
		return nil
	end
end

function RemoteHttpService:sendPost(endpoint, postData)
	local url = self:_buildUrl(endpoint, nil, "POST")	
	local success, response = pcall(function()
		return HttpService:PostAsync(url, HttpService:JSONEncode(postData), Enum.HttpContentType.ApplicationJson, false)
	end)

	if success then
		local jsonData = self:_parseJson(response)
		return jsonData
	else
		warn("Failed to send POST request:", response)
		return nil
	end
end

function RemoteHttpService:_parseJson(jsonString)
	local success, result = pcall(function()
		return HttpService:JSONDecode(jsonString)
	end)

	if success then
		return result
	else
		warn("Failed to parse JSON:", result)
		return nil
	end
end

function RemoteHttpService:Initialize()
	_ConnectHttpService.OnInvoke = function(RequestType, ...)
		if RequestType == "Get" then
			local Response = self:sendGet(...)
			if Response ~= nil and Response["message"] then
				return Response.message
			end
			return Response
		elseif RequestType == "Post" then
			local Response = self:sendPost(...)
			if Response ~= nil and Response["message"] then
				return Response.message
			end
			return Response
		end
	end
end

return RemoteHttpService