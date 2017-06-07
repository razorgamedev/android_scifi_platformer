return {
	__id = "Physics",
	
	vel_x = 0,
	vel_y = 0,
	speed_x = 600,
	gravity_scale = 1,
	bounce_scale = 0,
	speed_y = 0,
	friction = 0.9,
	on_ground = false,
	collide_with_solids = true,

	get_x_sign = function(self)
		if self.vel_x > 0 then return 1
		else return -1 end
	end
}
