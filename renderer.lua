local renderers = {}
local forground_renderers = {}
local push, pop = table.insert, table.remove
local sort = table.sort

function addRenderer(o)
	assert(o.layer, "ERROR::RENDERER object requires a layer!")
	assert(o.draw, "ERROR::RENDERER object requires a draw function!")

	push(renderers, o)
end

function removeRenderer(o)
	if o.__draw_type == "forground" then
		for i, v in ipairs(forground_renderers) do
			if v == o then
				pop(forground_renderers, i); return
			end
		end
	end

	for i, v in ipairs(renderers) do
		if v == o then
			pop(renderers, i); return
		end
	end
end

function addForgroundRenderer(o)
	assert(o.layer, "ERROR::RENDERER object requires a layer!")
	assert(o.draw, "ERROR::RENDERER object requires a draw function!")
	
	o.__draw_type = "forground"
	push(forground_renderers, o)
end

function renderer_draw()
	sort(renderers, function(a, b)	
		return a.layer < b.layer	
	end)

	for i = 1, #renderers do
		local o = renderers[i]
		o:draw()
	end
end

function forground_renderer_draw()
	sort(forground_renderers, function(a, b)	
		return a.layer < b.layer	
	end)

	for i = 1, #forground_renderers do
		local o = forground_renderers[i]
		o:draw()
	end
end
