local shark_jump_height = 500
local draw = love.graphics.draw

function shark_1_ai(dt, entity)
	local physics = entity:get "Physics"
	local body = entity:get "Body"
	local anim = entity:get "Animation"

	if entity.__ai_loaded == nil then
		entity.__ai_loaded = true

		-- load the entity
		entity.start_y = body.y

		return
	end

	if body.y >= entity.start_y + body.height * 2 then
		physics.vel_y = -shark_jump_height	
	end

	if physics.vel_y > 0 then
		anim.scale_y = -1 
		anim.offset_y = body.height
	else
		anim.scale_y = 1
		anim.offset_y = 0
	end
end

function spike_spinner_draw(entity)
	local body = entity:get "Body"
	local sprite = entity:get "Sprite"

 	for i = 1, 100 do

		local x = entity.start_x + (math.cos(entity.timer * 3) * 2) + body.width / 2
		local y = entity.start_y + (math.sin(entity.timer * 3) * 2) + body.height / 2

		
		draw(sprite.image, sprite.quad, x + sprite.offset_x, y + sprite.offset_y, 0, 0.2, 0.2)
	end
end

function spike_spinner_ai(dt, entity)
	local body = entity:get "Body"
	local sprite = entity:get "Sprite"

	if entity.__ai_loaded == nil then
		entity.__ai_loaded = true
		entity.timer = 0	
		entity.start_x = body.x
		entity.start_y = body.y
		sprite.draw_callback = spike_spinner_draw
		return
	end

	entity.timer = entity.timer + dt
	body.x = body.x + math.cos(entity.timer * 3) * 3
	body.y = body.y + math.sin(entity.timer * 3) * 3
end
