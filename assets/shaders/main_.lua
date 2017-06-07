local water = [[
	#define DEGtoRAD 3.141592/180

	extern number time;
	number windspeed = 1;	// water flow speed

	extern number xo;

	number water_angle = 60 * DEGtoRAD;	//water apparent angle

	number ripple = 0.1; //ripple intensity
	number zoom = 0.10;	//i don't even remember why this is here

	number water_height = 0.75;

	number impurity_factor = 20;

	vec4 effect(vec4 color, Image texture, vec2 texture_coord, vec2 pixel_coord) {
		//117

		number texx = texture_coord.x + xo,
				texy = texture_coord.y;
		
		number impurities = 0;	//this adds a little white/black where a wave/ripple is

		if(texy > water_height) {
			vec3 noisecoords = vec3(texx / zoom + time * windspeed,
									texy / zoom * tan(water_angle),
									time);

			number noise = simplex3d(noisecoords) * ripple;	//multiply by ripple to increase/decrease intensity

			texy = water_height - (texy - water_height) * tan(water_angle);	// up-down reflection

			number ripple_ = ripple * (texy - water_height);	//ripple_ is [0] at the top of the water and [ripple] at the bottom

			texx = texx + noise * ripple_;	// wave reflection
			texy = texy + noise * ripple_;	// wave reflection

			impurities = noise * ripple_ * impurity_factor;
		}

		vec2 final_coord = vec2(texx, texy);

		vec4 final_pixel = Texel(texture, final_coord);
		return final_pixel * color + impurities * color;
	}
]]

local simplex_def = love.filesystem.read("simplex3d.glsl")


function love.load()
	img = love.graphics.newImage("image.png")
	img:setWrap("repeat", "repeat")
	eff = love.graphics.newShader(simplex_def .. water)
end

function love.draw()
	love.graphics.setShader(eff)
	love.graphics.draw(img)
end

local t = 0
local x = 0
function love.update(dt)
	t = t + dt
	eff:send("time", t)
	eff:send("xo", x)

	local spd = 1;

	if love.keyboard.isDown("left") then x = x - dt * spd end
	if love.keyboard.isDown("right") then x = x + dt * spd end
end

