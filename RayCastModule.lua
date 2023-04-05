local module = {}

--[[
    This program is designed to retrieve the color of a specific point in a 3D space and determine whether that point is in shade or not. 
    The program takes in two values, x and z coordinates, and casts a ray from 100 studs above the point towards the ground. 
    It then retrieves the color of that specific point and returns it along with whether the point is in shade or not, which is determined 
    by casting another ray towards the direction of a light source.
]]

-- This value can be changed to adjust the direction of the light
module.LightDirection = Vector3.new(150, 200, 100)

-- This constant is multiplied by the color3 value to make the color darker
-- This is used when the point is under the shade
module.ShadingConstant = 0.65

-- RayCast parameters
local RayParams = RaycastParams.new()
RayParams.IgnoreWater = false

function module:GetRay(x : number, z : number)

	-- Cast a ray from 100 studs above the point towards the ground
	local rayResult = workspace:Raycast(Vector3.new(x, 100, z), Vector3.new(0, -1000, 0), RayParams)

	if rayResult and rayResult.Instance then

		-- Cast another ray towards the light direction to determine if the point is in shade or not
		local LightRay = workspace:Raycast(rayResult.Position, module.LightDirection, RayParams)

		local Color -- To be determined by the following if statement

		-- If the ray hits a basepart, get its color
		if rayResult.Instance:IsA("BasePart") and rayResult.Instance ~= workspace.Terrain then
			Color = rayResult.Instance.BrickColor.Color

			-- If the ray hits the terrain, get the color of the terrain in the specific area
		elseif rayResult.Instance == workspace.Terrain then
			local terrainType = rayResult.Material
			-- If the ray touched water, get the water color; otherwise, get the color of the terrain
			Color = terrainType == Enum.Material.Water and workspace.Terrain.WaterColor or workspace.Terrain:GetMaterialColor(terrainType)
		end
		
		if LightRay ~= nil then
			Color = Color3.new(Color.R * module.ShadingConstant, Color.G * module.ShadingConstant, Color.B * module.ShadingConstant)
		end

		-- Return a table with the color and whether the point is in shade or not
		return {
			Color = {math.round(Color.R * 255), math.round(Color.G * 255), math.round(Color.B * 255)},
		}

	else -- if no instance was found, return an empty white color
		return {
			Color = {255, 255, 255},
		}
	end
end

return module
