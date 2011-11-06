require "loader"
require "world"
require "player"
require "viewport"

function love.draw()
	love.graphics.setBackgroundColor(255,0,0)

  local load_data = Loader:load("world_1")

	local world = World:new():with(load_data.map)
  local player = Player:new():with(load_data.start)

  local viewport = Viewport:new()

  viewport.x = 18
  viewport.y = 15

  viewport:draw(world)
  viewport:draw(player)
end