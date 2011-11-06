-- Require List
require "loader"
require "world"
require "player"
require "viewport"

-- Load Initial World

State = {REST = 0, MOVE_LEFT = 1, MOVE_RIGHT = 2}
state = State.REST
keys_down = 0

load_data = Loader:load("world_1")

world = World:new():with(load_data.map)
player = Player:new():with(load_data.start, world)

viewport = Viewport:new()

viewport.x = 18
viewport.y = 15

load_data = nil

-- Events

function love.keypressed(key, unicode)
  if key == "q" then
    love.event.push("q")
  elseif key == "left" then
    -- Move Left

    state = State.MOVE_LEFT
    keys_down = keys_down + 1
  elseif key == "right" then
    -- Move Right

    state = State.MOVE_RIGHT
    keys_down = keys_down + 1
  elseif key == "lctrl" or key == "rctrl" then
    -- Jump
  end
end

function love.keyreleased(key)
  if key == "left" then
    keys_down = keys_down - 1
  elseif key == "right" then
    keys_down = keys_down - 1
  elseif key == "lctrl" or key == "rctrl" then
  end

  if keys_down == 0 then
    state = State.REST
  end
end

function love.update(dt)
  if state == State.MOVE_LEFT then
    player:move(-250*dt)
  elseif state == State.MOVE_RIGHT then
    player:move(250*dt)
  end

  world.physics:update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(255,0,0)

  viewport:draw(world)
  viewport:draw(player)
end