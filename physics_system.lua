local System = require "system"
require "physics_world"

function new_physics_system()
	local system = System.new("physics", {
		"Physics", "Body"
	})

	function system:load(entity)
		addBody(entity, {})
	end

	function system:destroy(entity)
		removeBody(entity)	
	end

	return system
end
