local Http = game:GetService("HttpService")
local PORT = 3000
local Link = "http://localhost:"..PORT

local RayCastModule = require(script.Parent.ModuleScript)

local start = Vector3.new(50, 0, 50)
local endPosition = Vector3.new(-50, 0, -50)

local incrementx = 0.125
local incrementz = 0.125

-- This function sends the color information and some other data to the NodeJs server
function SendInformation(Path : string, DataToSend : {})
	local Encoded = Http:JSONEncode(DataToSend)
	local Response = Http:PostAsync(Link..Path, Encoded, Enum.HttpContentType.ApplicationJson)

	return Response
end

function get_size(table : {[any]:Color3})
	-- Calculates the size of a table in bytes.
	return #table * 44
end

local Data = {}
local TotalSize = 0

-- For now, increment value is 1.
for x = start.X, endPosition.X, (endPosition.X < start.X and -incrementx or incrementx) do
	local RowColorData = {}
	for z = start.Z, endPosition.Z, (endPosition.Z < start.Z and -incrementz or incrementz) do
		local ColorDetails = RayCastModule:GetRay(x, z)
		table.insert(RowColorData, ColorDetails)
	end
	table.insert(Data, RowColorData)
	TotalSize += get_size(RowColorData)
	
	if (TotalSize / 1024) > 1000 then
		print("Splitting")
		SendInformation("/",  {["ColorInformation"] = Data, ["Render"] = false})
		Data = {}
		TotalSize = 0
	end
end

print("Total Size: ", TotalSize / 1024)
if Data ~= {} then
	SendInformation("/", {["ColorInformation"] = Data, ["Render"] = true})
end
print("Data Obtained:", Data)
