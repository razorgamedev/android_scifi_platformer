local System = require "system"
local draw = love.graphics.draw

function new_terminal_renderer()
	local renderer = System.new("renderer", {
		"Body", "Terminal"	
	})

	function renderer:load(entity)
		local sprite = entity:get "Terminal"
		assert(sprite.image, "ERROR:: entity image is null!")
		assert(sprite.quad, "ERROR:: entity quad is null!")
	end

	function renderer:bg_draw(entity)
		local body = entity:get "Body"
		local sprite = entity:get "Terminal"

		draw(sprite.image, sprite.quad, body.x + sprite.offset_x, body.y, 0, sprite.scale_x, 1)
	end

	return renderer
end
