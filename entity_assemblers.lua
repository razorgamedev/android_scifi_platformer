local Body = require "Body"
local Animation = require "animation_component"
local Physics = require "physics_body"
local Player = require "player"
local Sprite = require "Sprite"
local AI = require "ai_function"
local Timed_Destroy = require "timed_destroy"
local Terminal = require "terminal_component"

require "entity_ai"

local Entities = {
	["SpikeSpinner"] = function()
		local spike = App.world:create()
	
		spike:add(Body,{width=32, height=32})
		spike:add(Physics, {gravity_scale = 0, collide_with_solids = false})
		local sprite = spike:add(Sprite, {
			image = getAsset "entities",
			quad = love.graphics.newQuad(0, 0, 32, 32, 512, 512)
		})
		
		spike:add(AI, {
			ai_function = spike_spinner_ai
		})

		return spike
	end,

	["Terminal"] = function()
		local term = App.world:create()

		term:add(Body, {width = 96 + 16, height = 72 + 16 + 8})
		term:add(Physics,{})
		term:add(Terminal,{
			image = getAsset "terminal",
			quad = love.graphics.newQuad(0, 0, 96 + 16, 72 + 16 + 8, 256, 256)
		})
		
		return term
	end,

	["Player"] = function()
		local player = App.world:create()

		player:add(Body,{x = 0, y = 0, width = 12, height = 18})
		player:add(Animation, {
			animations = {
				["test"] = getAsset "test"
			},
			animation_id = "test",

		})
		player:add(Physics,{})
		player:add(Player, {})
		return player
	end,

	["player-bullet"] = function(vel)
		local bullet = App.world:create()
		
		bullet:add(Body, {x = x, y = y, width = 8, height = 8})	
		local sprite = bullet:add(Sprite, {
			image = getAsset "chars",
			quad = love.graphics.newQuad(0, 0, 8, 8, 256, 256)
		})
		bullet:add(Timed_Destroy, {timer = 0.4})
		
		bullet:add(Physics, {
			vel_x = vel,
			friction = 1,
			gravity_scale = 0,
		})


		return bullet
	end,

	["Thacia"] = function()
		local thacia = App.world:create()
		thacia:add(Body, {x = 0, y = 0, width = 12, height = 18})
		thacia:add(Sprite, {
			image = getAsset "chars",
			quad = love.graphics.newQuad(48, 0, 14, 20, 256, 256)
		})
		thacia:add(AI, {
			ai_function = function(dt, entity)
				local physics = entity:get "Physics"	
				local body = entity:get "Body"
				local player = App.world:get_all_width_component "Player"[1]

				if player then
					local pbody = player:get "Body"
					if pbody:center_x() > body:center_x() + 16 then
						physics.vel_x = physics.vel_x + dt * 100
					elseif pbody:center_x() - 16 < body:center_x() then
						physics.vel_x = physics.vel_x - dt * 100
					end
				end
			end
		})
		thacia:add(Physics, {})
		return thacia
	end,

	["Shark_1"] = function()
		print "Hello"
		local shark = App.world:create()
		shark:add(Body, {width = 46, height = 72})
		local anim = shark:add(Animation, {
			animations = {
				["shark_1"] = getAsset "shark_1_animation"
			},
			animation_id = "shark_1",
		})
		shark:add(Physics, {gravity_scale = 1})
		shark:add(AI, {
			ai_function = shark_1_ai
		})

		return shark
	end
}

function spawn(id, x, y, vel_x, vel_y)
	local entity = Entities[id](vel_x, vel_y)

	local body = entity:get "Body"
	if body then
		body.x = x or 0
		body.y = y or 0 
	end

	return entity
end
