local bodies = {}
local solids = {}
local lines  = {}
local intersection = {x = 0, y = 0}

local push, pop = table.insert, table.remove

local gravity = 600
local dt = 0.0016

require "Body"

local
function line_intersection(a1, a2, b1, b2)
	
	local b = {
		x = a2.x - a1.x,
		y = a2.y - a1.y
	}

	local d = {
		x = b2.x - b1.x,
		y = b2.y - b1.y
	}

	local b_dot_perp = b.x * d.y - b.y * d.x

	if b_dot_perp == 0 then return false end

	local c = {
		x = b1.x - a1.x,
		y = b1.y - a1.y
	}

	local t = (c.x * d.y - c.y * d.x) / b_dot_perp
	if t < 0 or t > 1 then return false end

	local u = (c.x * b.y - c.y * b.x) / b_dot_perp
	if u < 0 or u > 1 then return false end

	intersection = {
		x = a1.x + (b.x * t),
		y = a1.y + (b.y * t)
	}

	return true
end

local
function body_contains_line(body, line)
	local a = line.a
	local b = line.b

	-- contstruct the rectangle lines
	local left, right, top, bottom = body:get_bounding_lines()

	if line_intersection(left.a, left.b, a, b) then return true end
	if line_intersection(right.a, right.b, a, b) then return true end
	if line_intersection(top.a, top.b, a, b) then return true end
	if line_intersection(bottom.a, bottom.b, a, b) then return true end

	return false
end

function addBody(b, options)
	push(bodies, b)
end

function addLine(a, b)
	push(lines, {
		a = a, b = b	
	})
end

function addSolid(x, y, width, height)
	push(solids, new_body {
		x = x,
		y = y,
		width = width,
		height = height
	})
end

function removeBody(b)
	for i, v in ipairs(bodies) do
		if v == b then
			pop(bodies, i)
			return
		end
	end
end

function physics_world_update(dt)
	dt = dt
	for i = 1, #bodies do
		local physics = bodies[i]:get "Physics"
		local body = bodies[i]:get "Body"

		local bx = new_body {
			x = body.x + physics.vel_x * dt,
			y = body.y,
			width = body.width,
			height = body.height
		}
		
		local by = new_body {
			x = body.x,
			y = body.y + physics.vel_y * dt,
			width = body.width,
			height = body.height
		}
		-- check collisions
		local intersects_ground = false
		if not physics.collide_with_solids then
			goto skip_solid_check
		end
		for j = 1, #solids do
			local solid = solids[j]
			if bx:contains(solid) then 
				-- move to top of block if the depth is small
				local depth = math.abs(body.y + body.height - solid.y)
				if body:center_x() > solid:center_x() then
					bx.x = solid.x + solid.width
				else
					bx.x = solid.x - bx.width
				end
				physics.vel_x = 0
			end

			if by:contains(solid) then 
				if by.y < solid.y then
					by.y = solid.y - by.height
					physics.vel_y = 0
					intersects_ground = true
				else
					by = body
					physics.vel_y = -physics.vel_y * 0.02 -- flip the velocity
				end
			end
		end

		for j = 1, #lines do
			local line = lines[j]
			if body_contains_line(by, line) then
				if body.y < intersection.y then
					by.y = intersection.y - by.height 
					physics.vel_y = 0
					intersects_ground = true
				elseif by.y + body.height > intersection.y then
					by = body
					physics.vel_y = -physics.vel_y * 0.02 -- flip the velocity
				end
			end
		end
		::skip_solid_check::

		physics.on_ground = intersects_ground
		
		-- apply the velocity
		physics.vel_x = physics.vel_x * (1 - (dt * 8))
	
		-- apply gravity
		physics.vel_y = physics.vel_y + gravity * dt * physics.gravity_scale
		if physics.vel_y > gravity then
			physics.vel_y = gravity
		end

		body.x = bx.x
		body.y = by.y
	end
end

function physics_world_draw()
	love.graphics.setColor(255, 0, 0)
	for i, v in ipairs(solids) do
		love.graphics.rectangle("line", v.x, v.y, v.width, v.height)	
	end

	for i, v in ipairs(lines) do
		love.graphics.line(v.a.x, v.a.y, v.b.x, v.b.y)	
	end
	
	for i = 1, #bodies do
		local v = bodies[i]:get "Body"
		local physics = bodies[i]:get "Physics"
		local body = v
		love.graphics.rectangle("line", v.x, v.y, v.width, v.height)	
		local bx = new_body {
			x = body.x + physics.vel_x * dt,
			y = body.y,
			width = body.width,
			height = body.height
		}
		
		local by = new_body {
			x = body.x,
			y = body.y + physics.vel_y * dt,
			width = body.width,
			height = body.height
		}
		love.graphics.rectangle("line", by.x, by.y, v.width, v.height)	
		love.graphics.rectangle("line", bx.x, bx.y, v.width, v.height)	
	end
	
	if intersection then
		love.graphics.circle("line",intersection.x, intersection.y, 2, 100)
	end

	love.graphics.setColor(255, 255, 255)
end










