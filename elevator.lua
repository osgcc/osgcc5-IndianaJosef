-- Elevator

-- Represents an elevator object

Elevator = {visible = true, working = true, width = 1, direction = "w", ignore_tile}

elevator_block_img = love.graphics.newImage("img/elevator.png")

function Elevator:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Elevator:with(position, direction, width, working, ignore_tile, world)
  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 0, 0)
  self.width = width
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 32 * self.width, 32, 0)
  self.shape:setFriction(1.0)
  self.shape:setSensor(true)
  self.direction = direction
  self.ignore_tile = ignore_tile
  self.type = "elevator"
  self.working = working
  self.shape:setData(self)

  return self
end

function Elevator:move(delta, player, world)
  local x, y = self.body:getPosition()
  if self.direction == "w" then
    self.body:setY(y - delta)
  elseif self.direction == "s" then
    self.body:setY(y + delta)
  elseif self.direction == "a" then
    self.body:setX(x - delta)
  elseif self.direction == "d" then
    self.body:setX(x + delta)
  end
  self:is_collided(player, world)

  if self:is_player_riding(player, world) then
    if self.direction == "a" then
      player:move(-delta, world)
    elseif self.direction == "d" then
      player:move(delta, world)
    end
  end
end

function Elevator:is_collided(player, world)
  -- check if reached a stop tile
  local x, y = self.body:getPosition()
  if self.direction == "s" then
    y = y - 32
  elseif self.direction == "w" then
  elseif self.direction == "a" then
    x = x - 32
  elseif self.direction == "d" then
    x = x - (32 * self.width) + 32
  end

  local wall = world:find_stop(x, y)

  if wall and self.ignore_tile ~= wall then
    self.ignore_tile = wall
    if self.direction == "w" then
      self.direction = "s"
    elseif self.direction == "s" then
      self.direction = "w"
    elseif self.direction == "a" then
      self.direction = "d"
    elseif self.direction == "d" then
      self.direction = "a"
    end
  end

  return self:is_collided_with_player(player, world)
end

function Elevator:is_player_riding(player, world)
  local ret = self:is_collided_with_player_y(player, world)

  return ret and (player:getY() - 1 < self.body:getY())
end

function Elevator:is_collided_with_player(player, world)
  local r = player:getX()
  local b = player:getY() - 1
  local l = r - 32
  local t = b - 30

  return self.shape:testPoint(r,b) or self.shape:testPoint(r,t) or self.shape:testPoint(l,b) or self.shape:testPoint(l,t)
end

function Elevator:is_collided_with_player_y(player, world)
  local r = player:getX()
  local b = player:getY()
  local l = r - 32
  local t = b - 32

  return self.shape:testPoint(r,b) or self.shape:testPoint(r,t) or self.shape:testPoint(l,b) or self.shape:testPoint(l,t)
end

function Elevator:draw(x, y)
  if self.visible == false then
    return
  end

  local x1,y1,x2,y2 = self.shape:getPoints()

  for i=1,self.width do
    love.graphics.draw(elevator_block_img, x1-x+(i-1)*32, y1-y)
  end
end