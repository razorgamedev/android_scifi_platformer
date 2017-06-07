local tickers = {}
local push, pop = table.insert, table.remove

function addLoop(o)
	assert(o.update, "ERROR::GAMELOOP:: object does not have an update(self, dt) function!")
	push(tickers, o)	
end

function removeLoop(o)
	for i, v in ipairs(tickers) do
		if v == o then
			pop(tickers, i); return
		end
	end
end

function gameloop_update(dt)
	for i, v in ipairs(tickers) do
		v:update(dt)
	end
end

