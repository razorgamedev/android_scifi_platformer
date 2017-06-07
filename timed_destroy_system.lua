local System = require "system"

function new_timed_destroy_system()
	local system = System.new("timed-destroy", {
		"Timed_Destroy"
	})

	function system:update(dt, entity)
		local time = entity:get "Timed_Destroy"
		time.timer = time.timer - dt

		if time.timer <= 0 then
			entity:destroy()
		end
	end
	return system
end
