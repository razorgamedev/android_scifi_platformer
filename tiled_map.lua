local push, pop = table.insert, table.remove
local floor = math.floor

function new_tiled_map(path)
	local map = require(path)
	map.layer = 3

	-- add all the solids
	for i, layer in ipairs(map.layers) do
		if layer.type == "objectgroup" then
			for j, object in ipairs(layer.objects) do
				if object.type == "" then
					if object.shape == "rectangle" then
						addSolid(object.x, object.y, object.width, object.height)
					elseif object.shape == "polyline" then
						local a = {
							x = object.polyline[1].x + object.x,
							y = object.polyline[1].y + object.y
						}

						local b = {
							x = object.polyline[2].x + object.x,
							y = object.polyline[2].y + object.y
						}

						addLine(a, b)
					end
				else
					local id = object.type
					spawn(id, object.x, object.y)
				end
			end
		end
	end
	local tileset = map.tilesets[1].image
	local name    = tileset:match "([^/]+)$"

	map.image = love.graphics.newImage ("assets/images/" .. name)
	map.image:setFilter("nearest", "nearest")
	map.quads = {}
	
	for y = 0, (map.image:getHeight() / map.tileheight) - 1 do
		for x = 0, (map.image:getWidth() / map.tilewidth) - 1 do
			push(map.quads, love.graphics.newQuad(
				x * map.tilewidth,
				y * map.tileheight,
				map.tilewidth,
				map.tileheight,
				map.image:getWidth(),
				map.image:getHeight()
			))	
		end
	end

	function map:draw()
		local camera = App.camera
		local cx = floor((camera.x * camera.scale) / self.tilewidth)
		local cy = floor((camera.y * camera.scale) / self.tileheight)

		local cw = floor(App.width * camera.scale) / self.tilewidth
		local ch = floor(App.height * camera.scale)/ self.tileheight

		love.graphics.setColor(255, 255, 255, 255)
		for i, layer in ipairs(map.layers) do
			if layer.type ~= "tilelayer" then
				goto continue
			end

			local data = layer.data

			for y = cy, cy + ch do
				for x = cx, cx + cw do
					local tid = data[(x + y * self.width) + 1]

					if tid ~= 0 then
						local quad = self.quads[tid]
						if quad ~= nil then
							love.graphics.draw(
								self.image,
								quad, 
								x * self.tilewidth,
								y * self.tileheight
							)
						end
					end
				end
			end

			::continue::
		end

	end

	addRenderer(map)
	return map
end















