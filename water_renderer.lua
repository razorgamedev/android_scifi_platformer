function new_water_renderer(x, y, width, height, x_shift, y_shift)
	local water = {
		width = width, 
		x = x, 
		y = y, 
		height = height, 
		x_shift = x_shift or 0, 
		y_shift = y_shift or 0
	}

	water.layer = 10
	water.image = love.graphics.newImage "assets/images/water.png"
	water.image:setFilter "nearest"

	local simplex_def = love.filesystem.read("assets/shaders/simplex3d.glsl")

	water.shader = love.graphics.newShader (simplex_def .. [[
	#define DEGtoRAD 3.141592/180

	extern number time;
	extern number xo;
	extern number x_shift;
	extern number y_shift;

	number windspeed = 0.1;	// water flow speed
	number water_angle = 60 * DEGtoRAD;	//water apparent angle
	number ripple = 0.15; //ripple intensity
	number zoom = 0.1;	//i don't even remember why this is here
	number water_height = 0.10;
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

			//texy = water_height - (texy - water_height) * tan(water_angle);	// up-down reflection

			number ripple_ = ripple * (texy - water_height);	//ripple_ is [0] at the top of the water and [ripple] at the bottom

			texx = texx + noise * ripple_;	// wave reflection
			texy = texy + noise * ripple_;	// wave reflection

			impurities = noise * ripple_ * impurity_factor;
		}

		vec2 final_coord = vec2(texx + x_shift, texy + y_shift);
		vec4 final_pixel = Texel(texture, final_coord);
		//final_pixel.a *= 0.9;

		return final_pixel * color + impurities * color;
	}
	]])

	water.t = 0
	function water:update(dt)
		self.t = self.t + dt
		self.shader:send("time", self.t)
		self.shader:send("xo", 0)
		
		self.shader:send("x_shift", x_shift)
		self.shader:send("y_shift", y_shift)
	end

	function water:draw()
		love.graphics.setShader(self.shader)
		--love.graphics.draw(self.image, self.x, self.y, 0, 0.8, 1)
		love.graphics.setColor(50, 50, 200, 255)
		love.graphics.rectangle(
			"fill", 
			self.x, 
			self.y + (self.y-App.camera.y) - 80,
			self.width, 
			self.height	
			)

		love.graphics.draw(
			App.screen_canvas, 
			self.x, 
			self.y +  
			(self.y-App.camera.y) + 400,
			0, 
			1, 
			-1
			)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setShader()
	end

	function water:destroy()
		removeRenderer(self)
		removeLoop(self)
	end

	addLoop(water)
	addForgroundRenderer(water)

	return water
end
