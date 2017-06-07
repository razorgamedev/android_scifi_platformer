local push = love.graphics.push
local pop = love.graphics.pop
local trans = love.graphics.translate
local scale = love.graphics.scale

local camera = {
	x = 0,
	y = 0,
	scale = 1,
}

local timer = 0

function camera:bind()
	push()
	trans(-self.x, -self.y)
	scale(1 / self.scale, 1 / self.scale)
end

function camera:track(body)
	assert(body.__id == "Body")

	local ox = (body.x + body.width / 2) / self.scale
	local oy = (body.y + body.height / 2) / self.scale

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()

	self.x = ox - w / 2
	self.y = oy - h / 2
end

function camera:update(dt)
	timer = timer + dt	
end

function camera:zoom(by)
	self.scale = self.scale * by
end

function camera:unbind()
	pop()
end
addLoop(camera)

return camera
