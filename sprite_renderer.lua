local System = require "system"
local draw = love.graphics.draw

function new_sprite_renderer()
	local renderer = System.new("renderer", {
		"Body", "Sprite"	
	})

	function renderer:load(entity)
		local sprite = entity:get "Sprite"
		assert(sprite.image, "ERROR:: entity image is null!")
		assert(sprite.quad, "ERROR:: entity quad is null!")
	end

	function renderer:draw(entity)
		local body = entity:get "Body"
		local sprite = entity:get "Sprite"

		draw(sprite.image, sprite.quad, body.x + sprite.offset_x, body.y + sprite.offset_y, 0, sprite.scale_x, sprite.scale_y)

		sprite.draw_callback(entity)
	end

	return renderer
end
