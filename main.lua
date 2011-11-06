require "world"

function love.draw()
	love.graphics.setBackgroundColor(255,0,0)

	local world = World:new()
	world:load("world_1")
	world:draw(0,0)
end