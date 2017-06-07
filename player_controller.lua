local System = require "system"

local jump_height = 200

function new_player_controller()
	local controller = System.new("player_controller", {
		"Player", "Body", "Animation"
	})

	function controller:update(dt, entity)
		local body 		= entity:get "Body"
		local physics 	= entity:get "Physics"
		local sprite 	= entity:get "Animation"	
		local player 	= entity:get "Player"
		local world 	= App.world

		if love.keyboard.isDown "left" then
			physics.vel_x = physics.vel_x - physics.speed_x * dt
			sprite.scale_x = -1
			sprite.offset_x = body.width
		end

		if love.keyboard.isDown "right" then
			physics.vel_x = physics.vel_x + physics.speed_x * dt
			sprite.scale_x = 1
			sprite.offset_x = 0
		end

		if love.keyboard.isDown "z" and physics.on_ground then
			physics.vel_y = -jump_height
		end

		player.shoot_timer = player.shoot_timer - dt
		if love.keyboard.isDown "x" and player.shoot_timer <= 0 then
			local dir = physics:get_x_sign()
			spawn("player-bullet", (body.x + body.width / 2 - 4) + (body.width * dir), body.y + body.height / 2 - 4, 200 * dir)
			player.shoot_timer = player.max_shoot_time
		end

		App.camera:track(body)

	end

	return controller
end
