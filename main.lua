require "loader"
require "world"
require "player"

function love.draw()
	love.graphics.setBackgroundColor(255,0,0)

  local load_data = Loader:load("world_1")

	local world = World:new():with(load_data.map)
  local player = Player:new():with(load_data.start)

	world:draw(10,10)
	player:draw(10,10)
end