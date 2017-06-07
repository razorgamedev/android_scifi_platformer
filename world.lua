local Entity = require "entity"

local push, pop = table.insert, table.remove
local ipairs = ipairs

local world = {
	layer = 3,
	entities = {},
	systems = {},
	
	register = function(self, system)
		table.insert(self.systems, system)
	end,

	create = function(self, entity)
		local entity = Entity.new()
		table.insert(self.entities, entity)
		return entity
	end,

	get_all_width_component = function(self, id)
		local list = {}
		for i, v in ipairs(self.entities) do
			if v:has(id) then 
				push(list, v)
			end
		end
		return list
	end,

	update = function(self, dt)
		for i = #self.entities, 1, -1 do
			local entity = self.entities[i]
			if entity.remove then
				-- remove the entity
				for i, system in ipairs(self.systems) do
					if system:match(entity) then
						system:destroy(entity)
					end
				end

				pop(self.entities, i)
			else
				if not entity.loaded then
					for i, system in ipairs(self.systems) do
						if system:match(entity) then
							system:load(entity)
						end
					end
					entity.loaded = true
				end

				for i, system in ipairs(self.systems) do
					if system:match(entity) then
						system:update(dt,entity)
					end
				end
			end
		end
	end,

	draw = function(self)
		for i = 1, #self.entities do
			local entity = self.entities[i]
			for i, system in ipairs(self.systems) do
				if system:match(entity) then
					system:bg_draw(entity)
				end
			end
		end

		for i = 1, #self.entities do
			local entity = self.entities[i]
			for i, system in ipairs(self.systems) do
				if system:match(entity) then
					system:draw(entity)
				end
			end
		end
	end
}
--world.layer = 3
addLoop(world)
addRenderer(world)

return world
