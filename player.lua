-- Player

-- Represents the player

Player = {start = {x=0, y=0}}

function Player:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Player:with(position, world)
  self.start = position

  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 10, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 32, 32, 0)
  self.shape:setFriction(1.0)

  self.type = "player"
  self.shape:setData(self)

  return self
end

function Player:draw(x, y)
  local x1,y1,x2,y2 = self.shape:getPoints()

  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", x1-x, y1-y, 32, 32)
  love.graphics.setColor(255,255,255)

  local x2, y2 = self.body:getPosition()
  love.graphics.rectangle("fill", x2-x-3, y2-y-3, 6, 6)
end

function Player:move(delta)
  if self.suppress then
    if delta > 0 and self.suppress > 0 then
      return
    elseif delta < 0 and self.suppress < 0 then
      return
    end
  end

  self.suppress = nil
  local x = self.body:getX()

  self.body:applyForce(delta, 0)
end

function Player:suppress_movement(delta, till)
  if delta == 0 then
    self.suppress = nil
  else
    self.suppress = delta
    self.suppress_until = till
  end
end

function Player:jump()
  local vx, vy = self.body:getLinearVelocity()
  if vy < 5 then
    -- Look for a wall to the immediate left or right and suppress movement if there is one
    self.suppress = nil
    self.body:applyForce(0, -10000)
  end
end

function Player:rest()
  local vx, vy = self.body:getLinearVelocity()
  self.body:setLinearVelocity(0, vy)
end

function Player:update(world,dt)
  if player.suppress then
  else
    return
  end

  local vx, vy = self.body:getLinearVelocity()

  local x, y = self.body:getPosition()
  if vy >= 0 then
    y = y - 32
  end

  if player.suppress > 0 then
    if world:find_wall(x+1,y) == nil then
      player.suppress = nil
    end
  else
    if world:find_wall(x-33,y) == nil then
      player.suppress = nil
    end
  end
end

function Player:align()
  local x, y = self.body:getPosition()

  x = math.floor(x+0.5)

  local diff = x % 4

  if diff < 2 then
    x = x - diff
  else
    x = x + (4-diff)
  end

  self.body:setX(x)
end