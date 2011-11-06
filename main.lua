-- Require List
require "loader"
require "world"
require "player"
require "battery"
require "book"
require "brain"
require "viewport"
require "hud"

JUMP_MAX = 32*3
PLAYER_SPEED = 300

State = {REST = 0, MOVE_LEFT = 1, MOVE_RIGHT = 2}
state = State.REST
keys_down = 0
burn_down = 0
jumping = 0
jumped = 0

burned = {}

function love.load()
  -- Size
  love.graphics.setMode(800,600,false,true,0)

  -- Load Initial World
  local load_data = Loader:load("world_2")

  world = World:new():with(load_data.map)
  player = Player:new():with(load_data.start, world)
  batteries = {}
  for i=1,#load_data.batteries do
    batteries[#batteries+1] = Battery:new():with(load_data.batteries[i], world)
  end

  books = {}
  for i=1,#load_data.books do
    books[#books+1] = Book:new():with(load_data.books[i], world)
  end

  brain = Brain:new():with(load_data.brain, world)

  viewport = Viewport:new():with(world.width*32,world.height*32,800,560)
  viewport:center(player:getX(), player:getY())

  player.energy = load_data.energy

  hud = Hud:new()
end

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
    if jumping == 0 then
      jumping = 1
    end
  elseif key == "lshift" or key == "rshift" then
    -- Burn
    burn_down = 1
  end
end

function love.keyreleased(key)
  if key == "left" then
    keys_down = keys_down - 1
  elseif key == "right" then
    keys_down = keys_down - 1
  elseif key == "lctrl" or key == "rctrl" then
    jumping = -1
  elseif key == "ralt" or key == "lalt" or key == "lshift" or key == "rshift" then
    burn_down = 0
  end

  if keys_down == 0 then
    state = State.REST
    player:rest()
    player:align()
  end
end

function love.update(dt)
  if state == State.MOVE_LEFT then
    player:rest()
    player:move(-PLAYER_SPEED*dt, world)
    player.energy = player.energy - 10 * dt
    viewport:center(player:getX(), player:getY())
  elseif state == State.MOVE_RIGHT then
    player:rest()
    player:move(PLAYER_SPEED*dt, world)
    player.energy = player.energy - 10 * dt
    viewport:center(player:getX(), player:getY())
  end

  local i = 1
  while i <= #burned do
    burned[i].time = burned[i].time - (100*dt)
    if burned[i].time <= 0 then
      burned[i].wall.visible = true
      burned[i] = burned[#burned]
      burned[#burned] = nil
    else
      i = i + 1
    end
  end

  if burn_down == 1 then
    wall = player:burn(world)
    if wall then
      burned[#burned+1] = {wall=wall, time=500}
    end
  end

--  world:foo(#burned)

  if jumping == 1 then
    local old_jumped = jumped
    jumped = jumped + 500*dt
    if jumped > JUMP_MAX then
      player:move_y(old_jumped - JUMP_MAX, world)
      jumped = JUMP_MAX
      jumping = -1
    end
    player:move_y(-500*dt, world)
  else
    jumped = jumped - PLAYER_SPEED*dt
    if jumped < 0 then
      jumped = 0
    end

    if player:move_y(PLAYER_SPEED*dt, world) == true then
      jumping = 0
    end
  end

  world.physics:update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)

  viewport:draw(world)
  viewport:draw(player)
  for i=1,#batteries do
    viewport:draw(batteries[i])
  end
  for i=1,#books do
    viewport:draw(books[i])
  end
  viewport:draw(brain)

  hud:draw(0,600-40, player.energy, player.books, #books, player.brain == 1)
end