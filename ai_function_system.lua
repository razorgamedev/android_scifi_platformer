local System = require "system"

function new_ai_function_system()
	local system = System.new("ai_function", {
		"Ai"
	})

	function system:update(dt, entity)
		local ai = entity:get "Ai"
		ai.ai_function(dt, entity)
	end

	return system
end
