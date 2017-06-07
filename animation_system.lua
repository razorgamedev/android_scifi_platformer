local System = require "system"
local draw = love.graphics.draw

function new_animation_renderer()
	local renderer = System.new("animation_renderer", {
		"Body", "Animation"
	})

	function renderer:load(entity)
	end

	function renderer:update(dt, entity)
		local anim = entity:get "Animation"
		local body = entity:get "Body"

		local a = anim.animations[anim.animation_id]
		if a ~= nil then
			anim.frame_counter = anim.frame_counter + dt	

			if anim.frame_counter > a.speed then
				anim.frame = anim.frame + 1	
				anim.frame_counter = 0
			end

			if anim.frame > #a.frames then
				anim.frame = 1
			end

		else
			print("error: cannot find animation: " .. anim.animation_id)
		end
	end

	function renderer:draw(entity)
		local anim = entity:get "Animation"
		local body = entity:get "Body"
		
		local a = anim.animations[anim.animation_id]
		if a then
			local frame = a.frames[anim.frame]
			draw(a.image, frame, body.x + anim.offset_x, body.y + anim.offset_y, 0, anim.scale_x, anim.scale_y)	
		end
	end

	return renderer
end
