require 'utils'

return {
	new = function()
		local entity = {}
		
		entity.remove = false
		entity.loaded = false
		entity.components = {}

		function entity:add(component, args)
			local comp = table.new(component)
			assert(comp.__id)

			if args then
				assert(type(args) == 'table')
			end

			self.components[comp.__id] = comp
			
			if args then
				for key, v in pairs(args) do
					comp[key] = v
				end
			end
			return comp
		end

		function entity:get(id)
			return self.components[id]
		end

		function entity:has(id)
			return self.components[id] ~= nil
		end

		function entity:destroy()
			self.remove = true
		end

		return entity
	end
}
