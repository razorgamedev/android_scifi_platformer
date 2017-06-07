require "gameloop"
require "renderer"
require "sprite_renderer"
require "player_controller"
require "physics_world"
require "physics_system"
require "assets"
require "tiled_map"
require "animation"
require "animation_system"
require "asset_loader"
require "ai_function_system"
require "entity_assemblers"
require "timed_destroy_system"
require "terminal_system"
require "water_renderer"

App = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),

	world = require "world",
	camera = require "camera",

	screen_canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight()),

	debug = false,
}


function love.load()
	App.world:register(new_sprite_renderer())
	App.world:register(new_player_controller())	
	App.world:register(new_physics_system())
	App.world:register(new_animation_renderer())
	App.world:register(new_ai_function_system())
	App.world:register(new_timed_destroy_system())
	App.world:register(new_terminal_renderer())

	load_all_assets()

	new_tiled_map("assets/maps/pirate")

	App.camera:zoom(0.25)

	local water = new_water_renderer(0, 280, 800, 800, 0, -0.3)
end

function love.update(dt)
	--love.timer.sleep(0.05)
	gameloop_update(dt)
	physics_world_update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0, 150, 255)
	
	App.camera:bind()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setCanvas(App.screen_canvas)
	love.graphics.clear()
	
	renderer_draw()
	
	love.graphics.setCanvas()	
	App.camera:unbind()

	App.camera:bind()
	if App.debug then
		physics_world_draw()
	end
	App.camera:unbind()
	
	love.graphics.draw(App.screen_canvas, 0, 0)
	
	forground_renderer_draw()

	love.graphics.setColor(255, 0, 0)
	love.graphics.print(love.timer.getFPS(), 0, 0)
	love.graphics.setColor(255, 255, 255)
end

function love.keypressed(k)
	if k == "q" then
		App.debug = not App.debug	
	elseif k == "escape" then
		love.event.quit()
	elseif k == "r" then
		love.event.quit("restart")
	end
end









