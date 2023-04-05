local Http = game:GetService("HttpService")
local PORT = 3000
local Link = "http://localhost:"..PORT

local RayCastModule = require(script.Parent.ModuleScript)

local start = Vector3.new(49.5, 0, 49.5)
local endPosition = Vector3.new(-49.5, 0, -49.5)

-- This function sends the color information and some other data to the NodeJs server
function SendInformation(Path, DataToSend)
	local Encoded = Http:JSONEncode(DataToSend)
	local Response = Http:PostAsync(Link..Path, Encoded, Enum.HttpContentType.ApplicationJson)

	return Response
end

local Data = {}

-- For now, increment value is 1.
for x = start.X, endPosition.X, (endPosition.X < start.X and -1/2 or 1/2) do
	local RowColorData = {}
	for z = start.Z, endPosition.Z, (endPosition.Z < start.Z and -1/2 or 1/2) do
		local ColorDetails = RayCastModule:GetRay(x, z)
		table.insert(RowColorData, ColorDetails)
		--print("Noted pixel at", x, z)
	end
	table.insert(Data, RowColorData)
end

SendInformation("/", {["ColorInformation"] = Data})
print("Data Obtained:", Data)