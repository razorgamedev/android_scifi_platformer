function load_all_assets()
	local quad = love.graphics.newQuad
	-- in the future, see if we can do this asyncly
	
	local chars   = addAsset(love.graphics.newImage "assets/images/Sprite-0001.png","chars")
	local shark_1 = addAsset(love.graphics.newImage "assets/images/shark_1.png", "shark_1")
	local terminal= addAsset(love.graphics.newImage "assets/images/terminal.png", "terminal")

	local entities= addAsset(love.graphics.newImage "assets/images/entities.png", "entities")
	
	chars:setFilter 	"nearest"
	shark_1:setFilter 	"nearest"
	terminal:setFilter 	"nearest"
	entities:setFilter 	"nearest"

	addAsset(new_animation(
		"test", 
		getAsset "chars",
		{
			love.graphics.newQuad(16, 0, 14, 20, 256, 256),
			love.graphics.newQuad(32, 0, 14, 20, 256, 256),
			love.graphics.newQuad(48, 0, 14, 20, 256, 256)
		}
	), "test")

	addAsset(new_animation(
		"shark_1",
		shark_1	,
		{
			quad(46 * 0, 0,46,72, 184, 72),
			quad(46 * 1, 0,46,72, 184, 72),
			quad(46 * 2, 0,46,72, 184, 72),
			quad(46 * 3, 0,46,72, 184, 72),
			quad(46 * 2, 0,46,72, 184, 72),
			quad(46 * 1, 0,46,72, 184, 72),
		}
	), "shark_1_animation")
end
