require "world"

function love.draw()
	love.graphics.print("Hello World", 400, 300)
	love.graphics.setBackgroundColor(255,0,0)
	love.graphics.rectangle("fill", 0, 0, 32, 32)

	local world = World:new()
	world:load("world_1")
	world:draw(0,0)
end