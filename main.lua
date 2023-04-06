local Http = game:GetService("HttpService")
local PORT = 3000
local Link = "http://localhost:"..PORT

local RayCastModule = require(script.Parent.ModuleScript)

local start = Vector3.new(50, 0, 50)
local endPosition = Vector3.new(-50, 0, -50)

local incrementx = 0.5
local incrementz = 0.5

-- This function sends the color information and some other data to the NodeJs server
function SendInformation(Path, DataToSend)
	local Encoded = Http:JSONEncode(DataToSend)
	local Response = Http:PostAsync(Link..Path, Encoded, Enum.HttpContentType.ApplicationJson)

	return Response
end

function get_table_size(table)
	-- Calculates the size of a table (array of arrays) in bytes.
	local total_size = 0

	-- Calculate the size of the outer table
	total_size = total_size + #table * 44 -- Assuming each element takes 12 bytes

	for i = 1, #table do
		local row = table[i]
		-- Calculate the size of each inner table
		total_size = total_size + #row * 8  -- Assuming each element takes 8 bytes

		for j = 1, #row do
			local item = row[j]
			-- Calculate the size of each item in the inner table
			if type(item) == "number" then
				total_size = total_size + 8  -- For numbers, assuming 8 bytes
			elseif type(item) == "string" then
				total_size = total_size + #item  -- For strings, add the length in bytes
			end
		end
	end

	return total_size
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
	TotalSize += get_table_size(RowColorData)
end

SendInformation("/", {["ColorInformation"] = Data})
print("Data Obtained:", Data)
