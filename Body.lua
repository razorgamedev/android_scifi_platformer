function new_body(options)
	local options = options or {}
	return {
		__id 	= "Body",
		x 		= options.x or 0, 
		y 		= options.y or 0,
		width 	= options.width or 32,
		height 	= options.height or 32,
	
		contains = function(self, other)
			return self.x + self.width > other.x and 
			   	   self.x < other.x + other.width and
			   	   self.y + self.height > other.y and
			   	   self.y < other.y + other.height
		end,

		center_x = function(self)
			return self.x + self.width / 2
		end,

		center_y = function(self)
			return self.y + self.height / 2
		end,

		get_bounding_lines = function(self)
			local left_line = {
				a = {
					x = self.x,
					y = self.y,
				},

				b = {
					x = self.x,
					y = self.y + self.height
				}
			}

			local right_line = {
				a = {
					x = self.x + self.width,
					y = self.y,
				},

				b = {
					x = self.x + self.width,
					y = self.y + self.height
				}
			}

			local top_line = {
				a = {
					x = self.x,
					y = self.y,
				},

				b = {
					x = self.x + self.width,
					y = self.y
				}
			}

			local bottom_line = {
				a = {
					x = self.x,
					y = self.y + self.height
				},

				b = {
					x = self.x + self.width,
					y = self.y + self.height
				}
			}

			return  left_line, 
					right_line, 
					top_line, 
					bottom_line
		end
	}
end

return new_body()











